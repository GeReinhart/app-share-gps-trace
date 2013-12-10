

import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import '../lib/models.dart';

abstract class PersistenceLayer{
  
  Future<Db> open();

  void close();

  Future<List<Trace>>  getTraces() ;
  
  Future<List<Trace>>  getTracesByCreator(String creator) ;

  Future<List<Trace>>  getTracesByActivity(String activity) ;

  Future<Trace>  getTraceById(String id) ;
  
  Future<Trace>  getTraceByKey(String key) ;
  
  Future<Trace> saveOrUpdateTrace(Trace trace) ;
  
  Future<List<User>> getUsers();

  Future<User> getUserByLogin(String login);
  
  Future<User> getUserByCredential(String login, String password);
  
  Future<User> getUserById(String id);
  
  Future<User> saveOrUpdateUser(User user);
}


class MongoPersistence implements PersistenceLayer{
  
  Db _mongodb;
  DbCollection _userCollection;
  DbCollection _traceCollection;
  DbCollection _traceDataCollection;
  
  MongoPersistence(mongoUrl){
    _mongodb = new Db(mongoUrl);
    _userCollection = _mongodb.collection('users');
    _traceCollection = _mongodb.collection('traces');
    _traceDataCollection = _mongodb.collection('traceDatas');
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
  
  Future<List<Trace>> getTraces() {
    
    List<Trace> traces = new List();
    
    return _traceCollection.find(where.sortBy('_id', descending: true)).forEach((jsonTrace){
                Trace trace = new Trace.fromJson(jsonTrace);
                traces.add(trace);
              })
             .then((_) {
                  return traces;
              });
  }
  
  Future<List<Trace>> getTracesByCreator(String creator) {
    
    List<Trace> traces = new List();
    
    return _traceCollection.find(where.eq("creator", creator)).forEach((jsonTrace){
                Trace trace = new Trace.fromJson(jsonTrace);
                traces.add(trace);
              })
             .then((_) {
                  return traces;
              });
  }
  
  Future<List<Trace>>  getTracesByActivity(String activity) {
    
    List<Trace> traces = new List();
    
    return _traceCollection.find(where.eq("activities", activity)).forEach((jsonTrace){
                Trace trace = new Trace.fromJson(jsonTrace);
                traces.add(trace);
              })
             .then((_) {
                  return traces;
              });
  }

  Future<Trace> getTraceById(String id) {
    return _traceCollection.findOne(where.eq("_id", id))
          .then((jsonTrace) {
            Trace trace = new Trace.fromJson(jsonTrace);
            return _traceDataCollection.findOne(where.eq("_id", trace.traceDataId))
              .then((jsonTraceData){
                trace.traceData = new TraceData.fromJson(jsonTraceData);
                return trace;
              });
          });
  }
  
  Future<Trace> getTraceByKey(String key) {
    return _traceCollection.findOne(where.eq("key", key))
          .then((jsonTrace) {
            if (jsonTrace == null){
              return null;
            }
            Trace trace = new Trace.fromJson(jsonTrace);
            return _traceDataCollection.findOne(where.eq("_id", trace.traceDataId))
              .then((jsonTraceData){
                trace.traceData = new TraceData.fromJson(jsonTraceData);
                return trace;
              });
          });
  }
  
  Future<Trace> saveOrUpdateTrace(Trace trace) {
    
      if(trace.id == null){
              trace.id = new ObjectId().toString();
              trace.traceDataId = new ObjectId().toString();
              trace.key =  trace.buildKey();
              return _traceCollection.insert(trace.toJson()).then((_){
                return _traceDataCollection.insert(trace.traceData.toJson()).then((_){
                  return trace;
                });
              });
      }else{
              return _traceCollection.update(where.eq("_id", trace.id),   trace.toJson())
                        .then((_) {
                            return trace;
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
