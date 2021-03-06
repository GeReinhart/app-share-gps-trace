
import 'dart:convert';
import 'package:intl/intl.dart';

abstract class ToJson{
  Map toJson() ;
}

class LoginForm implements ToJson{
  String login;
  String _admin = "false";
  String password;
  String encryptedPassword;
  String error = null;

  LoginForm(this.login,this.password);

  LoginForm.withEncryptedPassword(this.login,this.password,this.encryptedPassword);
  
  LoginForm.forLogout();
  
  LoginForm.fromJson(Map map) {
    _fromJson(map);
  }
  
  void _fromJson(Map map) {
    login = map['login'];
    _admin = map['admin'];
    password = map['password'];
    encryptedPassword = map['encryptedPassword'];
    error = map['error'];
  }
  
  Map toJson() {
    return {'login': login,'admin': _admin,'password': password
             ,'encryptedPassword': encryptedPassword ,'error':error};
  }

  LoginForm resetPassword(){
    password = null ;
    return this;
  }
  
  void set admin(bool admin) { _admin = admin.toString() ;}
   
  bool get isSuccess => error==null;
  bool get isAdmin => "true" == _admin;
}


const int REGISTER_PASSWORD_MIN_LENGTH = 5 ;
const int REGISTER_LOGIN_MIN_LENGTH = 3 ;

const String REGISTER_ERROR_LOGIN_EXISTS = "register.error.loginExists" ;
const String REGISTER_ERROR_PASSWORD_MIN_LENGTH = "register.error.passwordMinLength" ;
const String REGISTER_ERROR_PASSWORD_CONFIRM = "register.error.passwordConfirm" ;
const String REGISTER_ERROR_LOGIN_MIN_LENGTH = "register.error.loginMinLength" ;

const String REGISTER_FIELD_LOGIN = "login" ;
const String REGISTER_FIELD_PASSWORD = "password" ;
const String REGISTER_FIELD_PASSWORD_CONFIRM = "passwordConfirm" ;


class RegisterForm implements ToJson{
  
  String login;
  String password;
  String encryptedPassword;
  String passwordConfirm;
  String _admin = "false" ;
  String _success = "true" ;
  String error = null;
  String errorField = null;
  
  RegisterForm( this.login, this.password, this.passwordConfirm );
  
  RegisterForm.fromMap(Map params){
    _fromMap(params);
  }
  
  void _fromMap(Map params){
    login = params["login"] ;
    password = params["password"] ;
    encryptedPassword= params["encryptedPassword"];
    _admin = params["admin"] ;
    passwordConfirm = params["passwordConfirm"] ;
    _success = params["_success"] ;
    error = params["error"] ;
    errorField = params["errorField"] ;
  }
  
  Map toJson() {
    return {'login': login,
             'password': password,
             'encryptedPassword': encryptedPassword,
             'admin': _admin,
             'passwordConfirm':passwordConfirm,
             '_success':_success,
             'error':error,
             'errorField':errorField};
  }
  
  void setError( String error, String errorField  ){
    _success = "false";
    this.error = error;
    this.errorField = errorField;
  }
  
  void setErrorLoginExists(){
    setError(REGISTER_ERROR_LOGIN_EXISTS,REGISTER_FIELD_LOGIN);
  }
  
  RegisterForm resetPassword(){
    password = null ;
    passwordConfirm = null ;
    return this;
  }
  
  bool validate(){
    
    if (password == null ||  password != null && password.length < REGISTER_PASSWORD_MIN_LENGTH ){
      setError( REGISTER_ERROR_PASSWORD_MIN_LENGTH, REGISTER_FIELD_PASSWORD) ;
    }
    if(  password != passwordConfirm ){
      setError( REGISTER_ERROR_PASSWORD_CONFIRM, REGISTER_FIELD_PASSWORD_CONFIRM) ;
    }
    if(  login == null ||  login != null && login.length < REGISTER_LOGIN_MIN_LENGTH ){
      setError( REGISTER_ERROR_LOGIN_MIN_LENGTH, REGISTER_FIELD_LOGIN) ;
    }
    
    return isSuccess ;
  }
  
  
  
  void set admin(bool admin) { _admin = admin.toString() ;}
  
  bool get isSuccess => _success == "true" ;
  bool get isAdmin => _admin == "true" ;
}

