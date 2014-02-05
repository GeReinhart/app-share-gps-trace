import "dart:html";
import 'dart:async';
import "dart:convert";

import "widget.dart" ;
import "modal.dart" ;
import "loading.dart" ;
import "../events.dart" ;
import "../spaces.dart";
import "../forms.dart";


class RegisterWidget extends Widget with ModalWidget, LoginLogoutEventProducer {
  
  StreamController _eventStream ;
  bool hasFailed = false;
  
  RegisterWidget(String id, LoadingShower loadingShower ): super.withLoading(id,loadingShower){
    initModalWidget();
    initLoginLogoutEventProducer();
    _initRegisterWidget();
  }
  
  void _initRegisterWidget(){
    querySelector("#${this.id}-btn-submit").onClick.listen((e) {
      _callRegister();
    });
    querySelector("#${this.id}-btn-cancel").onClick.listen((e) {
      hideModalWidget(id);
    });
  }

  void _callRegister(){
      
      HttpRequest request = new HttpRequest();
      
      request.onReadyStateChange.listen((_) {
        
        if (request.readyState == HttpRequest.DONE ) {

          RegisterForm form = new RegisterForm.fromMap(JSON.decode(request.responseText));
          var message = querySelector("#${this.id}-error-message");
          if (form.isSuccess){
            hideModalWidget(id);
            sendLoginEvent(form.login, form.isAdmin);
          }else {
            switch (form.error) {
              case REGISTER_ERROR_LOGIN_EXISTS:
                message.text = "Le login existe déjà" ;
                break;
              case REGISTER_ERROR_PASSWORD_MIN_LENGTH:
                message.text = "Le mot de passe est trop court" ;
                break;
              case REGISTER_ERROR_PASSWORD_CONFIRM:
                message.text = "Le mot de passe n'est pas confirmé correctement" ;
                break;
              case REGISTER_ERROR_LOGIN_MIN_LENGTH:
                message.text = "Le login est trop court" ;
                break;
            }
          }
        }
      });

      request.open("POST",  "/j_register", async: false);
      RegisterForm form =  new  RegisterForm( (querySelector("#${this.id}-login") as InputElement).value,
          (querySelector("#${this.id}-password") as InputElement).value,
          (querySelector("#${this.id}-password-confirm") as InputElement).value);
      request.send(JSON.encode(form.toJson()));      
  }
  
  void showRegisterModal(){
    (querySelector("#${this.id}-password") as InputElement).value= "" ;
    (querySelector("#${this.id}-password-confirm") as InputElement).value = "";
    querySelector("#${this.id}-error-message").text = "" ;
    showModalWidget(id);
  }
  
}