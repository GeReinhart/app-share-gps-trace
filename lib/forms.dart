

import "dart:io";
import "package:rikulo_commons/mirrors.dart";


class RegisterForm{
  
  String login;
  String password;
  String passwordConfirm;
  
  RegisterForm();

  RegisterForm.fromMap(Map<String, String> params){
    login = params["s_login"] ;
    password = params["s_password"] ;
    passwordConfirm = params["s_passwordConfirm"] ;
  }
  
  bool isValid(){
    return (password == passwordConfirm ) 
        &&  (password != null && password.length >= 5 ) 
        &&  (login    != null && login.length >= 3);
  }
  
}
