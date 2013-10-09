
import 'package:mongo_dart/mongo_dart.dart';
import '../lib/model.dart';
import 'dart:async';

abstract class PersistenceLayer{
  
  Future<List<Trail>>  getTrailsByCreator(String creator) ;

  Future<Trail>  getTrailById(String id) ;

  Future<Trail> saveOrUpdateTrail(Trail trail) ;
  
  Future<List<User>> getUsers();
  
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

  Future<List<Trail>> getTrailsByCreator(String creator) {
    
    List<Trail> trails = new List();
    
    return _mongodb.open()
          .then((_){
              return _trailCollection.find(where.eq("creator", creator)).forEach((jsonTrail){
                Trail trail = new Trail.fromJson(jsonTrail);
                trails.add(trail);
              });
          })
         .then((_) {
              return trails;
          })
          .whenComplete((){
              _mongodb.close();
          });
  }

  Future<Trail> getTrailById(String id) {
    return _mongodb.open()
          .then((_){
            return _trailCollection.findOne(where.eq("_id", id));
          })
          .then((jsonTrail) {
            return new Trail.fromJson(jsonTrail);
          })
          .whenComplete((){
            _mongodb.close();
          });
  }
  
  Future<Trail> saveOrUpdateTrail(Trail trail) {
    
    return _mongodb.open()
          .then((_){

            if(trail.id == null){
              trail.id = new ObjectId().toString();
              return _trailCollection.insert(trail.toJson()) ;
            }else{
              return _trailCollection.update(where.eq("_id", trail.id),   trail.toJson());
            }
              
          })
         .then((savedTrail) {
              return trail;
          })
          .whenComplete((){
              _mongodb.close();
          });
  }
  
  Future<List<User>> getUsers() {
    
    List<User> users = new List();
    
    return _mongodb.open()
          .then((_){
              return _userCollection.find().forEach((jsonUser){
                User user = new User.fromJson(jsonUser);
                users.add(user);
              });
          })
         .then((_) {
              return users;
          })
          .whenComplete((){
              _mongodb.close();
          });
  }

  Future<User> getUserById(String id) {
    return _mongodb.open()
          .then((_){
            return _userCollection.findOne(where.eq("_id", id));
          })
          .then((jsonUser) {
            return new User.fromJson(jsonUser);
          })
          .whenComplete((){
            _mongodb.close();
          });
  }
  
  Future<User> saveOrUpdateUser(User user) {
    
    return _mongodb.open()
        .then((_){

          if(user.id == null){
            user.id = new ObjectId().toString();
            return _userCollection.insert(user.toJson()) ;
          }else{
            return _userCollection.update(where.eq("_id", user.id),   user.toJson());
          }
          
        })
          .then((savedUser) {
            return user;
          })
          .whenComplete((){
              _mongodb.close();
          });
  }
  
}
