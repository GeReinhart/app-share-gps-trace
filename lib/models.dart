
import '../lib/trace.dart';

class Trace {
  
  String id;
  
  String creator;
  
  String title ;

  String description ;
  
  String gpxUrl ;
  
  double startPointLatitude;
  double startPointLongitude;
  double startPointElevetion;
  num    length;
  num    up ;
  num    inclinationUp;
  double    upperPointElevetion;
  int    difficulty;
  String _traceDataId ;
  
  TraceData _traceData ;
  TraceAnalysis _traceAnalysis ;
  
  Trace.fromTraceAnalysis(String creator, TraceAnalysis traceAnalysis){
    this.creator = creator;
    this.traceData = new TraceData.fromTraceAnalysis(traceAnalysis);
  }
  
  Trace.fromJson(Map map) {
    id = map['_id'];
    creator = map['creator'];
    title = map['title'];
    description = map['description'];
    gpxUrl = map['gpxUrl'];
    
    _traceDataId = map['traceDataId'];
    startPointLatitude = map['startPointLatitude'];
    startPointLongitude = map['startPointLongitude'];
    startPointElevetion = map['startPointElevetion'];
    length = map['length'];
    up = map['up'];
    inclinationUp = map['inclinationUp'];
    upperPointElevetion= map['upperPointElevetion'];
    difficulty= map['difficulty'];
  }
  

  
  Map toJson() {
    return {'_id': id,'creator': creator, 'title': title, 'description': description, 
      'traceDataId': _traceDataId,
      'gpxUrl' : gpxUrl,
      'startPointLatitude': startPointLatitude,
      'startPointLongitude': startPointLongitude,
      'startPointElevetion': startPointElevetion,
      'length': length,
      'up': up,
      'inclinationUp': inclinationUp,
      'upperPointElevetion': upperPointElevetion,
      'difficulty': difficulty
      };
  }
  
  TraceAnalysis get traceAnalysis{
    if(_traceAnalysis == null){
      _traceAnalysis = _traceData.toTraceAnalysis()  ;
    }
    return _traceAnalysis;
  }
  TraceData     get traceData => _traceData;  
  set traceData(value) {
    _traceData = value;
    _traceAnalysis = _traceData.toTraceAnalysis()  ;
    _traceData.id = value.id;
    _setTraceAnalysisData(_traceAnalysis);
  } 
  
  void _setTraceAnalysisData(TraceAnalysis traceAnalysis){
    _traceAnalysis = traceAnalysis;
    startPointLatitude = traceAnalysis.startPoint.latitude;
    startPointLongitude = traceAnalysis.startPoint.longitude;
    startPointElevetion = traceAnalysis.startPoint.elevetion;
    length = traceAnalysis.length;
    up = traceAnalysis.up;
    inclinationUp = traceAnalysis.inclinationUp;
    upperPointElevetion= traceAnalysis.upperPoint.elevetion;
    difficulty= traceAnalysis.difficulty;
  }
  
  String        get traceDataId => _traceDataId;
  
  set traceDataId(value) {
    _traceDataId = value;
    if(_traceData!= null){
      _traceData.id = value;
    }
  } 
  
}


class TraceData{
  
  String id;
  String latArray = "" ;
  String longArray = "" ;
  String eleArray = "" ;  

  TraceData.fromTraceAnalysis(TraceAnalysis traceAnalysis){
    for (var iter = traceAnalysis.points.iterator; iter.moveNext();) {
      TracePoint point = iter.current;
      latArray += point.latitude.toString() + "#" ;
      longArray += point.longitude.toString() + "#" ;
      eleArray += point.elevetion.toString() + "#" ;
    }
  }
  
  TraceData.fromJson(Map map) {
    id = map['_id'];
    latArray = map['latArray'];
    longArray = map['longArray'];
    eleArray = map['eleArray'];
  }
  
  Map toJson() {
    return {'_id': id,'latArray': latArray, 'longArray': longArray, 'eleArray': eleArray};
  }
  
  TraceAnalysis toTraceAnalysis(){
    TraceAnalysis traceAnalysis = new TraceAnalysis();
    List<String> latStringList = latArray.split("#") ;
    List<String> longStringList = longArray.split("#") ;
    List<String> eleStringList = eleArray.split("#") ;

    List<TracePoint> points = new List<TracePoint>();
    
    var latIter = latStringList.iterator;
    var longIter = longStringList.iterator ;    
    for (var eleIter = eleStringList.iterator; eleIter.moveNext();) {
      latIter.moveNext();
      longIter.moveNext();
      String latString = latIter.current;
      String longString = longIter.current;
      String eleString = eleIter.current;
      if (!latString.isEmpty){ 
        TracePoint currentPoint = new TracePoint();
        currentPoint.latitude = double.parse(latString);
        currentPoint.longitude = double.parse(longString);
        currentPoint.elevetion = double.parse(eleString);
        points.add(currentPoint);
      }
    }
    return new TraceAnalysis.fromPoints(points);
  }
  
  
}

class User {
  
  String id;

  String login;

  String encryptedPassword;
  
  String firstName;
  
  String lastName ;
  
  User(this.login, this.encryptedPassword, this.firstName, this.lastName);

  User.withLogin(this.login, this.encryptedPassword);
  
  User.withId(this.id,this.login, this.encryptedPassword, this.firstName, this.lastName);
  
  User.fromJson(Map map) {
    id = map['_id'];
    login = map['login'];
    encryptedPassword = map['encryptedPassword'];
    firstName = map['firstName'];
    lastName = map['lastName'];
  }
  
  Map toJson() {
    return {'_id': id,'login': login, 'encryptedPassword': encryptedPassword, 
      'firstName': firstName, 'lastName': lastName};
  }
  
  
}
