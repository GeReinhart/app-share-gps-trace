

import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import '../lib/models.dart';

abstract class PersistenceLayer{
  
  Future<Db> open();

  void close();

  Future<List<Trace>>  getTraces({limit:25}) ;
  
  Future<List<Trace>>  getTracesByCreator(String creator) ;

  Future<List<Trace>>  getTracesByActivity(String activity) ;

  Future<List<Trace>>  getTracesByFilters(SearchFilters filters,{limit:25}) ;
  
  Future<Trace>  getTraceById(String id) ;
  
  Future<Trace>  getTraceByKey(String key) ;
  
  Future<Trace> saveOrUpdateTrace(Trace trace) ;
  
  Future<List<User>> getUsers();

  Future<User> getUserByLogin(String login);
  
  Future<User> getUserByCredential(String login, String password);
  
  Future<User> getUserById(String id);
  
  Future<User> saveOrUpdateUser(User user);
}


class SearchFilters{
  String search;
  String creator;
  List<String> activities = new List<String>() ;
  num    lengthGt;
  num    upGt ;
  num    inclinationUpGt;
  double startPointElevetionGt;
  double upperPointElevetionGt;
  int    difficultyGt;
  num    lengthLt;
  num    upLt ;
  num    inclinationUpLt;
  double startPointElevetionLt;
  double upperPointElevetionLt;
  int    difficultyLt;
  double mapBoundNELat ;
  double mapBoundNELong ;
  double mapBoundSWLat ;
  double mapBoundSWLong ;
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
  
  Future<List<Trace>> getTraces({limit:25}) {
    
    List<Trace> traces = new List();
    
    return _traceCollection.find(where.sortBy('lastUpdateDate', descending: true).limit(limit)).forEach((jsonTrace){
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

  Future<List<Trace>>  getTracesByFilters(SearchFilters filters, {limit:25}) {
    
    List<Trace> traces = new List();
    SelectorBuilder selector = where.exists("key").sortBy('lastUpdateDate', descending: true).limit(limit) ;
    if ( filters.search != null && filters.search.isNotEmpty ){
      selector.and(
          where.match("title", filters.search, caseInsensitive: true )
      .or(where.match("creator", filters.search, caseInsensitive: true ))
      .or(where.match("description", filters.search, caseInsensitive: true ))
          );
    }
    if ( filters.creator != null && filters.creator.isNotEmpty ){
      selector.and(where.match("creator", filters.creator, caseInsensitive: true));
    }
    if ( filters.activities != null && filters.activities.isNotEmpty ){
      filters.activities.forEach((a)=>(selector.and(where.eq("activities", a))));
    }    
    if ( filters.difficultyGt != null  ){
      selector.and(where.gte("difficulty", filters.difficultyGt));
    }  
    if ( filters.difficultyLt != null  ){
      selector.and(where.lte("difficulty", filters.difficultyLt));
    }
    if ( filters.lengthGt != null  ){
      selector.and(where.gte("length", filters.lengthGt));
    }  
    if ( filters.lengthLt != null  ){
      selector.and(where.lte("length", filters.lengthLt));
    }    
    if ( filters.upGt != null  ){
      selector.and(where.gte("up", filters.upGt));
    }  
    if ( filters.upLt != null  ){
      selector.and(where.lte("up", filters.upLt));
    }
    if ( filters.inclinationUpGt != null  ){
      selector.and(where.gte("inclinationUp", filters.inclinationUpGt));
    }  
    if ( filters.inclinationUpLt != null  ){
      selector.and(where.lte("inclinationUp", filters.inclinationUpLt));
    }    
    if ( filters.startPointElevetionGt != null  ){
      selector.and(where.gte("startPointElevetion", filters.startPointElevetionGt));
    }  
    if ( filters.startPointElevetionLt != null  ){
      selector.and(where.lte("startPointElevetion", filters.startPointElevetionLt));
    }    
    if ( filters.upperPointElevetionGt != null  ){
      selector.and(where.gte("upperPointElevetion", filters.upperPointElevetionGt));
    }  
    if ( filters.upperPointElevetionLt != null  ){
      selector.and(where.lte("upperPointElevetion", filters.upperPointElevetionLt));
    }     
    
    if ( filters.mapBoundNELat != null  ){
      selector.and(where.lte("startPointLatitude", filters.mapBoundNELat));
    }  
    if ( filters.mapBoundNELong != null  ){
      selector.and(where.lte("startPointLongitude", filters.mapBoundNELong));
    }    
    if ( filters.mapBoundSWLat != null  ){
      selector.and(where.gte("startPointLatitude", filters.mapBoundSWLat));
    }  
    if ( filters.mapBoundSWLong != null  ){
      selector.and(where.gte("startPointLongitude", filters.mapBoundSWLong));
    } 
    
    
    
    return _traceCollection.find(selector).forEach((jsonTrace){
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
              trace.creation();
              return _traceCollection.insert(trace.toJson()).then((_){
                return _traceDataCollection.insert(trace.traceData.toJson()).then((_){
                  return trace;
                });
              });
      }else{
              trace.update();
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
