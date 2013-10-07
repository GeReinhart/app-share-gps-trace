import 'package:unittest/unittest.dart';
import 'model_tests.dart' as model_tests;
import 'persistence_tests.dart' as persistence_tests;

void main() {
  model_tests.main();
  persistence_tests.main();
}