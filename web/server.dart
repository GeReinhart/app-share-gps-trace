
library trails;

import "package:stream/stream.dart";
import "dart:io";
import "dart:async";
import "package:rikulo_security/security.dart";
import "package:rikulo_security/plugin.dart";

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
    
    //1. you have to implement [Authenticator]. For sake of description, we use a dummy one
    final authenticator = new DummyAuthenticator()
    ..addUser("john", "123", ["user"])
    ..addUser("admin", "123", ["user", "admin"]);

  //2. you can use [SimpleAccessControl] or implements your own
  final accessControl = new SimpleAccessControl({
    "/.*": ["user", "admin"]
  });

  //3. instantiate [Security]
  final security = new Security(authenticator, accessControl);

  //4. start Stream server
  new StreamServer(
      uriMapping: {
        "/": index, 
        "/login": login, 
        "/about": about, 
        "/mock": mock,         
        "/s_login": security.login,
        "/s_logout": security.logout
      },
/*      filterMapping: {
        "/.*": security.filter
      },*/
      errorMapping: {
        "404": "/404.html"
      }
  ).start(address:host, port:port);
    
    
    
    //new StreamServer().start(address:host, port:port);
  }
  
  
  
  
}