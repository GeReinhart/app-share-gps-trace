import "dart:html";
import 'dart:async';
import "dart:convert";

import "widget.dart" ;
import "modal.dart" ;
import "loading.dart" ;
import "../events.dart" ;
import "../spaces.dart";
import "../forms.dart";


class LogoutWidget extends Widget with LoginLogoutEventProducer {
  
  StreamController _eventStream ;
  
  LogoutWidget(String id,  LoadingShower loadingShower ): super.withLoading(id,loadingShower){
    initLoginLogoutEventProducer();
  }
  
  void callLogout(){
      
      startLoading();
      HttpRequest request = new HttpRequest();
      
      request.onReadyStateChange.listen((_) {
        
        if (request.readyState == HttpRequest.DONE ) {
          stopLoading();
          LoginForm form = new LoginForm.fromJson(JSON.decode(request.responseText));
          if (form.isSuccess){
            sendLogoutEvent();
          }
        }
      });

      request.open("POST",  "/j_logout", async: false);
      LoginForm logoutForm =  new  LoginForm.forLogout();
      request.send(JSON.encode(logoutForm.toJson()));
  }

}