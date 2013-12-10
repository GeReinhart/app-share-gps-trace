import 'dart:async';
import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:unittest/unittest.dart';
import '../lib/models.dart' ;
import '../lib/persistence.dart' ;
import '../lib/trace.dart';

const String mongoUrl = "mongodb://127.0.0.1/test-traces-persitence" ;

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

        .then((_){
          
          File file = new File("test/resources/12590.gpx");
          return TraceAnalysis.fromGpxFile(file).then((traceAnalysis){
            
            TracePoint firstPoint = traceAnalysis.points[0] ; 
            Trace trace = new Trace.fromTraceAnalysis("Gex", traceAnalysis); 
            trace.title = "Tour du Vercors - Autrans - Saint Nizier du Moucherotte";
            trace.description = "ma description" ;
            trace.activities = ["trek","bike"] ;
            String builtKey = trace.buildKey() ;
            
            return persitence.saveOrUpdateTrace(trace).then((trace) {
                return persitence.getTraceById(trace.id).then((loadedTrace) {
                  print("Test save and get a trace");
                  expect(loadedTrace.description, trace.description) ;   
                  expect(loadedTrace.traceAnalysis.points[0].toString(), firstPoint.toString()) ; 
                  expect(loadedTrace.upperPointElevetion, traceAnalysis.upperPoint.elevetion) ;
                  expect(loadedTrace.key, builtKey) ; 
                  expect(loadedTrace.activities[0], "trek") ;
                  
                  return persitence.getTraceByKey(builtKey).then((loadedTrace) {
                    expect(loadedTrace.description, trace.description) ;   
                  });
                  
                });  
            
            }); 
          });
          
        })

        .then((_){
          return persitence.getTracesByActivity("trek").then((traces) {
            print("Test get by traces by activity");
            expect(traces.length, 1) ;   
            expect(traces[0].description, "ma description" ) ;
          });
        }) 

        .then((_){
          return persitence.getTracesByActivity("unknown").then((traces) {
            print("Test get by traces by activity no result");
            expect(traces.length, 0) ;   
          });
        })        
        
        
        .whenComplete((){
          print("close db");
          db.close();
          persitence.close();
        });
    
    
  });
  
 
  
}