class DeleteTraceForm implements ToJson{
  String key;
  String _success = "true" ;

  DeleteTraceForm(this.key);

  DeleteTraceForm.fromJson(Map map) {
    _fromJson(map);
  }
  
  void _fromJson(Map map) {
    key = map['key'];
    _success = map['_success'];
  }
  
  Map toJson() {
    return {'key': key, '_success':_success};
  }
  
  bool get success => _success == "true" ;
}

class SearchForm  implements ToJson{

  String search;
  String creator;
  String _activities;
  
  String lengthGt;
  String upGt ;
  String startPointElevetionGt;
  String upperPointElevetionGt;
  String lengthLt;
  String upLt ;
  String startPointElevetionLt;
  String upperPointElevetionLt;
  
  double mapBoundNELat ;
  double mapBoundNELong ;
  double mapBoundSWLat ;
  double mapBoundSWLong ;
  
  List<LightTrace> results;
  
  SearchForm();
  
  SearchForm.fromMap(Map jsonMap){
    _fromMap(jsonMap);
  }

  SearchForm.fromUrlQuery(String query){
    _fromUrlQuery(query);
  }
  
  bool equals( SearchForm other){
    if ( ! _stringEquals(search, other.search) ) return false ;
    if ( ! _stringEquals(creator, other.creator) ) return false ;
    if ( ! _stringEquals(_activities, other._activities) ) return false ;
    if ( ! _stringEquals(lengthGt, other.lengthGt) ) return false ;
    if ( ! _stringEquals(startPointElevetionGt, other.startPointElevetionGt) ) return false ;
    if ( ! _stringEquals(upperPointElevetionGt, other.upperPointElevetionGt) ) return false ;

    if ( ! _stringEquals(lengthLt, other.lengthLt) ) return false ;
    if ( ! _stringEquals(upLt, other.upLt) ) return false ;
    if ( ! _stringEquals(startPointElevetionLt, other.startPointElevetionLt) ) return false ;
    if ( ! _stringEquals(upperPointElevetionLt, other.upperPointElevetionLt) ) return false ;

    if ( ! _doubleEquals(mapBoundNELat, other.mapBoundNELat) ) return false ;
    if ( ! _doubleEquals(mapBoundNELong, other.mapBoundNELong) ) return false ;
    if ( ! _doubleEquals(mapBoundSWLat, other.mapBoundSWLat) ) return false ;
    if ( ! _doubleEquals(mapBoundSWLong, other.mapBoundSWLong) ) return false ;
    
    return true;
    
  }
  
  bool _stringEquals(String s1, String s2){
    if ( s1 == null && s2 == null  ){
      return true;
    }
    if ( s1 != null && s1.isEmpty && s2 == null  ){
      return true;
    }
    if ( s2 != null && s2.isEmpty && s1 == null  ){
      return true;
    }
    if ( s2 != null && s2.isEmpty && s1 != null && s1.isEmpty  ){
      return true;
    }    
    return s1 == s2 ;
  }

  bool _doubleEquals(double s1, double s2){
    if ( s1 == null && s2 == null  ){
      return true;
    }
    if ( s1 != null  && s2 == null  ){
      return false;
    }
    if ( s2 != null  && s1 == null  ){
      return false;
    }
    return s1 == s2 ;
  }

  
  void _fromMap(Map jsonMap){
    search = jsonMap["search"] ;
    creator = jsonMap["creator"] ;
    _activities = jsonMap["activities"] ;

    lengthGt = jsonMap["lengthGt"] ;
    upGt = jsonMap["upGt"] ;
    startPointElevetionGt = jsonMap["startPointElevetionGt"] ;
    upperPointElevetionGt = jsonMap["upperPointElevetionGt"] ;
    lengthLt = jsonMap["lengthLt"] ;
    upLt = jsonMap["upLt"] ;
    startPointElevetionLt = jsonMap["startPointElevetionLt"] ;
    upperPointElevetionLt = jsonMap["upperPointElevetionLt"] ;
        
    mapBoundNELat = jsonMap["mapBoundNELat"] ;
    mapBoundNELong = jsonMap["mapBoundNELong"] ;
    mapBoundSWLat = jsonMap["mapBoundSWLat"] ;
    mapBoundSWLong = jsonMap["mapBoundSWLong"] ;    
    
    results = new List<LightTrace>();
    List<Map> resultsAsJson = jsonMap["results"] ;
    if (resultsAsJson!= null && resultsAsJson.isNotEmpty  ){
      resultsAsJson.forEach((traceAsJson){
        results.add(new LightTrace.fromMap(traceAsJson)) ;
      });
    }
  }
  
