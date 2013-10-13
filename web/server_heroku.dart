
import "package:stream/stream.dart";
import "dart:io";


const HOST = "0.0.0.0";

void main() {
  
  // Heroku will set the PORT value
  var port = int.parse(Platform.environment['PORT']);
  
  // Server needs to listen on 0.0.0.0:PORT
  new StreamServer().start(address:HOST, port:port);
}
