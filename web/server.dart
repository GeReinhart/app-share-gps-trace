
library trails;

import "package:stream/stream.dart";
import "dart:io";
import "dart:async";
import "package:rikulo_security/security.dart";


import  "../lib/persistence.dart";
import  "../lib/aaa.dart";
import  "../lib/controllers.dart";

part "rsp/login.rsp.dart";
part "rsp/register.rsp.dart";
part "rsp/index.rsp.dart";
part "rsp/about.rsp.dart";
part "rsp/mock.rsp.dart";
part "rsp/templates/menu.rsp.dart";
part "rsp/templates/center.rsp.dart";

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
          "/logout": index,
          
          "/about": about, 
          "/mock": mock 
        
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