  Map toJson() {
    return {'search': search,
             'creator': creator,
             'activities': _activities,
             'lengthGt': lengthGt,             
             'upGt': upGt,             
             'startPointElevetionGt': startPointElevetionGt,             
             'upperPointElevetionGt': upperPointElevetionGt,             
             'lengthLt': lengthLt,             
             'upLt': upLt,             
             'startPointElevetionLt': startPointElevetionLt,             
             'upperPointElevetionLt': upperPointElevetionLt,             
             'mapBoundNELat': mapBoundNELat,               
             'mapBoundNELong': mapBoundNELong,               
             'mapBoundSWLat': mapBoundSWLat,               
             'mapBoundSWLong': mapBoundSWLong,               
             'results':results};
  }
  
  void _fromUrlQuery(String query){
    if (query == null || query.isEmpty){
      return;
    }
    query.split("&").forEach((p){
      List<String> values = p.split("=") ;
      if (values.length == 2){
        String v = values[1] ;
        switch (values[0]) {
          case 's'  : search                     = v;     break;
          case 'c'  : creator                    = v;     break;
          case 'a'  : _activities                = v;     break;           
          case 'lg' : lengthGt                   = v;     break;    
          case 'll' : lengthLt                   = v;     break;             
          case 'ug' : upGt                       = v;     break;             
          case 'ul' : upLt                       = v;     break;             
          case 'sg' : startPointElevetionGt      = v;     break;             
          case 'sl' : startPointElevetionLt      = v;     break;   
          case 'eg' : upperPointElevetionGt      = v;     break;             
          case 'el' : upperPointElevetionLt      = v;     break;   
          case 'nea': mapBoundNELat      = double.parse(v,null);     break; 
          case 'neo': mapBoundNELong     = double.parse(v,null);     break; 
          case 'swa': mapBoundSWLat      = double.parse(v,null);     break; 
          case 'swo': mapBoundSWLong      = double.parse(v,null);     break; 
        }
      }
    });
  }
  
  String toUrlQuery(){
    return "s=${_v(search)}&c=${_v(creator)}&a=${_v(_activities)}"
                + "&lg=${_v(lengthGt)}&ll=${_v(lengthLt)}"
                + "&ug=${_v(upGt)}&ul=${_v(upLt)}"
                + "&sg=${_v(startPointElevetionGt)}&sl=${_v(startPointElevetionLt)}"
                + "&eg=${_v(upperPointElevetionGt)}&el=${_v(upperPointElevetionLt)}"
                + "&nea=${_d(mapBoundNELat)}&neo=${_d(mapBoundNELong)}"
                + "&swa=${_d(mapBoundSWLat)}&swo=${_d(mapBoundSWLong)}"
                ;
  }
  
  String _v(String value)=> value == null ? "" : value ;
  String _d(num value)=> value == null ? "" : value.toString() ;
  
  void addActivity(String activity){
    if(_activities != null && _activities.isNotEmpty){
      _activities += ",${activity}";
    }else{
      _activities = activity;
    }
  }
  
  List<String> get activities{
    if(_activities != null && _activities.isNotEmpty){
      return _activities.split(",");
    }else{
      return new List<String>();
    }
  }
  
  bool get hasBounds =>     mapBoundNELat != null && mapBoundNELong != null && mapBoundSWLat != null && mapBoundSWLong != null ;
  
}

class LightTrace implements ToJson{
  String key;
  String creator ;
  String title ;
  List<String> activityKeys ;
  String activities ;
  String length;
  String up;
  String upperPointElevetion;
  String inclinationUp;
  String difficulty;
  num startPointLatitude;
  num startPointLongitude;
  
  LightTrace(this.key, this.creator, this.title, this.activityKeys, this.activities, this.length,
             this.up, this.upperPointElevetion, this.inclinationUp, this.difficulty,
             this.startPointLatitude , this.startPointLongitude  );
  
  LightTrace.fromMap(Map jsonMap){
    _fromMap(jsonMap);
  }
  
