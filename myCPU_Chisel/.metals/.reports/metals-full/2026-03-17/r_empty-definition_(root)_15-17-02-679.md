error id: file://<WORKSPACE>/src/main/scala/ALU/ALU.scala:
file://<WORKSPACE>/src/main/scala/ALU/ALU.scala
empty definition using pc, found symbol in pc: 
empty definition using semanticdb
empty definition using fallback
non-local guesses:
	 -chisel3/clock.
	 -chisel3/clock#
	 -chisel3/clock().
	 -chisel3/util/clock.
	 -chisel3/util/clock#
	 -chisel3/util/clock().
	 -clock.
	 -clock#
	 -clock().
	 -scala/Predef.clock.
	 -scala/Predef.clock#
	 -scala/Predef.clock().
offset: 3541
uri: file://<WORKSPACE>/src/main/scala/ALU/ALU.scala
text:
```scala
package ALU
import chisel3._
import chisel3.util._

class div_signed extends BlackBox {
    val io = IO(new Bundle {
        val aclk                    = Input(Clock())
        val s_axis_divisor_tvalid   = Input(Bool())
        val s_axis_divisor_tready   = Output(Bool())
        val s_axis_divisor_tdata    = Input(UInt(32.W))
        val s_axis_dividend_tvalid  = Input(Bool())
        val s_axis_dividend_tready  = Output(Bool())
        val s_axis_dividend_tdata   = Input(UInt(32.W))
        val m_axis_dout_tvalid      = Input(Bool())
        val m_axis_dout_tdata       = Input(UInt(64.W))
    })
}
class div_unsigned extends BlackBox {
    val io = IO(new Bundle {
        val aclk                    = Input(Clock())
        val s_axis_divisor_tvalid   = Input(Bool())
        val s_axis_divisor_tready   = Output(Bool())
        val s_axis_divisor_tdata    = Input(UInt(32.W))
        val s_axis_dividend_tvalid  = Input(Bool())
        val s_axis_dividend_tready  = Output(Bool())
        val s_axis_dividend_tdata   = Input(UInt(32.W))
        val m_axis_dout_tvalid      = Input(Bool())
        val m_axis_dout_tdata       = Input(UInt(64.W))
    })
}


class ALU {
    val io = IO(new Bundle {
        val valid_Ex = Input(Bool())
        val alu_op   = Input(UInt(19.W))
        val source1  = Input(UInt(32.W))
        val source2  = Input(UInt(32.W))
        val ALU_Busy = Output(Bool())
        val ALU_Res  = Output(UInt(32.W))
        val Res_Ready= Output(Bool())
    })

    val op_add   = io.alu_op(0)
    val op_sub   = io.alu_op(1)
    val op_slt   = io.alu_op(2)
    val op_sltu  = io.alu_op(3)
    val op_and   = io.alu_op(4)
    val op_nor   = io.alu_op(5)
    val op_or    = io.alu_op(6)
    val op_xor   = io.alu_op(7)
    val op_sll   = io.alu_op(8)
    val op_srl   = io.alu_op(9)
    val op_sra   = io.alu_op(10)
    val op_lui   = io.alu_op(11)
    val op_mul   = io.alu_op(12)
    val op_mulh  = io.alu_op(13)
    val op_mulhu = io.alu_op(14)
    val op_div   = io.alu_op(15)
    val op_divu  = io.alu_op(16)
    val op_mod   = io.alu_op(17)
    val op_modu  = io.alu_op(18)

    val u_div_signed = Module(new div_signed)
    val u_div_unsigned = Module(new div_unsigned)

    val s_idle :: s_send :: s_wait :: Nil = Enum(3)
    val div_state = RegInit(s_idle)
    val saved_src1 = Reg(UInt(32.W))
    val saved_src2 = Reg(UInt(32.W))
    val is_unsigned_div = Reg(Bool())

    val div_op = op_div || op_divu || op_mod || op_modu

    switch(div_state) {
        is(s_idle) {
            when(io.valid_Ex && div_op) {
                div_state := s_send
                saved_src1 := io.source1
                saved_src2 := io.source2
                is_unsigned_div := (op_divu || op_modu)
            }
        }
        is(s_send) {
            val ip_ready = Mux(is_unsigned_div, 
            u_div_unsigned.io.s_axis_dividend_tready && u_div_unsigned.io.s_axis_divisor_tready, 
            u_div_signed.io.s_axis_dividend_tready && u_div_signed.io.s_axis_divisor_tready)
            when(ip_ready) {
                div_state := s_idle
            }
        }
        is(s_wait) {
            val ip_valid = Mux(is_unsigned_div, 
            u_div_unsigned.io.m_axis_dout_tvalid, 
            u_div_signed.io.m_axis_dout_tvalid)
            when(ip_valid && io.Res_Ready) {
                div_state := s_idle
            }
        }
    }

    val data_valid = (div_state === s_send)
    val cpu_ready  = (div_state === s_wait) && io.Res_Ready

    u_div_signed.io.aclk                    := clo@@ck
    u_div_signed.io.s_axis_dividend_tvalid  := data_valid && !is_unsigned_div
    u_div_signed.io.s_axis_divisor_tvalid   := data_valid && !is_unsigned_div
    u_div_signed.io.s_axis_dividend_tdata   := saved_src1
    u_div_signed.io.s_axis_divisor_tdata    := saved_src2
    u_div_signed.io.m_axis_dout_tvalid
}

```


#### Short summary: 

empty definition using pc, found symbol in pc: 