import "dart:html";
import "dart:convert";
import '../../packages/bootjack/bootjack.dart';

import "spaces.dart";
import "forms.dart";

void main() {
  SpacesLayout layout = new SpacesLayout(180,15,70);
  
  Modal.use();
  Transition.use();
  
  querySelector(".btn-submit-register").onClick.listen((e) {

    layout.startLoading();
    
    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {

        RegisterForm form = new RegisterForm.fromMap(JSON.decode(request.responseText));
        var message = querySelector(".form-error-message");
        if (form.success){
          Modal.wire( querySelector("#register-success") ).show() ;
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
        
        layout.stopLoading();
      }
    });

    request.open("POST",  "/as_register", async: false);
    RegisterForm form =  new  RegisterForm( querySelector(".input-login").value,
                                            querySelector(".input-password").value,
                                            querySelector(".input-passwordConfirm").value);
    request.send(JSON.encode(form.toJson()));
  });
  
  querySelector(".btn-login").onClick.listen((e) {
    window.location.href = window.location.href.replaceFirst("/register", "/login");
  });
  
  
}