  void _fromMap(Map jsonMap){
    key = jsonMap['key'] ;
    creator = jsonMap['creator'] ;
    title = jsonMap['title'] ;
    activityKeys = jsonMap['activityKeys'] ;
    activities = jsonMap['activities'] ;
    length = jsonMap['length'] ;
    up = jsonMap['up'] ;
    upperPointElevetion = jsonMap['upperPointElevetion'] ;    
    inclinationUp = jsonMap['inclinationUp'] ;    
    difficulty = jsonMap['difficulty'] ;  
    startPointLatitude = jsonMap['startPointLatitude'] ;  
    startPointLongitude = jsonMap['startPointLongitude'] ;  
  }
  
  Map toJson() {
    return {'key': key,
             'creator': creator,
             'title': title,
             'activityKeys': activityKeys,
             'activities': activities,
             'length':length,
             'up':up,
             'upperPointElevetion':upperPointElevetion,
             'inclinationUp':inclinationUp,
             'difficulty':difficulty,
             'startPointLatitude':startPointLatitude,
             'startPointLongitude':startPointLongitude
            };
  }
  
  String get keyJsSafe => (this.key.replaceAll("/", "_").replaceAll("'", "-"));
  String get titleJsSafe => (this.title.replaceAll("'", ""));  

  String get mainActivity {
      if( activityKeys == null || activityKeys != null && activityKeys.isEmpty ){
         return null;
       }
       return activityKeys[0] ;
  }
  
}

class TraceDetails implements ToJson{
  
  String key;
  String creator ;
  String title ;
  String description ;
  String lastupdate ;
  String mainIconUrl ;
  List<String> activityKeys ;
  String activities ;
  num length;
  num up;
  num upperPointElevetion;
  num inclinationUp;
  num difficulty;
  num startPointLatitude;
  num startPointLongitude;
  String gpxUrl;
  List<WatchPointData> watchPoints ;
  List<ProfilePoint> profilePoints ;
  num traceHeightWidthRatio ;
  
  TraceDetails( );
  
  TraceDetails.fromMap(Map jsonMap){
    _fromMap(jsonMap);
  }
  
  void _fromMap(Map jsonMap){
    key = jsonMap['key'] ;
    creator = jsonMap['creator'] ;
    title = jsonMap['title'] ;
    description = jsonMap['description'] ;
    lastupdate = jsonMap['lastupdate'] ;
    activityKeys = jsonMap['activityKeys'] ;
    activities = jsonMap['activities'] ;
    length = jsonMap['length'] ;
    up = jsonMap['up'] ;
    upperPointElevetion = jsonMap['upperPointElevetion'] ;    
    inclinationUp = jsonMap['inclinationUp'] ;    
    difficulty = jsonMap['difficulty'] ;  
    startPointLatitude = jsonMap['startPointLatitude'] ;  
    startPointLongitude = jsonMap['startPointLongitude'] ;  
    gpxUrl = jsonMap['gpxUrl'] ;  
    List<Map> profilePointsAsMap = JSON.decode( jsonMap['profilePoints'] ) ;  
    profilePoints = new List<ProfilePoint>();
    if(profilePointsAsMap != null){
      profilePointsAsMap.forEach((p){
        profilePoints.add( new ProfilePoint.fromMap(p) ) ;
      });
    }
    List<Map> watchPointsAsMap = JSON.decode( jsonMap['watchPoints'] ) ;  
    watchPoints = new List<WatchPointData>();
    if(watchPointsAsMap != null){
      watchPointsAsMap.forEach((p){
        watchPoints.add( new WatchPointData.fromMap(p) ) ;
      });
    }    
    traceHeightWidthRatio = jsonMap['traceHeightWidthRatio'] ; 
  }
  
  Map toJson() {
    
    return {'key': key,
             'creator': creator,
             'title': title,
             'description': description,
             'lastupdate': lastupdate,
             'activityKeys': activityKeys,
             'activities': activities,
             'length':length,
             'up':up,
             'upperPointElevetion':upperPointElevetion,
             'inclinationUp':inclinationUp,
             'difficulty':difficulty,
             'startPointLatitude':startPointLatitude,
             'startPointLongitude':startPointLongitude,
             'gpxUrl':gpxUrl,
             'profilePoints': JSON.encode( profilePoints ),
             'watchPoints': JSON.encode( watchPoints ),
             'traceHeightWidthRatio' : traceHeightWidthRatio
            };
  }
  
