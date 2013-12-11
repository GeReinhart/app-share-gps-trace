import 'model_tests.dart' as model_tests;
import 'persistence_tests.dart' as persistence_tests;
import 'trace_tests.dart' as trace_tests;
import 'i18n_tests.dart' as i18n_tests;

void main() {
  model_tests.main();
  persistence_tests.main();
  trace_tests.main();
  i18n_tests.main();
}