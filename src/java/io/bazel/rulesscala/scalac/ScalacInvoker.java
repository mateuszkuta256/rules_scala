package io.bazel.rulesscala.scalac;

import io.bazel.rulesscala.scalac.reporter.DepsTrackingReporter;
import io.bazel.rulesscala.scalac.compileoptions.CompileOptions;
import java.nio.file.Paths;
import io.bazel.rulesscala.scalac.reporter.ProtoReporter;
import scala.tools.nsc.reporters.ConsoleReporter;
import java.io.IOException;
import java.util.Arrays;
import java.nio.file.Files;

//Invokes Scala 2 compiler
class ScalacInvoker{
   
  public static ScalacInvokerResults invokeCompiler(CompileOptions ops, String[] compilerArgs)
    throws IOException, Exception{

    ReportableMainClass comp = new ReportableMainClass(ops);

    ScalacInvokerResults results = new ScalacInvokerResults();
    
    results.startTime = System.currentTimeMillis();
    try {
      comp.process(compilerArgs);
    } catch (Throwable ex) {
      if (ex.toString().contains("scala.reflect.internal.Types$TypeError")) {
        throw new RuntimeException("Build failure with type error", ex);
      } else if (ex.toString().contains("java.lang.StackOverflowError")) {
        throw new RuntimeException("Build failure with StackOverflowError", ex);
      } else if (isMacroException(ex)) {
        throw new RuntimeException("Build failure during macro expansion", ex);
      } else {
        throw ex;
      }
    }

    results.stopTime = System.currentTimeMillis();
    
    ConsoleReporter reporter = (ConsoleReporter) comp.getReporter();
    if (reporter instanceof ProtoReporter) {
      ProtoReporter protoReporter = (ProtoReporter) reporter;
    }

    if (reporter instanceof DepsTrackingReporter) {
      DepsTrackingReporter depTrackingReporter = (DepsTrackingReporter) reporter;
      depTrackingReporter.prepareReport();
    }

    if (reporter.hasErrors()) {
      reporter.flush();
      throw new RuntimeException("Build failed");
    }

    return results;
  }

  public static boolean isMacroException(Throwable ex) {
    for (StackTraceElement elem : ex.getStackTrace()) {
      if (elem.getMethodName().equals("macroExpand")) {
        return true;
      }
    }
    return false;
  }
}
