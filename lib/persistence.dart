

import 'dart:async';
import '../packages/mongo_dart/mongo_dart.dart';
import '../lib/models.dart';

abstract class PersistenceLayer{
  
  Future<Db> open();

  void close();
  
  Future<List<Trail>>  getTrailsByCreator(String creator) ;

  Future<Trail>  getTrailById(String id) ;

  Future<Trail> saveOrUpdateTrail(Trail trail) ;
  
  Future<List<User>> getUsers();

  Future<User> getUserByLogin(String login);
  
  Future<User> getUserByCredential(String login, String password);
  
  Future<User> getUserById(String id);
  
  Future<User> saveOrUpdateUser(User user);
}


class MongoPersistence implements PersistenceLayer{
  
  Db _mongodb;
  DbCollection _trailCollection;
  DbCollection _userCollection;
  
  MongoPersistence(mongoUrl){
    _mongodb = new Db(mongoUrl);
    _trailCollection = _mongodb.collection('trails');
    _userCollection = _mongodb.collection('users');
  }

  Future open(){
    if (!_mongodb.connection.connected){
      print("# Open db connection");
      return _mongodb.open();
    }else{
      return  new Future.value(_mongodb.connection);
    }
  }

  void close(){
    return _mongodb.close();
  }
  
  Future<List<Trail>> getTrailsByCreator(String creator) {
    
    List<Trail> trails = new List();
    
    return _trailCollection.find(where.eq("creator", creator)).forEach((jsonTrail){
                Trail trail = new Trail.fromJson(jsonTrail);
                trails.add(trail);
              })
             .then((_) {
                  return trails;
              });
  }

  Future<Trail> getTrailById(String id) {
    return _trailCollection.findOne(where.eq("_id", id))
          .then((jsonTrail) {
            return new Trail.fromJson(jsonTrail);
          });
  }
  
  Future<Trail> saveOrUpdateTrail(Trail trail) {
    
      if(trail.id == null){
              trail.id = new ObjectId().toString();
              return _trailCollection.insert(trail.toJson()).then((_){
                  return trail;
              });
      }else{
              return _trailCollection.update(where.eq("_id", trail.id),   trail.toJson())
                        .then((_) {
                            return trail;
                          });
      }
  }
  
  Future<List<User>> getUsers() {
    
    List<User> users = new List();
    
    return _userCollection.find().forEach((jsonUser){
                User user = new User.fromJson(jsonUser);
                users.add(user);
              })
           .then((_) {
                return users;
            });
  }

  Future<User> getUserByLogin(String login){
    return _userCollection.findOne(where.eq("login", login))
              .then((jsonUser) {
                if (jsonUser == null){
                  return null ;
                }else{
                  return new User.fromJson(jsonUser);
                }
              });    
  }
  
  Future<User> getUserByCredential(String login, String password) {
    return _userCollection.findOne(where.eq("login", login)
                                            .and(where.eq("encryptedPassword", password)))
                .then((jsonUser) {
                  if (jsonUser == null){
                    return null ;
                  }else{
                    return new User.fromJson(jsonUser);
                  }
                });
  }
  
  Future<User> getUserById(String id) {
    return _userCollection.findOne(where.eq("_id", id))
          .then((jsonUser) {
            return new User.fromJson(jsonUser);
          });
  }
  
  Future<User> saveOrUpdateUser(User user) {
    
    if(user.id == null){
            user.id = new ObjectId().toString();
            return _userCollection.insert(user.toJson()).then((_){
                return user;
            });
    }else{
            return _userCollection.update(where.eq("_id", user.id),   user.toJson())
               .catchError((e) {
                      print("Unable to register ${user.toJson()}: ${e}"); 
                      return user;                         
               }).then((savedUser) {
                      return user;
              });
    }
  }
  
}
