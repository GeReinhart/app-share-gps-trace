
import "../../lib/trace.dart" ;

class TraceAnalysisRenderer {
  
  TraceAnalysis _traceAnalysis ;
  
  TraceAnalysisRenderer();
  
  TraceAnalysisRenderer.fromTraceAnalysis(this._traceAnalysis);
 
  List<TracePoint> get points => _traceAnalysis.points;
 
  TracePoint get upperPoint => _traceAnalysis.upperPoint;
  
  num get length => _traceAnalysis.length ;
  
  num get up => _traceAnalysis.up ;
  
  num get inclinationUp => _traceAnalysis.inclinationUp ;
  
  int get difficulty => _traceAnalysis.difficulty ;
}

