

import "package:rikulo_security/security.dart";
import "package:stream/stream.dart";
import "dart:async";
import 'package:crypto/crypto.dart';
import "persistence.dart";

class Authentication extends Authenticator {
  
  PersistenceLayer _persistence ;
  Crypto _crypto ;
  
  Authentication(this._persistence, this._crypto);
  
  Future login(HttpConnect connect, String login, String password) {
    String encryptedPassword = _crypto.encryptPassword(password);    
    return  _persistence.getUserByCredential(login, encryptedPassword)
        .then((user){
          if (user== null){
            print("# Authentication failed for '${login}'");
            throw new AuthenticationException("Bad login or bad password");
          }else{
            print("# Authentication success for '${login}'");
            return new Future.value(user) ;
          }
        }) ;
  }
}

class Crypto{

  String encryptPassword(String password){
    
    var sha256 = new SHA256();
    sha256.add(password.codeUnits);
    var hexString = CryptoUtils.bytesToHex(sha256.close());
    
    return hexString ;
  }
  
}
