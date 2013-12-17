
import "../../lib/trace.dart" ;
import "../../lib/models.dart" ;
import "../../lib/i18n.dart" ;

class TraceFormRenderer {
  
  Map<String,String> _activities = null;
  
  Map<String,String> get activities {
    if (_activities == null){
       _activities = new Map<String,String>();
      TraceDomains.getActivitiesKeys().forEach (
          (k) => _activities[k] = I18n.translate(k)
      ); 
    }
    return _activities;
  }
  
}


class LigthTraceRenderer{
  
  Trace trace;
  
  LigthTraceRenderer(this.trace);
 
  String get key => (trace.key);
  String get creator => (trace.creator);
  String get title => (trace.title);
  String get titleWithUrl => ('<a href="/trace/${key}"  target="_blank">${title}</a>' ) ;
  String get length => ("${trace.length/1000.round()} km") ;
  String get up => ("${trace.up} m") ;
  String get upperPointElevetion => ("${trace.upperPointElevetion.round()} m") ;
  String get inclinationUp => ("${trace.inclinationUp} %") ;  
  String get difficulty => ("${trace.difficulty} pt") ;  
  
  String get activities {

    if(trace.activities == null){
      return "";
    }
    if(trace.activities.isEmpty){
      return "";
    }
    Iterator iter = trace.activities.iterator ;
    iter.moveNext();
    String activities =   I18n.translate("activity-"+iter.current);
    while( iter.moveNext() ){
      activities += ", ${I18n.translate("activity-"+iter.current)}"; 
    }
    return activities;
  }
  
  
  
}

class TraceRenderer extends LigthTraceRenderer{
  
  TraceAnalysisRenderer traceAnalysisRenderer ;
  String gpxUrl ;
  String permanentTraceUrl ;
  
  TraceRenderer(Trace trace,String permanentTraceUrl,String gpxUrl): super(trace){
    this.permanentTraceUrl=permanentTraceUrl;
    this.gpxUrl = gpxUrl;
    trace.traceAnalysis.gpxUrl = gpxUrl;
    this.traceAnalysisRenderer = new TraceAnalysisRenderer(trace.traceAnalysis);
  }
  
  String get description {
    
    if(trace.description.isEmpty){
      return "";
    }
    String description = "";
    List<String> parts =  trace.description.split("\r\n");
    for(var iter = parts.iterator ;  iter.moveNext() ;){
      description += "<p>${iter.current}</p>" ; 
    }
    return description;
  }

}

class TraceAnalysisRenderer {
  
  TraceAnalysis _traceAnalysis ;
  
  TraceAnalysisRenderer(this._traceAnalysis);
  
  List<TracePointRenderer> get points {
    List<TracePointRenderer> tracePointRenderers = new List<TracePointRenderer>();
    for(TracePoint tracePoint in   _traceAnalysis.points ){
      tracePointRenderers.add(   new TracePointRenderer(tracePoint)) ;
    }
    return tracePointRenderers ;
  }
 
  String get gpxUrl => _traceAnalysis.gpxUrl ;

  TracePoint get startPoint => _traceAnalysis.startPoint ;
  
  int get skyElevetionInMeters => _traceAnalysis.upperPoint.elevetion.round() + 500 ;

  int get lengthKmPart => (_traceAnalysis.length/1000).truncate() ;

  int get lengthMetersPart => ( _traceAnalysis.length- (_traceAnalysis.length/1000).truncate()*1000)  ; 
  
  num get up => _traceAnalysis.up ;
  
  num get inclinationUp => _traceAnalysis.inclinationUp ;
  
  DistanceInclinationElevetion get maxInclinationUp => _traceAnalysis.maxInclinationUp ;
  
  int get upperPointElevetion => _traceAnalysis.upperPoint.elevetion.round();
  
  int get difficulty => _traceAnalysis.difficulty ;
  
  double get traceHeightWidthRatio => _traceAnalysis.upperPoint.elevetion / _traceAnalysis.length ;
  
}

class TracePointRenderer {
  
  static const int MEADOW_ELEVETION = 450 ;
  static const int LEAFY_ELEVETION = 1000 ;
  static const int THORNY_ELEVETION = 1500 ;
  static const int SCATTERED_ELEVETION = 2000 ;
  
  TracePoint _tracePoint ;
  
  TracePointRenderer(this._tracePoint);
  
  int get distanceInMeters => _tracePoint.distance.round();
  
  int get elevetionInMeters => _tracePoint.elevetion.round();
  
  int get meadowInMeters => elevetionInMeters > MEADOW_ELEVETION ? MEADOW_ELEVETION - 1 : elevetionInMeters  - 1   ;

  int get leafyInMeters => elevetionInMeters > LEAFY_ELEVETION ? LEAFY_ELEVETION - 1 : elevetionInMeters  - 1   ;

  int get thornyInMeters => elevetionInMeters > THORNY_ELEVETION ? THORNY_ELEVETION - 1 : elevetionInMeters  - 1   ;

  int get scatteredInMeters => elevetionInMeters > SCATTERED_ELEVETION ? SCATTERED_ELEVETION - 1 : elevetionInMeters  - 1   ;

  int getSnowInMeters(skyElevetionInMeters) => elevetionInMeters > skyElevetionInMeters ? skyElevetionInMeters - 1 : elevetionInMeters  - 1   ;
   
}