  String get keyJsSafe => (this.key.replaceAll("/", "_").replaceAll("'", "-"));
  String get titleJsSafe => (this.title.replaceAll("'", ""));  

  String get mainActivity {
    if( activityKeys == null || activityKeys != null && activityKeys.isEmpty ){
         return null;
       }
       return activityKeys[0] ;
  }
  
  String get descriptionToRender {
    
    if( this.description== null || this.description.isEmpty){
      return "";
    }
    String description = "";
    List<String> parts =  this.description.split("\r\n");
    for(var iter = parts.iterator ;  iter.moveNext() ;){
      description += "<p>${iter.current}</p>" ; 
    }
    return description;
  }
  
  int get lengthKmPart => (this.length/1000).truncate() ;

  int get lengthMetersPart => ( this.length- (this.length/1000).truncate()*1000)  ; 

  num get endPointLatitude => profilePoints.last.latitude ;
  num get endPointLongitude => profilePoints.last.longitude ;
}

class WatchPointData implements ToJson{
  
  String name;

  String description;
  
  String type;
  
  num latitude;
  num longitude;
  List<num> distance = new List<num>();
  
  WatchPointData(  this.name, this.description, this.type, this.latitude, this.longitude);

  WatchPointData.fromMap(Map map) {
    name = map['name'];
    description = map['description'];
    type = map['type'];
    latitude = map['latitude'];
    longitude = map['longitude'];
    distance =  map['distance'] ;
    if (distance == null){
      distance = new List<num>();
    }
  }
  
  Map toJson() {
    return {'name': name, 'description': description, 
      'type': type, 'latitude': latitude, 'longitude': longitude, 'distance': distance
      };
  }
  
}

class ProfilePoint implements ToJson {

  static const int MEADOW_ELEVETION = 450 ;
  static const int LEAFY_ELEVETION = 1000 ;
  static const int THORNY_ELEVETION = 1500 ;
  static const int SCATTERED_ELEVETION = 2000 ;
  
  int    index = 0;
  double latitude = 0.0;
  double longitude= 0.0;
  double elevetion= 0.0; // in meters
  double distance = 0.0; // in meters
  
  ProfilePoint();
  
  ProfilePoint.basic(this.latitude,this.longitude);
  
  ProfilePoint.fromMap(Map jsonMap){
    _fromMap(jsonMap);
  }
  
  void _fromMap(Map jsonMap){
    index = jsonMap['index'] ;
    latitude = jsonMap['latitude'] ;
    longitude = jsonMap['longitude'] ;
    elevetion = jsonMap['elevetion'] ;
    distance = jsonMap['distance'] ;
  }
  
  Map toJson() {
    return {'index': index,
             'latitude': latitude,
             'longitude': longitude,
             'elevetion': elevetion,
             'distance': distance
            };
  }
  
  int get distanceInMeters => this.distance.round();
  
  int get elevetionInMeters => this.elevetion.round();
  
  int get meadowInMeters => elevetionInMeters > MEADOW_ELEVETION ? MEADOW_ELEVETION - 1 : elevetionInMeters  - 1   ;

  int get leafyInMeters => elevetionInMeters > LEAFY_ELEVETION ? LEAFY_ELEVETION - 1 : elevetionInMeters  - 1   ;

  int get thornyInMeters => elevetionInMeters > THORNY_ELEVETION ? THORNY_ELEVETION - 1 : elevetionInMeters  - 1   ;

  int get scatteredInMeters => elevetionInMeters > SCATTERED_ELEVETION ? SCATTERED_ELEVETION - 1 : elevetionInMeters  - 1   ;

  int getSnowInMeters(skyElevetionInMeters) => elevetionInMeters > skyElevetionInMeters ? skyElevetionInMeters - 1 : elevetionInMeters  - 1   ;

}


const int TRACE_TITLE_MIN_LENGTH = 5 ;

const String TRACE_ERROR_TITLE_MIN_LENGTH = "trace.error.titleMinLength" ;
const String TRACE_ERROR_ACTIVITY_MISSING = "trace.error.activityMissing" ;
const String TRACE_ERROR_GPS_FILE_MISSING = "trace.error.gpsFileMissing" ;
const String TRACE_ERROR_GPS_FILE_TOO_BIG = "trace.error.gpsFileTooBig" ;
const String TRACE_ERROR_GPS_FILE_ON_SCAN = "trace.error.gpsFileScanError" ;

