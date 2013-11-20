import 'dart:async';
import '../packages/mongo_dart/mongo_dart.dart';
import '../packages/unittest/unittest.dart';
import '../lib/models.dart' ;
import '../lib/persistence.dart' ;

const String mongoUrl = "mongodb://127.0.0.1/test-trails-persitence" ;

main() {
  
  test('Persistence tests', () {

    Db db = new Db(mongoUrl);
    DbCollection trailCollection;
    DbCollection userCollection;
    PersistenceLayer persitence = new MongoPersistence(mongoUrl);
    
    return db.open()
        
        .then((_){
          print("drop db");
          return db.drop();
        })
        
        .then((_){

          print("add trails");
          trailCollection = db.collection('trails');
          return trailCollection.insertAll(
              [new Trail.withId("1","Gex", "La classique de la Franche Verte", "franchVerte.gpx").toJson(),
               new Trail.withId("2","Gex","Le grand colon face Est depuis Freydieres", "colonEst.gpx").toJson(),
               new Trail.withId("3","SonicRonan","Le grand Raz", "leGrandRaz.gpx").toJson()] );    

        })
          
        .then((_){

          print("add users");
          userCollection = db.collection('users');
          return userCollection.insertAll(
              [new User.withId("1","Gex", "lakdsjgghkldsjag", "Gérald", "Reinhart").toJson(),
               new User.withId("2","SonicRonan", "lakddsgsdkldsjag", "Ronan", "Gueguen").toJson()] 
          );    
          
        })
            
        
        .then((_){
          return persitence.open();    
        })
        
        .then((_){
          
          return persitence.getTrailsByCreator("Gex").then((trails) {
            print("Test get trails by creator");
            expect(trails.length, 2) ;    
            expect(trails.elementAt(0).title, "La classique de la Franche Verte") ;    
            expect(trails.elementAt(1).title, "Le grand colon face Est depuis Freydieres") ;    
          });
          
          
        }) 

        .then((_){
          
          String firstTrailTitle ;
          return persitence.getTrailsByCreator("Gex").then((trails) {

            String firstTrailId = trails.elementAt(0).id;
            firstTrailTitle = trails.elementAt(0).title;
            return persitence.getTrailById(firstTrailId);
            
          }).then((firstTrail){
            print("Test get trail by id");
            expect(firstTrail.title, firstTrailTitle ) ;    
          });
          
          
        })         
        
        .then((_){
          
          String newTrailId;
          Trail trail = new Trail("SonicRonan","La grande Lauziere", "leGrandeLauziere.gpx");
          return persitence.saveOrUpdateTrail(trail).then((trail) {
            newTrailId = trail.id;
            return persitence.getTrailById(newTrailId);
          }).then((newTrail){
            print("Test create trail");
            expect(newTrail.title, trail.title) ;    
          });
          
          
        })
        
        .then((_){
          
          return persitence.getTrailById("2").then((trail) {
            trail.title ="update title" ;
            return persitence.saveOrUpdateTrail(trail);
          }).then((savedTrail){
            print("Test update trail");
            expect(savedTrail.title, "update title") ;    
          });
          
          
        })        
        
        .then((_){
          
          return persitence.getUsers().then((users) {
            print("Test get users");
            expect(users.length, 2) ;    
            expect(users.elementAt(0).login, "Gex") ;    
            expect(users.elementAt(1).login, "SonicRonan") ;    
          });
          
          
        })          
        
        .then((_){
          
          String newUserId;
          User u = new User("Man", "lakdssdgdgjgghkldsjag", "Manuel", "Collet-Beillon");
          return persitence.saveOrUpdateUser(u).then((user) {
            newUserId = user.id;
            return persitence.getUserById(newUserId);
          }).then((newUser){
            print("Test create user");
            expect(newUser.login, newUser.login) ;    
          });
          
          
        })
        
        .then((_){
          
          return persitence.getUserByLogin("Man").then((user) {
            print("Test get by login");
            expect(user.login, "Man") ;   
          });
          
          
        })         
        
        .then((_){
          
          return persitence.getUserByLogin("Manu").then((user) {
            print("Test get by login no user");
            expect(user, null) ;   
          });
          
          
        })         
        
        
        
        .then((_){
          
          return persitence.getUserByCredential("Man", "lakdssdgdgjgghkldsjag").then((user) {
            print("Test get by Credential");
            expect(user.login, "Man") ;   
          });
          
          
        })         
        
        .then((_){
          
          return persitence.getUserByCredential("Man", "lakdssd").then((user) {
            print("Test get by Credential no user");
            expect(user, null) ;   
          });
          
          
        })         
        
        .whenComplete((){
          print("close db");
          db.close();
          persitence.close();
        });
    
    
  });
  
 
  
}

