
library trails;

import "dart:io";
import "dart:async";
import "package:rikulo_security/security.dart";
import "package:stream/stream.dart";

import  "../lib/persistence.dart";
import  "../lib/aaa.dart";
import  "../lib/controllers.dart";

part "rsp/login.rsp.dart";
part "rsp/register.rsp.dart";
part "rsp/index.rsp.dart";
part "rsp/templates/menu.rsp.dart";
part "rsp/templates/center.rsp.dart";
part "rsp/templates/loading.rsp.dart";
part "rsp/templates/spaces.rsp.dart";
part "rsp/templates/loginForm.rsp.dart";
part "rsp/templates/traceGpxViewer.rsp.dart";
part "rsp/templates/traceProfileViewer.rsp.dart";
part "rsp/templates/traceStatisticsViewer.rsp.dart";
part "rsp/templates/persistentMenu.rsp.dart";


class TracesServer{
  
  String host;
  int port;
  
  TraceController _traceController;
  
  TracesServer(this.host,this.port){
    createApplicationContext();
  }
  
  TracesServer.forHeroku(){
    host ="0.0.0.0";
    port = int.parse(Platform.environment['PORT']);
    createApplicationContext();
  }
  
  void createApplicationContext(){
    String mongoDbUri = Platform.environment['MONGO_DB_URI'] ;
    String appUri = Platform.environment['APP_TRACE_URI'] ;
    print ("Db: "+mongoDbUri);

    PersistenceLayer _persistenceLayer = new MongoPersistence(mongoDbUri);
    _persistenceLayer.open();
    Crypto _crypto = new Crypto();
    _traceController = new TraceController(_persistenceLayer,_crypto,appUri) ;
  }
  
  
  void start(){
    new StreamServer(
        uriMapping: {
          "/": index, 
          "/about": _traceController.aboutShow,
          "/disclaimer": _traceController.disclaimerShow,
          
          "/register": register, 
          "/as_register": _traceController.aRegister,

          "/login": login, 
          "/s_login": _traceController.login,

          "/s_logout": _traceController.logout,
          "/logout":  _traceController.logout,

          "get:/trace.add": _traceController.traceAddForm,          
          "post:/trace": _traceController.traceAddFormSubmit,
          
          "/trace/id-(traceId:[^/]*)": _traceController.traceShowById,
          "/trace.gpx/id-(traceId:[^/]*)": _traceController.traceFormatGpxShowById,

          "/trace/(creator:[^/]*)/(titleKey:[^/]*)": _traceController.traceShowByKey,
          "/trace.gpx/(creator:[^/]*)/(titleKey:[^/]*)": _traceController.traceFormatGpxShowByKey,

          
          "/trace.search":  _traceController.traceSearch,
          "/trace.as_search": _traceController.aTraceSearch,
          
        },/*
        filterMapping: {
          "/trace\.add.*": _traceController.security.filter
        },*/
        errorMapping: {
          "404": "/404.html"
        }
    ).start(address:host, port:port);
  }

}