class TraceForm implements ToJson{
  
  String _isUpdate ;
  String key ;
  String title ;
  String description ;
  List<String> activityKeys ;
  String activities ;
  String smoothing;
  String gpxUrl;
  String gpsFileName;
  int    gpsFileSizeInBytes;
  
  String _success = "true" ;
  String error = null;
  String errorField = null;
  
  TraceForm( );
  
  TraceForm.fromMap(Map jsonMap){
    _fromMap(jsonMap);
  }
  
  void _fromMap(Map jsonMap){
    _isUpdate = jsonMap['_isUpdate'] ;
    key = jsonMap['key'] ;
    title = jsonMap['title'] ;
    description = jsonMap['description'] ;
    activityKeys = jsonMap['activityKeys'] ;
    activities = jsonMap['activities'] ;
    smoothing = jsonMap['smoothing'];
    gpxUrl = jsonMap['gpxUrl'] ;  
    gpsFileName = jsonMap['gpsFileName'] ; 
    gpsFileSizeInBytes = jsonMap['gpsFileSizeInBytes'] ; 
    _success = jsonMap["_success"] ;
    error = jsonMap["error"] ;
    errorField = jsonMap["errorField"] ;
  }
  
  Map toJson() {
    
    return {
             '_isUpdate': _isUpdate,
             'key': key,
             'title': title,
             'description': description,
             'activityKeys': activityKeys,
             'activities': activities,
             'smoothing' : smoothing,
             'gpxUrl':gpxUrl, 
             'gpsFileName' :gpsFileName, 
             'gpsFileSizeInBytes':gpsFileSizeInBytes ,              
             '_success':_success,
             'error':error,
             'errorField':errorField
            };
  }
  
  void setError( String error, String errorField  ){
    _success = "false";
    this.error = error;
    this.errorField = errorField;
  }
  
  void append(String key , String value){
    
  }
  
  bool validate(){
    _success = "true" ;
    if (title == null ||  title != null && title.length < TRACE_TITLE_MIN_LENGTH ){
      setError( TRACE_ERROR_TITLE_MIN_LENGTH, "title") ;
    }
    if (activityKeys == null ||  activityKeys != null && activityKeys.isEmpty ){
      setError( TRACE_ERROR_ACTIVITY_MISSING, "activities") ;
    }
    if( isCreate ){
      if (gpsFileName == null ||  gpsFileName != null && gpsFileName.isEmpty ){
          setError( TRACE_ERROR_GPS_FILE_MISSING, "gpsFile") ;
      }
      if (  gpsFileSizeInBytes != null && gpsFileSizeInBytes > 1024 * 1024 * 4 ){
          setError( TRACE_ERROR_GPS_FILE_TOO_BIG, "gpsFileTooBig") ;
      }
    }
    return isSuccess ;
  }
  
  bool get isSuccess => _success == "true" ;
  bool get isUpdate =>_isUpdate == "true" ;
  bool get isCreate => !isUpdate ;  

  void set isUpdate(bool value ){
    _isUpdate =  value.toString().toLowerCase(); 
  }
  
  String get creator {
   if (key!=null) {
      return key.split("/")[0];
   }
   return null ;
  }
  
  bool operationAllowed(String login, bool admin){
    if (login == null){
      return false;
    }
    if (isCreate){
      return true;
    }
    if (admin){
      return true;
    }    
    return creator != null && creator == login ;
  }
  
}


const int WATCH_POINT_NAME_MIN_LENGTH = 5 ;
const String WATCH_POINT_ERROR_NAME_MIN_LENGTH = "watch.point.error.nameMinLength" ;
const String WATCH_POINT_ERROR_NOT_FOUND = "watch.point.error.not.found" ;

class WatchPointForm implements ToJson{
  
  String id;

  String traceKey;
  
  String name;

  String description;
  
  String type;
  
  num latitude;
  num longitude;
  List<num> distance = new List<num>();
  
  String _success = "true" ;
  String error = null;
  String errorField = null;
  
  WatchPointForm.empty();
  
  WatchPointForm(  this.name, this.description, this.type, this.latitude, this.longitude);

