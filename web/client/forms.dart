import 'dart:convert';

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
const String REGISTER_ERROR_LOGIN_FORBIDDEN_CHARACTER = "register.error.loginForbiddenCharacter" ;

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



class SearchForm{
  
  String creator;
  String activities;
  List<LightTrace> results;
  
  SearchForm();
  
  SearchForm.fromMap(Map jsonMap){
    _fromMap(jsonMap);
  }
  
  void _fromMap(Map jsonMap){
    creator = jsonMap["creator"] ;
    activities = jsonMap["activities"] ;
    results = new List<LightTrace>();
    List<Map> resultsAsJson = jsonMap["results"] ;
    if (resultsAsJson!= null && resultsAsJson.isNotEmpty  ){
      resultsAsJson.forEach((traceAsJson){
        results.add(new LightTrace.fromMap(traceAsJson)) ;
      });
    }
  }
  
  Map toJson() {
    return {'creator': creator,
             'activities': activities,
             'results':results};
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
  
  LightTrace(this.key, this.creator, this.title, this.activities, this.length, this.up, this.upperPointElevetion, this.inclinationUp, this.difficulty);
  
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
             'difficulty':difficulty
            };
  }
  
}




