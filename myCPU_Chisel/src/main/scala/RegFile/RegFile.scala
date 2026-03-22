package RegFile
import chisel3._
import chisel3.util._

class RegFile extends Module{
    val io = IO(new Bundle {
        val raddr1      = Input(UInt(5.W))
        val raddr2      = Input(UInt(5.W))
        val waddr       = Input(UInt(5.W))
        val wen         = Input(Bool())
        val wdata       = Input(UInt(32.W))
        val rdata1      = Output(UInt(32.W))
        val rdata2      = Output(UInt(32.W))
    })

    val regfile = RegInit(VecInit(Seq.fill(32)(0.U(32.W))))
    io.rdata1 := Mux(io.raddr1 === 0.U, 0.U, regfile(io.raddr1))
    io.rdata2 := Mux(io.raddr2 === 0.U, 0.U, regfile(io.raddr2))

    when(io.wen && io.waddr =/= 0.U)
    {
        regfile(io.waddr) := io.wdata
    }
}
