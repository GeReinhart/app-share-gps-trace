import 'dart:io' show Options;
import 'package:stream/rspc.dart' show build;

void main() {
  build(new Options().arguments);
}