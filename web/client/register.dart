

import "dart:html";
import "dart:convert";

import "index.dart";
import "spaces.dart";
import "forms.dart";


void main() {
  SpacesLayout layout = new SpacesLayout(spaces,spaceElements,spaceNW,spaceNE,spaceSW,spaceSE,spaceCenter,180);
  
  query(".btn-submit-register").onClick.listen((e) {

    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {

        RegisterForm form = new RegisterForm.fromMap(JSON.decode(request.responseText));
        if (form.success){
          query(".space-south-west").text = "Bienvenue !";
        }else {
          var message = query(".form-error-message");
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

    request.open("POST",  "/as_register", async: false);
    RegisterForm form =  new  RegisterForm( query(".input-login").value,
                                            query(".input-password").value,
                                           query(".input-passwordConfirm").value);
    request.send(JSON.encode(form.toJson()));
  });
}

