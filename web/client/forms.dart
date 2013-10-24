

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
