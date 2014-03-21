
import 'dart:convert';


abstract class ToJson{
  Map toJson() ;
}

class LoginForm implements ToJson{
  String login;
  String _admin = "false";
  String password;
  String error = null;

  LoginForm(this.login,this.password);

  LoginForm.forLogout();
  
  LoginForm.fromJson(Map map) {
    _fromJson(map);
  }
  
  void _fromJson(Map map) {
    login = map['login'];
    _admin = map['admin'];
    password = map['password'];
    error = map['error'];
  }
  
  Map toJson() {
    return {'login': login,'admin': _admin,'password': password,'error':error};
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
    _admin = params["admin"] ;
    passwordConfirm = params["passwordConfirm"] ;
    _success = params["_success"] ;
    error = params["error"] ;
    errorField = params["errorField"] ;
  }
  
  Map toJson() {
    return {'login': login,
             'password': password,
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
  String inclinationUpGt;
  String startPointElevetionGt;
  String upperPointElevetionGt;
  String difficultyGt;
  String lengthLt;
  String upLt ;
  String inclinationUpLt;
  String startPointElevetionLt;
  String upperPointElevetionLt;
  String difficultyLt;
  
  double mapBoundNELat ;
  double mapBoundNELong ;
  double mapBoundSWLat ;
  double mapBoundSWLong ;
  
  List<LightTrace> results;
  
  SearchForm();
  
  SearchForm.fromMap(Map jsonMap){
    _fromMap(jsonMap);
  }
  
  bool equals( SearchForm other){
    if ( ! _stringEquals(search, other.search) ) return false ;
    if ( ! _stringEquals(creator, other.creator) ) return false ;
    if ( ! _stringEquals(_activities, other._activities) ) return false ;
    if ( ! _stringEquals(lengthGt, other.lengthGt) ) return false ;
    if ( ! _stringEquals(inclinationUpGt, other.inclinationUpGt) ) return false ;
    if ( ! _stringEquals(startPointElevetionGt, other.startPointElevetionGt) ) return false ;
    if ( ! _stringEquals(upperPointElevetionGt, other.upperPointElevetionGt) ) return false ;

    if ( ! _stringEquals(difficultyGt, other.difficultyGt) ) return false ;
    if ( ! _stringEquals(lengthLt, other.lengthLt) ) return false ;
    if ( ! _stringEquals(upLt, other.upLt) ) return false ;
    if ( ! _stringEquals(inclinationUpLt, other.inclinationUpLt) ) return false ;
    if ( ! _stringEquals(startPointElevetionLt, other.startPointElevetionLt) ) return false ;
    if ( ! _stringEquals(upperPointElevetionLt, other.upperPointElevetionLt) ) return false ;
    if ( ! _stringEquals(difficultyLt, other.difficultyLt) ) return false ;

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
    inclinationUpGt = jsonMap["inclinationUpGt"] ;
    startPointElevetionGt = jsonMap["startPointElevetionGt"] ;
    upperPointElevetionGt = jsonMap["upperPointElevetionGt"] ;
    difficultyGt = jsonMap["difficultyGt"] ;
    lengthLt = jsonMap["lengthLt"] ;
    upLt = jsonMap["upLt"] ;
    inclinationUpLt = jsonMap["inclinationUpLt"] ;
    startPointElevetionLt = jsonMap["startPointElevetionLt"] ;
    upperPointElevetionLt = jsonMap["upperPointElevetionLt"] ;
    difficultyLt = jsonMap["difficultyLt"] ;
        
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
             'inclinationUpGt': inclinationUpGt,             
             'startPointElevetionGt': startPointElevetionGt,             
             'upperPointElevetionGt': upperPointElevetionGt,             
             'difficultyGt': difficultyGt,             
             'lengthLt': lengthLt,             
             'upLt': upLt,             
             'inclinationUpLt': inclinationUpLt,             
             'startPointElevetionLt': startPointElevetionLt,             
             'upperPointElevetionLt': upperPointElevetionLt,             
             'difficultyLt': difficultyLt,  
             'mapBoundNELat': mapBoundNELat,               
             'mapBoundNELong': mapBoundNELong,               
             'mapBoundSWLat': mapBoundSWLat,               
             'mapBoundSWLong': mapBoundSWLong,               
             'results':results};
  }
  
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
    List<String> profilePointsAsString = JSON.decode( jsonMap['profilePoints'] ) ;  
    profilePoints = new List<ProfilePoint>();
    profilePointsAsString.forEach((p){
      profilePoints.add( new ProfilePoint.fromMap(p) ) ;
    });
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
  
  bool  isUpdate ;
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
    isUpdate = jsonMap['isUpdate'] ;
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
             'isUpdate': isUpdate,
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
    if( isCreate ){
      if (gpsFileName == null ||  gpsFileName != null && gpsFileName.isEmpty ){
          setError( TRACE_ERROR_GPS_FILE_MISSING, "gpsFile") ;
      }
    }
    if (activityKeys == null ||  activityKeys != null && activityKeys.isEmpty ){
      setError( TRACE_ERROR_ACTIVITY_MISSING, "activities") ;
    }
    if (title == null ||  title != null && title.length < TRACE_TITLE_MIN_LENGTH ){
      setError( TRACE_ERROR_TITLE_MIN_LENGTH, "title") ;
    }


    return isSuccess ;
  }
  
  bool get isSuccess => _success == "true" ;
  bool get isCreate => !isUpdate ;  
}
