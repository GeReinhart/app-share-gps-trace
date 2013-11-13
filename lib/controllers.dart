

library trails;

import "dart:io";
import "dart:async";
import "dart:convert";
import "package:stream/stream.dart";
import "package:rikulo_security/security.dart";
import "package:rikulo_security/plugin.dart";
import "package:rikulo_commons/convert.dart" ;

import  "../web/shared/forms.dart";
import  "../web/client/renderers.dart";
import  "models.dart";
import  "persistence.dart";
import  "aaa.dart";
import  "trace.dart";

part "../web/rsp/login.rsp.dart";
part "../web/rsp/register.rsp.dart";
part "../web/rsp/index.rsp.dart";
part "../web/rsp/traceAnalysisView.rsp.dart" ;
part "../web/rsp/templates/spaces.rsp.dart";
part "../web/rsp/templates/loading.rsp.dart";
part "../web/rsp/templates/menu.rsp.dart";
part "../web/rsp/templates/center.rsp.dart";
part "../web/rsp/templates/loginForm.rsp.dart";
part "../web/rsp/templates/traceGpxViewer.rsp.dart";
part "../web/rsp/templates/traceProfileViewer.rsp.dart";
part "../web/rsp/templates/traceStatisticsViewer.rsp.dart";

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
      ..headers.set("Content-type","application/json")
      ..write( JSON.encode( form.toJson()) );  
    return new Future.value(); 
  }
  
  Future login(HttpConnect connect) {
    return _security.login(connect);
  }
  
  Future logout(HttpConnect connect) {
    return _security.logout(connect);
  }
  
  
  Future traceAnalysis(HttpConnect connect) {
    Map<String,String>  params = new Map.from(connect.request.uri.queryParameters);
    if( !params.containsKey("gpxFileUrl")  ){
      return traceAnalysisView(connect);
    }else{
      String gpxFileUrl = params["gpxFileUrl"];
      return TraceAnalysis.fromGpxUrl(gpxFileUrl).then((traceAnalysis){
        TraceAnalysisRenderer renderer = new TraceAnalysisRenderer(traceAnalysis);
        return traceAnalysisView(connect, traceAnalysisRenderer:renderer);
      });
    }
  }
  
}