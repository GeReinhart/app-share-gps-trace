
library trails;

import "dart:io";
import "dart:async";
import "../packages/stream/stream.dart";
import "../packages/rikulo_security/security.dart";

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


class TrailsServer{
  
  String host;
  int port;
  
  TrailController _trailController;
  
  TrailsServer(this.host,this.port){
    createApplicationContext();
  }
  
  TrailsServer.forHeroku(){
    host ="0.0.0.0";
    port = int.parse(Platform.environment['PORT']);
    createApplicationContext();
  }
  
  void createApplicationContext(){
    String mongoDbUri = Platform.environment['MONGO_DB_URI'] ;
    print ("Db: "+mongoDbUri);

    PersistenceLayer _persistenceLayer = new MongoPersistence(mongoDbUri);
    _persistenceLayer.open();
    Crypto _crypto = new Crypto();
    _trailController = new TrailController(_persistenceLayer,_crypto) ;
  }
  
  
  void start(){
    new StreamServer(
        uriMapping: {
          "/": index, 

          "/register": register, 
          "/as_register": _trailController.aRegister,

          "/login": login, 
          "/s_login": _trailController.login,

          "/s_logout": _trailController.logout,
          "/logout":  _trailController.logout,

          "get:/trace.analysis": _trailController.traceAnalysisFromUrl,          
          "post:/trace.analysis": _trailController.traceAnalysisFromFile, 
          
        },
        /* filterMapping: {
          "/.*": security.filter
        },*/
        errorMapping: {
          "404": "/404.html"
        }
    ).start(address:host, port:port);
  }

}








