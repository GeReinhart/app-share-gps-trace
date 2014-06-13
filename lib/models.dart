
import "package:gps_trace/gps_trace.dart";

class Trace {
  
  String id;

  String key;
  
  String creator;
  
  String title ;

  String description ;
  
  String gpxUrl ;
  
  String smoothing;
  
  List<String> activities = [];
  
  int _creationDateInMilliseconds ;
  int _lastUpdateDateInMilliseconds ;
  
  num startPointLatitude;
  num startPointLongitude;
  num startPointElevetion;
  num    length;
  num    up ;
  num    inclinationUp;
  num    upperPointElevetion;
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
    smoothing = map['smoothing'];
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
      'smoothing' : smoothing,
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
      _traceAnalysis = _traceData.toTraceAnalysis(smoothingParameters:smoothingParameters)  ;
      if (this.up!= null){
        _traceAnalysis.up = this.up;
      }
      if (this.length!= null){
        _traceAnalysis.length = this.length;
      }
    }
    return _traceAnalysis;
  }
  
  TraceData     get traceData => _traceData;  
  set traceData(value) {
    _traceData = value;
    _traceAnalysis = traceAnalysis  ;
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
  
  SmoothingParameters get smoothingParameters => SmoothingParameters.get(SmoothingLevel.fromString(smoothing)) ;
  
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
  TraceRawData get rawData{
    return new TraceRawData.fromPoints(points);
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

    return   _removeAccentAndSpecialCharacters(creator) + "/" +
              _removeAccentAndSpecialCharacters(title) ;
  }
  
  String _removeAccentAndSpecialCharacters(String s){
    String clean = s.toLowerCase().replaceAll('é', 'e').replaceAll('è', 'e')
        .replaceAll('ê', 'e').replaceAll('ë', 'e')
          .replaceAll('à', 'a').replaceAll('á', 'a')
            .replaceAll('â', 'a').replaceAll('ä', 'a')
              .replaceAll('ã', 'a').replaceAll('ì', 'i')
                .replaceAll('í', 'i').replaceAll('î', 'i')
                  .replaceAll('ï', 'i').replaceAll('ò', 'o')
                    .replaceAll('ó', 'o').replaceAll('ô', 'o')                                           
                      .replaceAll('õ', 'o').replaceAll('ö', 'o')                                           
                        .replaceAll('ù', 'u').replaceAll('ú', 'u')                                           
                          .replaceAll('û', 'u').replaceAll('ü', 'u')                                           
                            .replaceAll('ý', 'y').replaceAll('ÿ', 'y')                                           
                              .replaceAll('ñ', 'n');                                           
    
    Pattern pattern = new RegExp('[^\-a-zA-Z0-9]');
    return clean.replaceAll(pattern, "_");
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
  
  TraceAnalysis toTraceAnalysis({bool applyPurge: false,
                                    int idealMaxPointNumber:3500, 
                                      SmoothingParameters smoothingParameters:null}){
   
    TraceRawData data = new TraceRawData.fromPoints(points);
    return new TraceAnalysis.fromRawData(data) ;
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

class WatchPoint {
  
  String id;

  String creator ;
  
  String traceKey;
  
  String name;

  String description;
  
  String type;
  
  num latitude;
  num longitude;
  List<num> distance = new List<num>();
  
  WatchPoint( this.creator, this.name, this.description, this.type, this.latitude, this.longitude);

  WatchPoint.fromJson(Map map) {
    id = map['_id'];
    creator = map['creator'];
    traceKey = map['traceKey'];
    name = map['name'];
    description = map['description'];
    type = map['type'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    distance = map['distance'];
    if (distance == null){
      distance = new List<num>();
    }
  }
  
  Map toJson() {
    return {'_id': id,'traceKey': traceKey,'creator': creator,'name': name, 'description': description, 
      'type': type, 'latitude': latitude, 'longitude': longitude, 'distance': distance};
  }
  
  
}


class CommentTargetType{
  static final  String TRACE = "trace" ;
}

class Comment {
  
  String id;

  String creator ;
  
  String targetKey;
  
  String targetType;

  String content;
  
  int _creationDateInMilliseconds ;
  int _lastUpdateDateInMilliseconds ;
  
  Comment( this.creator, this.targetKey, this.targetType, this.content);

  Comment.fromJson(Map map) {
    id = map['_id'];
    creator = map['creator'];
    targetKey = map['targetKey'];
    targetType = map['targetType'];
    content = map['content'];
    _creationDateInMilliseconds = map['creationDate'];
    _lastUpdateDateInMilliseconds = map['lastUpdateDate'];    
  }
  
  Map toJson() {
    return {'_id': id,'creator': creator,'targetKey': targetKey,'targetType': targetType, 'content': content, 
      'creationDate': _creationDateInMilliseconds, 'lastUpdateDate': _lastUpdateDateInMilliseconds};
  }
  
  void creation(){
    this._creationDateInMilliseconds = new DateTime.now().millisecondsSinceEpoch;
    this._lastUpdateDateInMilliseconds = this._creationDateInMilliseconds;
  }
  
  void update(){
    this._lastUpdateDateInMilliseconds = new DateTime.now().millisecondsSinceEpoch;
  }
  
  int get creationDateInMilliseconds => _creationDateInMilliseconds;
  int get lastUpdateDateInMilliseconds => _lastUpdateDateInMilliseconds; 
}



class User {
  
  String id;

  String login;

  String encryptedPassword;
  
  String firstName;
  
  String lastName ;
  
  bool admin;
  
  User(this.login, this.encryptedPassword, this.firstName, this.lastName);

  User.withFields({String login:null, bool admin:false  }){
    this.login = login ;
    this.admin = admin ;
  }
  
  User.withLogin(this.login, this.encryptedPassword);
  
  User.withId(this.id,this.login, this.encryptedPassword, this.firstName, this.lastName);
  
  User.fromJson(Map map) {
    id = map['_id'];
    login = map['login'];
    admin = map['admin'] == null ? false : map['admin'];
    encryptedPassword = map['encryptedPassword'];
    firstName = map['firstName'];
    lastName = map['lastName'];
  }
  
  Map toJson() {
    return {'_id': id,'login': login,'admin': admin, 'encryptedPassword': encryptedPassword, 
      'firstName': firstName, 'lastName': lastName};
  }
  
  
}