  WatchPointForm.fromJson(Map map) {
    id = map['_id'];
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
    _success = map["_success"] ;
    error = map["error"] ;
    errorField = map["errorField"] ;
  }
  
  Map toJson() {
    return {'_id': id,'traceKey': traceKey,'name': name, 'description': description, 
      'type': type, 'latitude': latitude, 'longitude': longitude, 'distance': distance,
      '_success':_success,
      'error':error,
      'errorField':errorField
      };
  }
  
  
  bool validate(){
    _success = "true" ;
    if (name == null ||  name != null && name.length < WATCH_POINT_NAME_MIN_LENGTH ){
      setError(  WATCH_POINT_ERROR_NAME_MIN_LENGTH , "name") ;
    }
    return isSuccess ;
  }
  
  void setError( String error, String errorField  ){
    _success = "false";
    this.error = error;
    this.errorField = errorField;
  }
  
  bool get isSuccess => _success == "true" ;
  
}


const int COMMENT_CONTENT_MIN_LENGTH = 1 ;
const String COMMENT_CONTENT_ERROR_MIN_LENGTH = "comment.error.contentMinLength" ;


class CommentForm implements ToJson{
  
  String id;

  String creator ;
  
  String targetKey;
  
  String targetType;

  String content;
  
  int _creationDateInMilliseconds ;
  int _lastUpdateDateInMilliseconds ;
  
  String _success = "true" ;
  String error = null;
  String errorField = null;
  
  CommentForm.empty();
  
  CommentForm.trace(   this.targetKey, this.content){
    targetType = "trace" ;
  }

  CommentForm.traceWithTime(  this.creator, this.targetKey, this.content, this._creationDateInMilliseconds,  this._lastUpdateDateInMilliseconds ){
     targetType = "trace" ;
   }
  
  CommentForm.fromJson(Map map) {
    id = map['_id'];
    creator = map['creator'];
    targetKey = map['targetKey'];
    targetType = map['targetType'];
    content = map['content'];
    _creationDateInMilliseconds = map['creationDateInMilliseconds'];
    _lastUpdateDateInMilliseconds = map['lastUpdateDateInMilliseconds'];
    _success = map["_success"] ;
    error = map["error"] ;
    errorField = map["errorField"] ;
  }
  
  Map toJson() {
    return {'_id': id,
      'creator': creator,
      'targetKey': targetKey,
      'targetType': targetType, 
      'content': content, 
      'creationDateInMilliseconds': _creationDateInMilliseconds, 
      'lastUpdateDateInMilliseconds': _lastUpdateDateInMilliseconds, 
      '_success': _success,
      'error':error,
      'errorField':errorField
      };
  }
  
  
  bool validate(){
    _success = "true" ;
    if (content == null ||  content != null && content.length < COMMENT_CONTENT_MIN_LENGTH ){
      setError(  COMMENT_CONTENT_ERROR_MIN_LENGTH , "content") ;
    }
    return isSuccess ;
  }
  
  void setError( String error, String errorField  ){
    _success = "false";
    this.error = error;
    this.errorField = errorField;
  }
  
  bool get isSuccess => _success == "true" ;
 
  String get lastUpdateDate{
    if(_lastUpdateDateInMilliseconds != null){
      DateTime date  = new DateTime.fromMillisecondsSinceEpoch(_lastUpdateDateInMilliseconds);
      var formatter = new DateFormat('dd/MM/yyyy HH:mm');
      return formatter.format(date);
    }
    return "" ;
  }
}



class CommentsForm implements ToJson{
  
  String targetKey;
  
  String targetType;
  
  List<CommentForm> comments = new List<CommentForm>() ;

  CommentsForm.empty();
  
  CommentsForm.trace(  this.targetKey){
    targetType = "trace" ;
  }

  CommentsForm.fromJson(Map map) {
    targetKey = map['targetKey'];
    targetType = map['targetType'];
    List<Map> commentsAsMap = JSON.decode( map['comments'] ) ;  
    comments = new List<CommentForm>();
    if(commentsAsMap != null){
      commentsAsMap.forEach((c){
        comments.add( new CommentForm.fromJson(c) ) ;
      });
    }
  }
  
  Map toJson() {
    return {
      'targetKey': targetKey,
      'targetType': targetType, 
      'comments': JSON.encode( comments ),
      };
  }

  
}

