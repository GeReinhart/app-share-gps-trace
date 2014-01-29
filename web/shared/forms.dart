


class LoginForm{
  String login;
  String password;
  String error = null;

  LoginForm(this.login,this.password);

  LoginForm.fromJson(Map map) {
    _fromJson(map);
  }
  
  void _fromJson(Map map) {
    login = map['login'];
    password = map['password'];
    error = map['error'];
  }
  
  Map toJson() {
    return {'login': login,'password': password,'error':error};
  }

  bool get isSuccess => error==null;
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


class RegisterForm{
  
  String login;
  String password;
  String passwordConfirm;
  String _success = "true" ;
  String error = null;
  String errorField = null;
  
  RegisterForm( this.login, this.password, this.passwordConfirm );
  
  RegisterForm.fromMap(Map<String, String> params){
    _fromMap(params);
  }
  
  void _fromMap(Map<String, String> params){
    login = params["login"] ;
    password = params["password"] ;
    passwordConfirm = params["passwordConfirm"] ;
    _success = params["_success"] ;
    error = params["error"] ;
    errorField = params["errorField"] ;
  }
  
  Map toJson() {
    return {'login': login,
             'password': password,
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
    
    return success ;
  }
  
  bool get success => _success == "true" ;
}

class DeleteTraceForm{
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

class SearchForm{

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



class LightTrace{
  String key;
  String creator ;
  String title ;
  String activities ;
  String length;
  String up;
  String upperPointElevetion;
  String inclinationUp;
  String difficulty;
  num startPointLatitude;
  num startPointLongitude;
  
  LightTrace(this.key, this.creator, this.title, this.activities, this.length,
             this.up, this.upperPointElevetion, this.inclinationUp, this.difficulty,
             this.startPointLatitude , this.startPointLongitude  );
  
  LightTrace.fromMap(Map jsonMap){
    _fromMap(jsonMap);
  }
  
  void _fromMap(Map jsonMap){
    key = jsonMap['key'] ;
    creator = jsonMap['creator'] ;
    title = jsonMap['title'] ;
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
  
}

