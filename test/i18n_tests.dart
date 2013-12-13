import 'package:unittest/unittest.dart';
import '../lib/i18n.dart';

main() {
  
  test('I18n', () {
    expect(I18n.translateForLang("fr","trek"), equals("rando")); 
    expect(I18n.translateForLang("fr","unknown"), equals("***no translation for unknown in fr***")); 
    expect(I18n.translateForLang("unknownlang","unknown"), equals("***no translation for unknown in unknownlang***")); 
  });
  
}