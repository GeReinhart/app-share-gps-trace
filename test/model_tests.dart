import '../packages/unittest/unittest.dart';
import '../lib/models.dart';

main() {
  
  test('Trail JSON serialization & deserialization', () {
    Trail t = new Trail("Gex", "La classique de la Franche Verte", "franchVerte.gpx");
    Map m = t.toJson();
    Trail t2 = new Trail.fromJson(m);  
    expect(t2.creator, equals(t.creator));    
    expect(t2.title, equals(t.title));    
    expect(t2.traceFile, equals(t.traceFile));    
  });

  test('User JSON serialization & deserialization', () {
    User u = new User("Gex", "lakdsjgghkldsjag", "Gérald", "Reinhart");
    Map m = u.toJson();
    User u2 = new User.fromJson(m);  
    expect(u2.login, equals(u.login));    
    expect(u2.encryptedPassword, equals(u.encryptedPassword));    
    expect(u2.firstName, equals(u.firstName));    
    expect(u2.lastName, equals(u.lastName));    
  });

}