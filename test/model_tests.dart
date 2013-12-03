import 'package:unittest/unittest.dart';
import '../lib/models.dart';

main() {
  


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