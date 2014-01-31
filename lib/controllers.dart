library trails;

import "dart:io";
import "dart:async";
import "dart:convert";
import 'package:http_server/http_server.dart';
import "package:rikulo_security/plugin.dart";
import "package:rikulo_security/security.dart";
import "package:stream/stream.dart";
import "package:rikulo_commons/convert.dart" ;
import "package:gps_trace/gps_trace.dart";

import  "../web/shared/forms.dart";
import  "../web/client/renderers.dart";
import  "models.dart";
import  "persistence.dart";
import  "aaa.dart";

part "../web/rsp/login.rsp.dart";
part "../web/rsp/sandbox.rsp.dart";
part "../web/rsp/about.rsp.dart" ;
part "../web/rsp/register.rsp.dart";
part "../web/rsp/index.rsp.dart";
part "../web/rsp/traceAddFormView.rsp.dart" ;
part "../web/rsp/traceView.rsp.dart" ;
part "../web/rsp/traceFormatGpxView.rsp.dart" ;
part "../web/rsp/traceSearchView.rsp.dart" ;
part "../web/rsp/disclaimer.rsp.dart" ;
part "../web/rsp/templates/spaces.rsp.dart";
part "../web/rsp/templates/loading.rsp.dart";
part "../web/rsp/templates/menu.rsp.dart";
part "../web/rsp/templates/center.rsp.dart";
part "../web/rsp/templates/loginForm.rsp.dart";
part "../web/rsp/templates/traceGpxViewer.rsp.dart";
part "../web/rsp/templates/traceProfileViewer.rsp.dart";
part "../web/rsp/templates/traceStatisticsViewer.rsp.dart";
part "../web/rsp/templates/persistentMenu.rsp.dart";
part "../web/rsp/templates/searchForm.rsp.dart";
part "../web/rsp/templates/searchResults.rsp.dart";
part "../web/rsp/templates/searchResultsOnMap.rsp.dart";

part "../web/rsp/widgets/confirmWidget.rsp.dart";

class TraceController{
  
