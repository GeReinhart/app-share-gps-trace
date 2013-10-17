
import "package:rikulo_security/security.dart";
import "package:rikulo_security/plugin.dart";
import "package:stream/stream.dart";
import "dart:io";
import "dart:async";
import "package:rikulo_commons/io.dart" show HttpUtil;

import  "forms.dart";
import  "models.dart";
import  "persistence.dart";
import  "aaa.dart";

class TrailController{
  
  PersistenceLayer _persistenceLayer ;
  Crypto _crypto ;
  Security _security ;
  
  TrailController(this._persistenceLayer, this._crypto){

    final authenticator = new Authentication(_persistenceLayer,_crypto) ;
    final accessControl = new SimpleAccessControl({
      "/.*": ["user", "admin"]
    });
  
    _security = new Security(authenticator, accessControl);
    
  }
  
  Future register(HttpConnect connect) {
    
    return HttpUtil.decodePostedParameters(connect.request,
                              new Map.from(connect.request.uri.queryParameters))
                             .then((Map<String, String> params) {

          final RegisterForm form = new RegisterForm.fromMap(params);

          if ( !form.isValid() ){
            // TODO handle error properly        
            connect.redirect("/");
            return new Future.value();
          }else{
            return _persistenceLayer.getUserByLogin(form.login).then((user){
                  if (user != null){
                    // TODO handle error properly        
                    connect.redirect("/");
                    return new Future.value();
                  }else{
                    User user = new User.withLogin(form.login,_crypto.encryptPassword(form.password));
                    print ("register user "+ user.toJson().toString());
                    _persistenceLayer.saveOrUpdateUser(user);
                    connect.redirect("/login");
                    return new Future.value();
                  }
              });
          }
      });
  }
  
  Future login(HttpConnect connect) {
    return _security.login(connect);
  }
  
  Future logout(HttpConnect connect) {
    return _security.logout(connect);
  }
  
}