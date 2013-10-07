
import 'package:mongo_dart/mongo_dart.dart';
import '../lib/model.dart';
import 'dart:async';

abstract class PersistenceLayer{
  
  Future<List<Trail>>  getTrailsByCreator(String creator) ;

  Future<Trail>  getTrailById(String id) ;

  Future<Trail> saveOrUpdateTrail(Trail trail) ;
}


class MongoPersistence implements PersistenceLayer{
  
  Db _mongodb;
  DbCollection _trailCollection;
  
  MongoPersistence(mongoUrl){
    _mongodb = new Db(mongoUrl);
    _trailCollection = _mongodb.collection('trails');
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
}



