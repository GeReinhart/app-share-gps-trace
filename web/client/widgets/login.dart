import "dart:html";
import 'dart:async';
import "dart:convert";

import "widget.dart" ;
import "modal.dart" ;
import "loading.dart" ;
import "../events.dart" ;
import "../spaces.dart";
import "../forms.dart";


class LoginWidget extends Widget with ModalWidget, LoginLogoutEventProducer {
  
  StreamController _eventStream ;
  bool hasFailed = false;
  
  
  LoginWidget(String id, LoadingShower loadingShower ): super.withLoading(id,loadingShower){
    initModalWidget();
    initLoginLogoutEventProducer();
    _initLoginWidget();
  }
  
  void _initLoginWidget(){
    querySelector("#${this.id}-btn-login").onClick.listen((e) {
      _callLogin();
    });
    querySelector("#${this.id}-btn-cancel").onClick.listen((e) {
      hideModalWidget(id);
    });
  }

  void _loginOKCancel(OKCancelEvent event){
    if (event.ok){
      _callLogin();
    }else{
      hideModalWidget(id);
      stopLoading();
    }
  }
  
  void _callLogin(){
      
      startLoading();
      HttpRequest request = new HttpRequest();
      
      request.onReadyStateChange.listen((_) {
        
        if (request.readyState == HttpRequest.DONE ) {
          LoginForm form = new LoginForm.fromJson(JSON.decode(request.responseText));
          var message = querySelector("#${id}-error-message");
          if (form.isSuccess){
            hideModalWidget(id);
            stopLoading();
            sendLoginEvent(form.login, form.isAdmin);
          }else {
            message.text = "Le login ou le mot de passe est incorrect" ;
          }
        }
      });

      request.open("POST",  "/j_login", async: true);
      String login =  (querySelector("#${id}-input-login") as InputElement ).value ;
      String password =  (querySelector("#${id}-input-password") as InputElement ).value ;
      LoginForm form =  new  LoginForm(login,password);
      request.send(JSON.encode(form.toJson()));
  }
  
  void showLoginModal(){
    (querySelector("#${id}-input-login") as InputElement ).value = "" ;
    (querySelector("#${id}-input-password") as InputElement ).value = "" ;
    querySelector("#${id}-error-message").text = "";
    showModalWidget(id);
  }
  

}