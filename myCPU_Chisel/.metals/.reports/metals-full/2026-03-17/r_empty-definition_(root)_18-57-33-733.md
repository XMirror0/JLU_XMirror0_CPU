error id: file://<WORKSPACE>/src/main/scala/ConfilctDetecter/ConfilctDetecter.scala:
file://<WORKSPACE>/src/main/scala/ConfilctDetecter/ConfilctDetecter.scala
empty definition using pc, found symbol in pc: 
empty definition using semanticdb
empty definition using fallback
non-local guesses:
	 -chisel3/Ex_Busy.
	 -chisel3/Ex_Busy#
	 -chisel3/Ex_Busy().
	 -chisel3/util/Ex_Busy.
	 -chisel3/util/Ex_Busy#
	 -chisel3/util/Ex_Busy().
	 -Ex_Busy.
	 -Ex_Busy#
	 -Ex_Busy().
	 -scala/Predef.Ex_Busy.
	 -scala/Predef.Ex_Busy#
	 -scala/Predef.Ex_Busy().
offset: 1284
uri: file://<WORKSPACE>/src/main/scala/ConfilctDetecter/ConfilctDetecter.scala
text:
```scala
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
    val Ex_Busy   = Input(Bool())

    val readygo_IF = Output(Bool())
    val readygo_ID = Output(Bool())
    val readygo_Ex = Output(Bool())
    val readygo_Mem= Output(Bool())
    val readygo_WB = Output(Bool())
  })

  val stop_IF = false.B
  val stop_ID_1 = WireDefault(false.B)
  val stop_ID_2 = WireDefault(false.B)
  val stop_ID   = stop_ID_1 | stop_ID_2
  val stop_Ex   = Ex_B@@usy
  val stop_Mem  = false.B
  val stop_WB   = false.B

  io.valid_IF   := ~io.br_taken & ~reset.asBool

  io.readygo_IF := io.readygo_ID & ~stop_IF
  io.readygo_ID := io.readygo_Ex & ~stop_ID
  io.readygo_Ex := io.readygo_Mem& ~stop_Ex
  io.readygo_Mem:= io.readygo_WB & ~stop_Mem
  io.readygo_WB := ~stop_WB



}

```


#### Short summary: 

empty definition using pc, found symbol in pc: 