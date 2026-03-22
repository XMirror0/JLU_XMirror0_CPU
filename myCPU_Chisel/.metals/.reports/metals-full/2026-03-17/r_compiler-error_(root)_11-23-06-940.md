error id: FA49C6FB03BEC16962D4A7B1C7609502
file://<WORKSPACE>/src/main/scala/ALU/ALU.scala
### scala.ScalaReflectionException: value cpu_ready is not a method

occurred in the presentation compiler.



action parameters:
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
    val cpu_ready  = (div_state ===)
}

```


presentation compiler configuration:
Scala version: 2.13.18
Classpath:
<WORKSPACE>/.bloop/root/bloop-bsp-clients-classes/classes-Metals-JdLGyHzgQBS3oM9Jk8MtrA== [exists ], <HOME>/.cache/bloop/semanticdb/com.sourcegraph.semanticdb-javac.0.11.2/semanticdb-javac-0.11.2.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.13.18/scala-library-2.13.18.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/chipsalliance/chisel_2.13/7.7.0/chisel_2.13-7.7.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/github/scopt/scopt_2.13/4.1.0/scopt_2.13-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/apache/commons/commons-text/1.15.0/commons-text-1.15.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/os-lib_2.13/0.10.7/os-lib_2.13-0.10.7.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/io/github/json4s/json4s-native_2.13/4.1.0/json4s-native_2.13-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/io/github/alexarchambault/data-class_2.13/0.2.7/data-class_2.13-0.2.7.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-reflect/2.13.18/scala-reflect-2.13.18.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/upickle_2.13/3.3.1/upickle_2.13-3.3.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/chipsalliance/firtool-resolver_2.13/2.0.1/firtool-resolver_2.13-2.0.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/apache/commons/commons-lang3/3.20.0/commons-lang3-3.20.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/geny_2.13/1.1.1/geny_2.13-1.1.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/io/github/json4s/json4s-core_2.13/4.1.0/json4s-core_2.13-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/io/github/json4s/json4s-native-core_2.13/4.1.0/json4s-native-core_2.13-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/ujson_2.13/3.3.1/ujson_2.13-3.3.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/upack_2.13/3.3.1/upack_2.13-3.3.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/upickle-implicits_2.13/3.3.1/upickle-implicits_2.13-3.3.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/modules/scala-xml_2.13/2.2.0/scala-xml_2.13-2.2.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/modules/scala-collection-compat_2.13/2.11.0/scala-collection-compat_2.13-2.11.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/io/github/json4s/json4s-ast_2.13/4.1.0/json4s-ast_2.13-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/io/github/json4s/json4s-scalap_2.13/4.1.0/json4s-scalap_2.13-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/upickle-core_2.13/3.3.1/upickle-core_2.13-3.3.1.jar [exists ]
Options:
-language:reflectiveCalls -deprecation -feature -Xcheckinit -Ymacro-annotations -Yrangepos -Xplugin-require:semanticdb




#### Error stacktrace:

```
scala.reflect.api.Symbols$SymbolApi.asMethod(Symbols.scala:240)
	scala.reflect.api.Symbols$SymbolApi.asMethod$(Symbols.scala:234)
	scala.reflect.internal.Symbols$SymbolContextApiImpl.asMethod(Symbols.scala:101)
	scala.tools.nsc.typechecker.ContextErrors$TyperContextErrors$TyperErrorGen$.MissingArgsForMethodTpeError(ContextErrors.scala:818)
	scala.tools.nsc.typechecker.Typers$Typer.adaptMethodTypeToExpr$1(Typers.scala:909)
	scala.tools.nsc.typechecker.Typers$Typer.adapt(Typers.scala:1266)
	scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:6375)
	scala.tools.nsc.typechecker.Typers$Typer.typedDefDef(Typers.scala:6624)
	scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:6266)
	scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:6360)
	scala.tools.nsc.typechecker.Typers$Typer.typedStat$1(Typers.scala:6438)
	scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$5(Typers.scala:3479)
	scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$5$adapted(Typers.scala:3474)
	scala.reflect.internal.Scopes$Scope.foreach(Scopes.scala:455)
	scala.tools.nsc.typechecker.Typers$Typer.addSynthetics$1(Typers.scala:3474)
	scala.tools.nsc.typechecker.Typers$Typer.typedStats(Typers.scala:3542)
	scala.tools.nsc.typechecker.Typers$Typer.typedTemplate(Typers.scala:2074)
	scala.tools.nsc.typechecker.Typers$Typer.typedClassDef(Typers.scala:1912)
	scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:6267)
	scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:6360)
	scala.tools.nsc.typechecker.Typers$Typer.typedStat$1(Typers.scala:6438)
	scala.tools.nsc.typechecker.Typers$Typer.$anonfun$typedStats$10(Typers.scala:3530)
	scala.tools.nsc.typechecker.Typers$Typer.typedStats(Typers.scala:3530)
	scala.tools.nsc.typechecker.Typers$Typer.typedPackageDef$1(Typers.scala:5934)
	scala.tools.nsc.typechecker.Typers$Typer.typed1(Typers.scala:6270)
	scala.tools.nsc.typechecker.Typers$Typer.typed(Typers.scala:6360)
	scala.tools.nsc.typechecker.Analyzer$typerFactory$TyperPhase.apply(Analyzer.scala:143)
	scala.tools.nsc.Global$GlobalPhase.applyPhase(Global.scala:485)
	scala.tools.nsc.interactive.Global$TyperRun.applyPhase(Global.scala:1371)
	scala.tools.nsc.interactive.Global$TyperRun.typeCheck(Global.scala:1364)
	scala.tools.nsc.interactive.Global.typeCheck(Global.scala:679)
	scala.meta.internal.pc.WithCompilationUnit.<init>(WithCompilationUnit.scala:24)
	scala.meta.internal.pc.SimpleCollector.<init>(PcCollector.scala:348)
	scala.meta.internal.pc.PcSemanticTokensProvider$Collector$.<init>(PcSemanticTokensProvider.scala:19)
	scala.meta.internal.pc.PcSemanticTokensProvider.Collector$lzycompute$1(PcSemanticTokensProvider.scala:19)
	scala.meta.internal.pc.PcSemanticTokensProvider.Collector(PcSemanticTokensProvider.scala:19)
	scala.meta.internal.pc.PcSemanticTokensProvider.provide(PcSemanticTokensProvider.scala:73)
	scala.meta.internal.pc.ScalaPresentationCompiler.$anonfun$semanticTokens$1(ScalaPresentationCompiler.scala:207)
	scala.meta.internal.pc.CompilerAccess.retryWithCleanCompiler(CompilerAccess.scala:182)
	scala.meta.internal.pc.CompilerAccess.$anonfun$withSharedCompiler$1(CompilerAccess.scala:155)
	scala.Option.map(Option.scala:242)
	scala.meta.internal.pc.CompilerAccess.withSharedCompiler(CompilerAccess.scala:154)
	scala.meta.internal.pc.CompilerAccess.$anonfun$withInterruptableCompiler$1(CompilerAccess.scala:92)
	scala.meta.internal.pc.CompilerAccess.$anonfun$onCompilerJobQueue$1(CompilerAccess.scala:209)
	scala.meta.internal.pc.CompilerJobQueue$Job.run(CompilerJobQueue.scala:152)
	java.base/java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1144)
	java.base/java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:642)
	java.base/java.lang.Thread.run(Thread.java:1583)
```
#### Short summary: 

scala.ScalaReflectionException: value cpu_ready is not a method