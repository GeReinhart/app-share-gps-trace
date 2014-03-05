
import 'package:intl/intl.dart';
import "package:gps_trace/gps_trace.dart";
import "../../lib/models.dart" ;
import "../../lib/i18n.dart" ;
import  "../shared/forms.dart";

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

class LigthTraceRenderers {
  
  List<LigthTraceRenderer> traces ;
  
  TracePoint  get baryCenter{
    if (traces!= null && traces.isNotEmpty){
      return new TracePoint.basic( 45.299041 , 5.94017 ) ;
    }else{
      double lat =0.0;
      double long = 0.0;
      traces.forEach(  (traceRenderer){
         lat+= traceRenderer.trace.startPointLatitude ;
         long += traceRenderer.trace.startPointLongitude;
      });
      return new TracePoint.basic( lat / traces.length , long / traces.length ) ;
    }
  }
  
  
}

class LigthTraceRenderer{
  
  Trace trace;
  
  LigthTraceRenderer(this.trace);
 
  String get key => (trace.key);
  String get keyJsSafe => (trace.key.replaceAll("/", "_").replaceAll("'", "-"));
  String get creator => (trace.creator);
  String get title => (trace.title);
  String get titleJsSafe => (trace.title.replaceAll("'", ""));
  String get titleWithUrl => ('<a href="/#trace_details/${key}">${title}</a>' ) ;
  String get length => ("${(trace.length/1000).truncate()} km") ;
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
  
  TraceAnalyser _traceAnalyser = new TraceAnalyser();
  TraceAnalysisRenderer traceAnalysisRenderer ;
  String gpxUrl ;
  String permanentTraceUrl ;
  TraceRawData profileData ;
  
  TraceRenderer(Trace trace,String permanentTraceUrl,String gpxUrl): super(trace){
    this.permanentTraceUrl=permanentTraceUrl;
    this.gpxUrl = gpxUrl;
    this.profileData = _traceAnalyser.buildProfile(trace.rawData, maxProfilePointsNumber:200);
    this.traceAnalysisRenderer = new TraceAnalysisRenderer(trace.traceAnalysis,profileData,gpxUrl);
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

  String get lastUpdateDate{
    if(trace.lastUpdateDate != null){
      var formatter = new DateFormat('dd/MM/yyyy');
      return formatter.format(trace.lastUpdateDate);
    }
  }
  
  TraceDetails  get traceDetails{
    TraceDetails traceDetails = new TraceDetails();
    traceDetails.key = this.trace.key ;
    traceDetails.creator = this.trace.creator ;
    traceDetails.title = this.trace.title ;
    traceDetails.description = this.trace.description ;
    traceDetails.activities = this.activities; 
    traceDetails.lastupdate = this.lastUpdateDate;
    traceDetails.length = this.trace.length ;
    traceDetails.up = this.traceAnalysisRenderer.up ;
    traceDetails.inclinationUp = this.traceAnalysisRenderer.inclinationUp;
    traceDetails.upperPointElevetion = this.traceAnalysisRenderer.upperPointElevetion;
    traceDetails.difficulty = this.traceAnalysisRenderer.difficulty ;
    traceDetails.startPointLatitude = this.traceAnalysisRenderer.startPoint.latitude ;
    traceDetails.startPointLongitude = this.traceAnalysisRenderer.startPoint.longitude ;
    traceDetails.gpxUrl = this.gpxUrl ;
    traceDetails.profilePoints = new List<ProfilePoint>();
    traceDetails.traceHeightWidthRatio = this.traceAnalysisRenderer.traceHeightWidthRatio ;
    this.traceAnalysisRenderer.profilePoints.forEach((p){
      ProfilePoint pp= new ProfilePoint();
      pp.index = p.tracePoint.index;
      pp.latitude = p.tracePoint.latitude;
      pp.longitude = p.tracePoint.longitude;
      pp.distance = p.tracePoint.distance;
      pp.elevetion = p.tracePoint.elevetion;
      traceDetails.profilePoints.add(pp);
    });
        
        
        ;
    
    
    return traceDetails ;
  }
  
}

class TraceAnalysisRenderer {
  
  String gpxUrl;
  TraceAnalysis _traceAnalysis ;
  TraceRawData profileData;
  
  TraceAnalysisRenderer(this._traceAnalysis, this.profileData, this.gpxUrl);
  
  List<TracePointRenderer> get points {
    List<TracePointRenderer> tracePointRenderers = new List<TracePointRenderer>();
    for(TracePoint tracePoint in   _traceAnalysis.points ){
      tracePointRenderers.add(   new TracePointRenderer(tracePoint)) ;
    }
    return tracePointRenderers ;
  }

  List<TracePointRenderer> get profilePoints {
    List<TracePointRenderer> tracePointRenderers = new List<TracePointRenderer>();
    for(TracePoint tracePoint in   profileData.points ){
      tracePointRenderers.add(   new TracePointRenderer(tracePoint)) ;
    }
    return tracePointRenderers ;
  }  
  
  TracePoint get startPoint => _traceAnalysis.startPoint ;
  
  int get lengthKmPart => (_traceAnalysis.length/1000).truncate() ;

  int get lengthMetersPart => ( _traceAnalysis.length- (_traceAnalysis.length/1000).truncate()*1000)  ; 
  
  num get up => _traceAnalysis.up ;
  
  num get inclinationUp => _traceAnalysis.inclinationUp ;
  
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
  
  TracePoint get tracePoint => _tracePoint;
  
  int get distanceInMeters => _tracePoint.distance.round();
  
  int get elevetionInMeters => _tracePoint.elevetion.round();
  
  int get meadowInMeters => elevetionInMeters > MEADOW_ELEVETION ? MEADOW_ELEVETION - 1 : elevetionInMeters  - 1   ;

  int get leafyInMeters => elevetionInMeters > LEAFY_ELEVETION ? LEAFY_ELEVETION - 1 : elevetionInMeters  - 1   ;

  int get thornyInMeters => elevetionInMeters > THORNY_ELEVETION ? THORNY_ELEVETION - 1 : elevetionInMeters  - 1   ;

  int get scatteredInMeters => elevetionInMeters > SCATTERED_ELEVETION ? SCATTERED_ELEVETION - 1 : elevetionInMeters  - 1   ;

  int getSnowInMeters(skyElevetionInMeters) => elevetionInMeters > skyElevetionInMeters ? skyElevetionInMeters - 1 : elevetionInMeters  - 1   ;
   
}