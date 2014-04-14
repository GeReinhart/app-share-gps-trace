
import "dart:html";
import 'dart:async';
import "dart:convert";

import "forms.dart";
import "events.dart" ;

class Authentication extends Object with LoginLogoutEventProducer{
  
  StreamController _loginLogoutEventStream ;
  Storage _localStorage = window.localStorage;
  
  String login;
  bool isAdmin;
  
  Authentication(){
      initLoginLogoutEventProducer();
  }
  
  void storeAuthentication(String login, bool isAdmin, String encryptedPassword){
    if (login == null){
      _localStorage.remove('login');
      _localStorage.remove('encryptedPassword');
    }else{
      _localStorage['login'] =  login;
      _localStorage['encryptedPassword'] =  encryptedPassword;
    }
    this.login = login;
    this.isAdmin = isAdmin;
  }
  
  void resetAuthentication(){
    storeAuthentication(null,false,null);
  }
  
  void authenticate({String login:null, String password:null}){
    if (login == null){
      _authenticateFromLocalStorage() ;
    }else{
      _callLogin( login:login, password:password);
    }
  }
  
  void _authenticateFromLocalStorage() {
     String login = _localStorage['login'] ;
     String encryptedPassword = _localStorage['encryptedPassword'] ;
     if(  login != null && encryptedPassword != null ){
       _callLogin(login:login, encryptedPassword:encryptedPassword);
     }
  }
  
  void _callLogin({String login:null, String password:null, String encryptedPassword:null}){
      HttpRequest request = new HttpRequest();
      request.onReadyStateChange.listen((_) {
        if (request.readyState == HttpRequest.DONE ) {
          LoginForm form = new LoginForm.fromJson(JSON.decode(request.responseText));
          if (form.isSuccess){
            storeAuthentication(form.login, form.isAdmin, form.encryptedPassword);
            sendLoginEvent(form.login, form.isAdmin, form.encryptedPassword);
          }
        }
      });
      request.open("POST",  "/j_login", async: true);
      LoginForm form =  new  LoginForm.withEncryptedPassword(login,password,encryptedPassword);
      request.send(JSON.encode(form.toJson()));
  }
  
}

