package ConfilctDetecter
import chisel3._
import chisel3.util._
import os.read.inputStream

class ConfilctDetecter extends Module {
  val io = IO(new Bundle {
    val need_r1    = Input(Bool())
    val need_r1_r2 = Input(Bool())
    val waddr_Ex   = Input(UInt(5.W))
    val waddr_Mem  = Input(UInt(5.W))
    val waddr_WB   = Input(UInt(5.W))
    val raddr1     = Input(UInt(5.W))
    val raddr2     = Input(UInt(5.W))
    
    val forward_source1 = Output(UInt(5.W))
    val forward_source2 = Output(UInt(5.W))

    val valid_IF   = Output(Bool())
    val valid_ID   = Input(Bool())
    val valid_Ex   = Input(Bool())
    val valid_Mem  = Input(Bool())
    val valid_WB   = Input(Bool())
    val wen_Ex     = Input(Bool())
    val wen_Mem    = Input(Bool())
    val wen_WB     = Input(Bool())
    val br_taken   = Input(Bool())
    val inst_ld_Ex = Input(Bool())
    val inst_ld_Mem= Input(Bool())
    val ALU_Busy   = Input(Bool())

    val readygo_IF = Output(Bool())
    val readygo_ID = Output(Bool())
    val readygo_Ex = Output(Bool())
    val readygo_Mem= Output(Bool())
    val readygo_WB = Output(Bool())
  })

  val stop_IF   = false.B
  val stop_ID_1 = WireDefault(false.B)      //这种方式进行默认赋值，在后面的判断中不赋值也不会产生Latch。这种方式用于内部连线。
  val stop_ID_2 = WireDefault(false.B)
  val stop_ID   = stop_ID_1 | stop_ID_2
  val stop_Ex   = io.ALU_Busy
  val stop_Mem  = false.B
  val stop_WB   = false.B

  io.valid_IF   := ~io.br_taken & ~reset.asBool

  io.readygo_IF := io.readygo_ID & ~stop_IF
  io.readygo_ID := io.readygo_Ex & ~stop_ID
  io.readygo_Ex := io.readygo_Mem& ~stop_Ex
  io.readygo_Mem:= io.readygo_WB & ~stop_Mem
  io.readygo_WB := ~stop_WB

    io.forward_source1 := "h1".U            //这种方式也是用于默认赋值。但是用于对外信号。
    when(io.valid_ID) {
        when((io.raddr1 === io.waddr_Ex) && (io.waddr_Ex =/= 0.U) && io.valid_Ex && io.wen_Ex && (io.need_r1 || io.need_r1_r2)) {
            when(io.inst_ld_Ex) {
              stop_ID_1 := true.B
            }.otherwise {
              io.forward_source1 := "h2".U
            }
        }.elsewhen((io.raddr1 === io.waddr_Mem) && (io.waddr_Mem =/= 0.U) && io.valid_Mem && io.wen_Mem && (io.need_r1 || io.need_r1_r2)) {
          io.forward_source1 := Mux(io.inst_ld_Mem, "h4".U, "h8".U)
        }.elsewhen((io.raddr1 === io.waddr_WB) && (io.waddr_WB =/= 0.U) && io.valid_WB && io.wen_WB && (io.need_r1 || io.need_r1_r2)) {
          io.forward_source1 := "h10".U
        }
    }

  io.forward_source2 := "h2".U
  when(io.valid_ID) {
    when((io.raddr2 === io.waddr_Ex) && (io.waddr_Ex =/= 0.U) && io.valid_Ex && io.wen_Ex && io.need_r1_r2) {
      when(io.inst_ld_Ex) {
        stop_ID_2 := true.B
      }.otherwise {
        io.forward_source2 := "h2".U
      }
    }.elsewhen((io.raddr2 === io.waddr_Mem) && (io.waddr_Mem =/= 0.U) && io.valid_Mem && io.wen_Mem && io.need_r1_r2) {
      io.forward_source2 := Mux(io.inst_ld_Mem, "h4".U, "h8".U)
    }.elsewhen((io.raddr2 === io.waddr_WB) && (io.waddr_WB =/= 0.U) && io.valid_WB && io.wen_WB && io.need_r1_r2) {
      io.forward_source2 := "h10".U
    }
  }
}
