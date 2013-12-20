
import '../lib/trace.dart';

class Trace {
  
  String id;

  String key;
  
  String creator;
  
  String title ;

  String description ;
  
  String gpxUrl ;
  
  List<String> activities = [];
  
  int _creationDateInMilliseconds ;
  int _lastUpdateDateInMilliseconds ;
  
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
  List<TracePoint> _points ;
  
  Trace.fromTraceAnalysis(String creator, TraceAnalysis traceAnalysis){
    this.creator = creator;
    this.traceData = new TraceData.fromTraceAnalysis(traceAnalysis);
  }
  
  Trace.fromJson(Map map) {
    id = map['_id'];
    key = map['key'];
    creator = map['creator'];
    title = map['title'];
    description = map['description'];
    activities = map['activities'];
    gpxUrl = map['gpxUrl'];
    _creationDateInMilliseconds = map['creationDate'];
    _lastUpdateDateInMilliseconds = map['lastUpdateDate'];
    
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
    return {'_id': id,'key': key,'creator': creator, 
      'title': title, 'description': description, 
      'creationDate': _creationDateInMilliseconds, 'lastUpdateDate': _lastUpdateDateInMilliseconds,
      'activities' : activities,
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
    _points = traceAnalysis.points;
  }
  
  String        get traceDataId => _traceDataId;
  
  set traceDataId(value) {
    _traceDataId = value;
    if(_traceData!= null){
      _traceData.id = value;
    }
  } 
  
  List<TracePoint> get points{
    if(_points == null){
      _points = _traceData.points  ;
    }
    return _points;
  }
  
  String  get cleanId {
    return id.substring("ObjectId(\"".length , id.length -2 ) ;
  }
  
  DateTime get creationDate => (_buildDate(this._creationDateInMilliseconds));
  
  DateTime get lastUpdateDate  => (_buildDate(this._lastUpdateDateInMilliseconds));
  
  DateTime _buildDate(int millisecondsSinceEpoch){
    if (millisecondsSinceEpoch== null){
      return new DateTime.now();
    }else{
      return new DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    }
  }
  
  void creation(){
    this._creationDateInMilliseconds = new DateTime.now().millisecondsSinceEpoch;
    this._lastUpdateDateInMilliseconds = this._creationDateInMilliseconds;
  }
  
  void update(){
    this._lastUpdateDateInMilliseconds = new DateTime.now().millisecondsSinceEpoch;
  }
  
  
  String  buildKey() {
    Pattern pattern = new RegExp(' ');
    String titleAsKey = title.toLowerCase() ;
    titleAsKey = titleAsKey.replaceAll(pattern, "_");
    return  Uri.encodeComponent(creator) + "/" + Uri.encodeComponent(titleAsKey) ;
  }
}

class TraceDomains{
  
  static List<String> getActivitiesKeys() => ["activity-trek", "activity-running", "activity-bike", "activity-mountainbike", "activity-skitouring", "activity-snowshoe"];
  
}

class TraceData{
  
  String id;
  String latArray = "" ;
  String longArray = "" ;
  String eleArray = "" ;  
  List<TracePoint> _points ;
  
  
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
    return new TraceAnalysis.fromPoints(points);
  }
  
  List<TracePoint> get points{
    if(_points == null){
      _setPoints()  ;
    }
    return _points;
  }
  
  void _setPoints(){
    List<String> latStringList = latArray.split("#") ;
    List<String> longStringList = longArray.split("#") ;
    List<String> eleStringList = eleArray.split("#") ;
    
    _points = new List<TracePoint>();
    
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
        if ( !eleString.isEmpty  ){
          currentPoint.elevetion = double.parse(eleString);
          _points.add(currentPoint);
        }
      }
    }
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
