import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';
import 'package:unittest/unittest.dart';
import '../lib/model.dart' ;
import '../lib/persistence.dart' ;

main() {
  
  
  String mongoUrl = "mongodb://127.0.0.1/test-trailhead-persitence" ;
  
  test('Init', () {
    Db db = new Db(mongoUrl);
    DbCollection trailCollection;
    
    db.open().then((o){
      db.drop();
      trailCollection = db.collection('trails');
      trailCollection.insertAll(
          [new Trail.withId("1","Gex", "La classique de la Franche Verte", "franchVerte.gpx").toJson(),
           new Trail.withId("2","Gex","Le grand colon face Est depuis Freydieres", "colonEst.gpx").toJson(),
           new Trail.withId("3","SonicRonan","Le grand Raz", "leGrandRaz.gpx").toJson()] 
      );
      return trailCollection.find().forEach((jsonTrail){
        Trail t = new Trail.fromJson(jsonTrail);
      });
    }).then((dummy){
      db.close();
    });
  });

  test('Test get trails by creator', () {
      PersistenceLayer persitence = new MongoPersistence(mongoUrl);
      Future<List<Trail>> trailsByCreator = persitence.getTrailsByCreator("Gex");
      trailsByCreator.then((trails) {
        expect(trails.length, 2) ;    
        expect(trails.elementAt(0).title, "La classique de la Franche Verte") ;    
        expect(trails.elementAt(1).title, "Le grand colon face Est depuis Freydieres") ;    
      });
  });
  
  test('Test get trail by id', () {
      PersistenceLayer persitence = new MongoPersistence(mongoUrl);    
      String firstTrailTitle ;
      Future<List<Trail>> trailsByCreator = persitence.getTrailsByCreator("Gex");
      trailsByCreator.then((trails) {

        String firstTrailId = trails.elementAt(0).id;
        firstTrailTitle = trails.elementAt(0).title;
        return persitence.getTrailById(firstTrailId);
        
      }).then((firstTrail){
        expect(firstTrail.title, firstTrailTitle) ;    
      });
  });
  
  test('Test create trail', () {
    PersistenceLayer persitence = new MongoPersistence(mongoUrl);    
    String newTrailId;
    Trail trail = new Trail("SonicRonan","La grande Lauziere", "leGrandeLauziere.gpx");
    Future<Trail> futureSavedTrail = persitence.saveOrUpdateTrail(trail);
    futureSavedTrail.then((trail) {
      newTrailId = trail.id;
      return persitence.getTrailById(newTrailId);
    }).then((newTrail){
      expect(newTrail.title, trail.title) ;    
    });
  });

  test('Test update trail', () {
    PersistenceLayer persitence = new MongoPersistence(mongoUrl);    
    Future<Trail> trail = persitence.getTrailById("2");
    trail.then((trail) {
      trail.title ="update title" ;
      return persitence.saveOrUpdateTrail(trail);
    }).then((savedTrail){
      expect(savedTrail.title, "update title") ;    
    });
  }); 

}