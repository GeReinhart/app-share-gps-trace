import "package:stream/stream.dart";


const HOST = "127.0.0.1";
const int PORT = 9090;

void main() {
  new StreamServer().start(address:HOST, port:PORT);
}

