
library trails;

import "package:stream/stream.dart";
import "dart:io";
import "dart:async";
import "package:rikulo_security/security.dart";
import "package:rikulo_security/plugin.dart";

import  "../lib/persistence.dart";
import  "../lib/aaa.dart";

part "rsp/login.rsp.dart";
part "rsp/index.rsp.dart";
part "rsp/about.rsp.dart";
part "rsp/mock.rsp.dart";

class TrailsServer{
  
  String host;
  int port;
  
  TrailsServer(this.host,this.port);
  
  TrailsServer.forHeroku(){
    host ="0.0.0.0";
    port = int.parse(Platform.environment['PORT']);
  }
  
  void start(){
    
    String mongoDbUri = Platform.environment['MONGO_DB_URI'] ;
    PersistenceLayer persistenceLayer = new MongoPersistence(mongoDbUri);
    Crypto crypto = new Crypto();
    
    final authenticator = new Authentication(persistenceLayer,crypto) ;

    final accessControl = new SimpleAccessControl({
      "/.*": ["user", "admin"]
    });
  
    final security = new Security(authenticator, accessControl);
  
    new StreamServer(
        uriMapping: {
          "/": index, 
          "/login": login, 
          "/about": about, 
          "/mock": mock,         
          "/s_login": security.login,
          "/s_logout": security.logout
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