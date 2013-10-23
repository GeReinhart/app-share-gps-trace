
import "dart:io";
import "dart:async";
import "dart:convert";
import "package:stream/stream.dart";
import "package:rikulo_security/security.dart";
import "package:rikulo_security/plugin.dart";
import "package:rikulo_commons/convert.dart" ;

import  "../web/shared/forms.dart";
import  "models.dart";
import  "persistence.dart";
import  "aaa.dart";

class TrailController{
  
  PersistenceLayer _persistence ;
  Crypto _crypto ;
  Security _security ;
  
  TrailController(this._persistence, this._crypto){

    final authenticator = new Authentication(_persistence,_crypto) ;
    final accessControl = new SimpleAccessControl({
      "/.*": ["user", "admin"]
    });
  
    _security = new Security(authenticator, accessControl);
    
  }
  
  Future aRegister(HttpConnect connect) {
    
    return _decodePostedJson(connect.request,
                        new Map.from(connect.request.uri.queryParameters))
                             .then((Map<String, String> params) {

      final RegisterForm form = new RegisterForm.fromMap(params );
      if ( !form.validate() ){
        return _writeFormIntoResponse(connect.response, form);
      }else{
        return  _persistence.getUserByLogin(form.login).then((user){
            if (user != null){
              
              form.setErrorLoginExists();
              return _writeFormIntoResponse(connect.response, form); 
              
            }else{   
              
              User user = new User.withLogin(form.login,_crypto.encryptPassword(form.password));
              print ("# Register user "+ user.toJson().toString());
              return _persistence.saveOrUpdateUser(user)
                .then((_){
                return _writeFormIntoResponse(connect.response, form);                        
              });
            }
          });
      }
    });
  }
  
  Future<Map<String, String>> _decodePostedJson(
      Stream<List<int>> request, [Map<String, String> parameters])
      => readAsString(request)
         .then((String data) {
          return JSON.decode(data); 
   });
  
  
  Future _writeFormIntoResponse(HttpResponse response, form){
    response
      ..headers.contentType = contentTypes["json"]
      ..write( JSON.encode( form.toJson()) );  
    return new Future.value(); 
  }
  
  Future login(HttpConnect connect) {
    return _security.login(connect);
  }
  
  Future logout(HttpConnect connect) {
    return _security.logout(connect);
  }
  
}