  PersistenceLayer _persistence ;
  Crypto _crypto ;
  Security _security ;
  String _appUri ;
  TraceAnalyser _traceAnalyser = new TraceAnalyser();
  
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
                             .then((Map params) {

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
  
  Future aTraceSearch(HttpConnect connect) {
    return _decodePostedJson(connect.request,
        new Map.from(connect.request.uri.queryParameters))
        .then((Map params) {

            final SearchForm form = new SearchForm.fromMap(params );
            SearchFilters filters = new SearchFilters();
            filters.search = form.search;
            filters.creator = form.creator;
            filters.activities = form.activities;
                        
            filters.lengthGt = castToNum(form.lengthGt,1000) ;
            filters.upGt  = castToNum(form.upGt,1) ;
            filters.inclinationUpGt = castToNum(form.inclinationUpGt,1);
            filters.startPointElevetionGt = castToNum(form.startPointElevetionGt,1);
            filters.upperPointElevetionGt = castToNum(form.upperPointElevetionGt,1);
            filters.difficultyGt = castToNum(form.difficultyGt,1);
            filters.lengthLt = castToNum(form.lengthLt,1000);
            filters.upLt  = castToNum(form.upLt,1);
            filters.inclinationUpLt = castToNum(form.inclinationUpLt,1);
            filters.startPointElevetionLt = castToNum(form.startPointElevetionLt,1);
            filters.upperPointElevetionLt = castToNum(form.upperPointElevetionLt,1);
            filters.difficultyLt = castToNum(form.difficultyLt,1);
            
            filters.mapBoundNELat = form.mapBoundNELat ;
            filters.mapBoundNELong  = form.mapBoundNELong ;
            filters.mapBoundSWLat  = form.mapBoundSWLat ;
            filters.mapBoundSWLong  = form.mapBoundSWLong ;
            
            return  _persistence.getTracesByFilters(filters).then((traces){
              form.results = new List();
              if (traces != null){
                traces.forEach((trace){
                    LigthTraceRenderer traceLightRenderer = new LigthTraceRenderer(trace);
                    LightTrace  lightTrace = new   LightTrace(traceLightRenderer.key, traceLightRenderer.creator, traceLightRenderer.titleWithUrl, traceLightRenderer.activities, 
                        traceLightRenderer.length, traceLightRenderer.up, traceLightRenderer.upperPointElevetion, 
                        traceLightRenderer.inclinationUp, traceLightRenderer.difficulty,
                        traceLightRenderer.trace.startPointLatitude,traceLightRenderer.trace.startPointLongitude );
                    form.results.add(lightTrace) ;
                });
              }
              return _writeFormIntoResponse(connect.response, form); 
            });
          
        });
  }
  
  Future aTraceDelete(HttpConnect connect) {
    
    User user =  currentUser(connect.request.session);
    if (user == null  ){
      return  forbiddenAction(connect) ;
    }
    
    return _decodePostedJson(connect.request,
        new Map.from(connect.request.uri.queryParameters))
        .then((Map params) {

          final DeleteTraceForm form = new DeleteTraceForm.fromJson(params );

          return _persistence.getTraceByKey(form.key).then((trace){
            
            if (user.login == trace.creator || user.admin  ){
              return _persistence.deleteTraceByKey(form.key).then((_){
                return _writeFormIntoResponse(connect.response, form); 
              });              
            }else{
              return forbiddenAction(connect) ;
            }
            return _writeFormIntoResponse(connect.response, form); 
          });
    });
  }

  
  Future forbiddenAction(HttpConnect connect){
    return connect.forward("/403") ;
  }
  
  num castToNum(String value, int times){
    if (value == null){
      return null;
    }else{
      try{
        return double.parse(value)* times;
      }catch(e){
        return null;
      }
    }
  }
  
  Future<Map> _decodePostedJson(
      Stream<List<int>> request, [Map<String, String> parameters])
      => readAsString(request)
         .then((String data) {
          return JSON.decode(data); 
   });
  
  Future _writeFormIntoResponse(HttpResponse response, form){
    response
      ..headers.contentType = new ContentType("application", "json", charset: "utf-8")
      ..write( JSON.encode( form.toJson()) );  
    return new Future.value(); 
  }
  
  Future login(HttpConnect connect) {
    return _security.login(connect);
  }
  
  Future logout(HttpConnect connect) {
    return _security.logout(connect);
  }
  
  Future aboutShow(HttpConnect connect) {
    return about(connect);
  }

  Future disclaimerShow(HttpConnect connect) {
    return disclaimer(connect);
  }
  
  Future sandboxShow(HttpConnect connect) {
    return sandbox(connect);
  }
  
  
  Future traceAddForm(HttpConnect connect) {
    return traceAddFormView(connect,traceFormRenderer: new TraceFormRenderer());
  }
  
  Future traceAddFormSubmit(HttpConnect connect) {
    
    User user =  currentUser(connect.request.session);
    if (user == null ){
      return connect.forward("/403") ;
    }
    DateTime now = new DateTime.now();
    String tempFile = "/tmp/" +  now.millisecondsSinceEpoch.toString();

    return HttpBodyHandler.processRequest(connect.request).then((body) {
      Map parameters = body.body as Map ;
      String title = parameters['title'];
      String description = parameters['description'];
      String smoothing = parameters['smoothing'];
      List<String> activities = new List<String>();
      String activityPrefix = "activity-";
      parameters.forEach((k,v){
            if ( k.toString().startsWith(activityPrefix) ){
              activities.add(  k.substring(activityPrefix.length)  );
            }
          }       
      );
      SmoothingParameters smoothingParameters = SmoothingParameters.get( SmoothingLevel.fromString(smoothing ));
      
      HttpBodyFileUpload fileUploaded = body.body['gpxUploadedFile'];
      final file = new File(tempFile);
      return file.writeAsBytes(fileUploaded.content, mode: FileMode.WRITE)
          .then((_) {
            return  _traceAnalyser.buildTraceAnalysisFromGpxFile(file,applyPurge:true,smoothingParameters:smoothingParameters ).then((traceAnalysis){
              
              Trace trace = new Trace.fromTraceAnalysis(user.login, traceAnalysis); 
              trace.title = title ;
              trace.smoothing = smoothing;
              trace.description = description ;
              trace.activities = activities; 
              return _persistence.saveOrUpdateTrace(trace).then((trace) {
                return connect.forward("/trace/" + trace.key) ;
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
  
  Future traceShowById(HttpConnect connect) {
    String cleanTraceId = connect.dataset["traceId"];
    String traceId = "ObjectId(\"" + cleanTraceId +"\")";
    return _persistence.getTraceById(traceId).then((trace) {
      String gpxUrl = _appUri +"/trace.gpx/id-"+cleanTraceId ;
      String permanentTraceUrl = _appUri + "/trace/id-"+cleanTraceId ;
      TraceRenderer renderer = new TraceRenderer(trace, permanentTraceUrl,gpxUrl);
      return traceView(connect, traceRenderer:renderer);
    });
  }
  
  Future traceShowByKey(HttpConnect connect) {
    String creator = connect.dataset["creator"];
    String titleKey = connect.dataset["titleKey"];
    String key = creator +"/" + titleKey;
    return _persistence.getTraceByKey(key).then((trace) {
      String gpxUrl = _appUri +"/trace.gpx/"+key ;
      String permanentTraceUrl = _appUri + "/trace/"+key ;
      TraceRenderer renderer = new TraceRenderer(trace, permanentTraceUrl,gpxUrl);
      return traceView(connect, traceRenderer:renderer);
    });
  }
  
  Future traceFormatGpxShowById(HttpConnect connect) {
    String cleanTraceId = connect.dataset["traceId"];
    String traceId = "ObjectId(\"" + cleanTraceId +"\")";
    return _persistence.getTraceById(traceId).then((trace) {
      connect.response.headers.set("Content-Type", "application/gpx") ; 
      connect.response.headers.set("Content-disposition", "attachment; filename=id-${cleanTraceId}.gpx") ; 
      return traceFormatGpxView(connect, trace:trace);
    });
  }
  
  Future traceFormatGpxShowByKey(HttpConnect connect) {
    String creator = connect.dataset["creator"];
    String titleKey = connect.dataset["titleKey"];
    String key = creator +"/" + titleKey;
    return _persistence.getTraceByKey(key).then((trace) {
      connect.response.headers.set("Content-Type", "application/gpx") ; 
      connect.response.headers.set("Content-disposition", "attachment; filename=${creator}-${titleKey}.gpx") ; 
      return traceFormatGpxView(connect, trace:trace);
    });
  }  
  
  Future traceSearch(HttpConnect connect) {
    return _persistence.getTraces().then((traces) {
      List<LigthTraceRenderer> lightTraceRendererList = new List<LigthTraceRenderer>();
      if ( traces.isNotEmpty  ){
        traces.forEach((trace)=>(lightTraceRendererList.add(new LigthTraceRenderer(trace))  ));
      }
      LigthTraceRenderers ligthTraceRenderers = new LigthTraceRenderers();
      ligthTraceRenderers.traces = lightTraceRendererList;
      return traceSearchView(connect, lightTraceRenderers:ligthTraceRenderers, traceFormRenderer: new TraceFormRenderer());
    });
    
  }
  
}
