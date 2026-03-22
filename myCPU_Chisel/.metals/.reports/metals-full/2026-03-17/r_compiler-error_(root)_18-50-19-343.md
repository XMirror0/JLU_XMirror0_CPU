error id: FA49C6FB03BEC16962D4A7B1C7609502
file://<WORKSPACE>/src/main/scala/ConfilctDetecter/ConfilctDetecter.scala
### scala.ScalaReflectionException: value stop_ID is not a method

occurred in the presentation compiler.



action parameters:
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
    val ALU_Busy   = Input(Bool())

    val readygo_IF = Output(Bool())
    val readygo_ID = Output(Bool())
    val readygo_Ex = Output(Bool())
    val readygo_Mem= Output(Bool())
    val readygo_WB = Output(Bool())
  })

  val stop_IF = false.B
  val stop_ID_1 = WireDefault(false.B)
  val stop_ID_2 = WireDefault(false.B)
  val stop_ID   = stop_ID_1 | 
}

```


presentation compiler configuration:
Scala version: 2.13.18
Classpath:
<WORKSPACE>/.bloop/root/bloop-bsp-clients-classes/classes-Metals-h0EBTrrcSEWIDleKSGJg3g== [exists ], <HOME>/.cache/bloop/semanticdb/com.sourcegraph.semanticdb-javac.0.11.2/semanticdb-javac-0.11.2.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-library/2.13.18/scala-library-2.13.18.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/chipsalliance/chisel_2.13/7.7.0/chisel_2.13-7.7.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/github/scopt/scopt_2.13/4.1.0/scopt_2.13-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/apache/commons/commons-text/1.15.0/commons-text-1.15.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/os-lib_2.13/0.10.7/os-lib_2.13-0.10.7.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/io/github/json4s/json4s-native_2.13/4.1.0/json4s-native_2.13-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/io/github/alexarchambault/data-class_2.13/0.2.7/data-class_2.13-0.2.7.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/scala-reflect/2.13.18/scala-reflect-2.13.18.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/upickle_2.13/3.3.1/upickle_2.13-3.3.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/chipsalliance/firtool-resolver_2.13/2.0.1/firtool-resolver_2.13-2.0.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/apache/commons/commons-lang3/3.20.0/commons-lang3-3.20.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/geny_2.13/1.1.1/geny_2.13-1.1.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/io/github/json4s/json4s-core_2.13/4.1.0/json4s-core_2.13-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/io/github/json4s/json4s-native-core_2.13/4.1.0/json4s-native-core_2.13-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/ujson_2.13/3.3.1/ujson_2.13-3.3.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/upack_2.13/3.3.1/upack_2.13-3.3.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/upickle-implicits_2.13/3.3.1/upickle-implicits_2.13-3.3.1.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/modules/scala-xml_2.13/2.2.0/scala-xml_2.13-2.2.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/org/scala-lang/modules/scala-collection-compat_2.13/2.11.0/scala-collection-compat_2.13-2.11.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/io/github/json4s/json4s-ast_2.13/4.1.0/json4s-ast_2.13-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/io/github/json4s/json4s-scalap_2.13/4.1.0/json4s-scalap_2.13-4.1.0.jar [exists ], <HOME>/.cache/coursier/v1/https/repo1.maven.org/maven2/com/lihaoyi/upickle-core_2.13/3.3.1/upickle-core_2.13-3.3.1.jar [exists ]
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

scala.ScalaReflectionException: value stop_ID is not a method