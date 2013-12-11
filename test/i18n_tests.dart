import 'package:unittest/unittest.dart';
import '../lib/i18n.dart';

main() {
  
  test('I18n', () {
    expect(I18n.translate("fr","trek"), equals("rando")); 
    expect(I18n.translate("fr","unknown"), equals("***no translation for unknown in fr***")); 
    expect(I18n.translate("unknownlang","unknown"), equals("***no translation for unknown in unknownlang***")); 
  });
  
}