import 'package:unittest/unittest.dart';
import '../lib/model.dart';

main() {
  
  test('Trail JSON serialization & deserialization', () {
    Trail t = new Trail("Gex", "La classique de la Franche Verte", "franchVerte.gpx");
    Map m = t.toJson();
    Trail t2 = new Trail.fromJson(m);  
    expect(t2.creator, equals(t.creator));    
    expect(t2.title, equals(t.title));    
    expect(t2.traceFile, equals(t.traceFile));    
  });
}