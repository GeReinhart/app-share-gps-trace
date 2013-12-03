

library trails;

import "dart:io";
import "dart:async";
import "dart:convert";
import 'package:http_server/http_server.dart';
import "package:rikulo_security/plugin.dart";
import "package:rikulo_security/security.dart";
import "package:stream/stream.dart";
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
part "../web/rsp/traceAddFormView.rsp.dart" ;
part "../web/rsp/traceView.rsp.dart" ;
part "../web/rsp/traceFormatGpxView.rsp.dart" ;
part "../web/rsp/templates/spaces.rsp.dart";
part "../web/rsp/templates/loading.rsp.dart";
part "../web/rsp/templates/menu.rsp.dart";
part "../web/rsp/templates/center.rsp.dart";
part "../web/rsp/templates/loginForm.rsp.dart";
part "../web/rsp/templates/traceGpxViewer.rsp.dart";
part "../web/rsp/templates/traceProfileViewer.rsp.dart";
part "../web/rsp/templates/traceStatisticsViewer.rsp.dart";

class TraceController{
  
  PersistenceLayer _persistence ;
  Crypto _crypto ;
  Security _security ;
  String _appUri ;
  
  TraceController(this._persistence, this._crypto, this._appUri){

    final authenticator = new Authentication(_persistence,_crypto) ;
    final accessControl = new SimpleAccessControl({
      "/.*": ["user", "admin"]
    });
  
    _security = new Security(authenticator, accessControl);
    
  }
  
  Security get security => _security ;
  
  
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
  
  Future traceAddForm(HttpConnect connect) {
    return traceAddFormView(connect);
  }
  
  Future traceAddFormSubmit(HttpConnect connect) {
    
    User user =  currentUser(connect.request.session);
    if (user == null ){
      return connect.forward("/403") ;
    }
      
      
    DateTime now = new DateTime.now();
    String tempFile = "/tmp/" +  now.millisecondsSinceEpoch.toString();

    return HttpBodyHandler.processRequest(connect.request).then((body) {
      String title = body.body['title'];
      String description = body.body['description'];
      HttpBodyFileUpload fileUploaded = body.body['gpxUploadedFile'];
      final file = new File(tempFile);
      return file.writeAsBytes(fileUploaded.content, mode: FileMode.WRITE)
          .then((_) {
            return TraceAnalysis.fromGpxFile(file).then((traceAnalysis){
              
              Trace trace = new Trace.fromTraceAnalysis(user.login, traceAnalysis); 
              trace.title = title ;
              trace.description = description ;
              
              return _persistence.saveOrUpdateTrace(trace).then((trace) {
                return connect.forward("/trace/id-" + trace.cleanId) ;
              });
            });
          }).whenComplete((){
            try {
              new File(tempFile).delete();
            } catch(e) {
              print("Unable to delete ${tempFile}: ${e}");
            }
          } );
    });
  }
  
  Future traceShow(HttpConnect connect) {
    String cleanTraceId = connect.dataset["traceId"];
    String traceId = "ObjectId(\"" + cleanTraceId +"\")";
    return _persistence.getTraceById(traceId).then((trace) {
      String gpxUrl = _appUri +"/trace.gpx/id-"+cleanTraceId ;
      String permanentTraceUrl = _appUri + "/trace/id-"+cleanTraceId ;
      TraceRenderer renderer = new TraceRenderer(trace, permanentTraceUrl,gpxUrl);
      return traceView(connect, traceRenderer:renderer);
    });
    
  }
  
  Future traceFormatGpxShow(HttpConnect connect) {
    String cleanTraceId = connect.dataset["traceId"];
    String traceId = "ObjectId(\"" + cleanTraceId +"\")";
    return _persistence.getTraceById(traceId).then((trace) {
      return traceFormatGpxView(connect, trace:trace);
    });
    
  }
  
  
}