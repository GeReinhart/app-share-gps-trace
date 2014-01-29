import 'dart:async';
import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:unittest/unittest.dart';
import "package:gps_trace/gps_trace.dart";
import '../lib/models.dart' ;
import '../lib/persistence.dart' ;

const String mongoUrl = "mongodb://127.0.0.1/test-traces-persitence" ;

main() {
  
  TraceAnalyser traceAnalyser = new TraceAnalyser();

  
  test('Persistence tests', () {

    Db db = new Db(mongoUrl);
    DbCollection trailCollection;
    DbCollection userCollection;
    PersistenceLayer persitence = new MongoPersistence(mongoUrl);
    
    String traceKey ;
    
    return db.open()
        
        .then((_){
          print("drop db");
          return db.drop();
        })
        
         
        .then((_){

          print("add users");
          userCollection = db.collection('users');
          User admin = new User.withId("3","la-boussole", "", "", "");
          admin.admin=true;
          return userCollection.insertAll(
              [new User.withId("1","Gex", "lakdsjgghkldsjag", "Gérald", "Reinhart").toJson(),
               new User.withId("2","SonicRonan", "lakddsgsdkldsjag", "Ronan", "Gueguen").toJson(),
               admin.toJson()] 
          );    
          
        })
            
        
        .then((_){
          return persitence.open();    
        })
        


        
        .then((_){
          
          return persitence.getUsers().then((users) {
            print("Test get users");
            expect(users.length, 3) ;    
            expect(users.elementAt(0).login, "Gex") ;
            expect(users.elementAt(0).admin, false) ;
            expect(users.elementAt(1).login, "SonicRonan") ;
            expect(users.elementAt(2).login, "la-boussole") ;
            expect(users.elementAt(2).admin, true) ;
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
          return traceAnalyser.buildTraceAnalysisFromGpxFile(file).then((traceAnalysis){
            
            TracePoint firstPoint = traceAnalysis.points[0] ; 
            Trace trace = new Trace.fromTraceAnalysis("Gex", traceAnalysis); 
            trace.title = "Tour du Vercors - Autrans - Saint Nizier du Moucherotte";
            trace.description = "ma description" ;
            trace.activities = ["trek","bike"] ;
            
            trace.difficulty = 100 ;
            trace.inclinationUp = 10 ;
            trace.length = 10000 ;
            trace.up = 200;
            trace.startPointElevetion = 2000.0;
            trace.upperPointElevetion = 3000.0;
            
            traceKey = trace.buildKey() ;
            DateTime dateTime = new DateTime.now();
            
            return persitence.saveOrUpdateTrace(trace).then((trace) {
                return persitence.getTraceById(trace.id).then((loadedTrace) {
                  print("Test save and get a trace");
                  expect(loadedTrace.description, trace.description) ;   
                  expect(loadedTrace.traceAnalysis.points[0].toString(), firstPoint.toString()) ; 
                  expect(loadedTrace.upperPointElevetion, traceAnalysis.upperPoint.elevetion) ;
                  expect(loadedTrace.key, traceKey) ; 
                  expect(loadedTrace.activities[0], "trek") ;
                  expect(loadedTrace.creationDate.day, dateTime.day) ;
                  
                  return persitence.getTraceByKey(traceKey).then((loadedTrace) {
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
        
        .then((_){
          SearchFilters filter = new SearchFilters();
          filter.creator = "Gex" ;
          filter.activities.add("unknown") ;
          return persitence.getTracesByFilters(filter).then((traces) {
            print("Test get by traces by filter 1");
            expect(traces.length, 0) ;   
          });
        })  
        
        .then((_){
          SearchFilters filter = new SearchFilters();
          filter.creator = "Gex" ;
          filter.activities.add("trek") ;
          return persitence.getTracesByFilters(filter).then((traces) {
            print("Test get by traces by filter 2");
            expect(traces.length, 1) ;   
          });
        })          
        
        .then((_){
          SearchFilters filter = new SearchFilters();
          filter.creator = "unknown" ;
          filter.activities.add("trek") ;
          return persitence.getTracesByFilters(filter).then((traces) {
            print("Test get by traces by filter 3");
            expect(traces.length, 0) ;   
          });
        })        

        .then((_){
          SearchFilters filter = new SearchFilters();
          filter.search = "Vercors" ;
          return persitence.getTracesByFilters(filter).then((traces) {
            print("Test get by traces by filter search  on title");
            expect(traces.length, 1) ;   
          });
        })  
        
        .then((_){
          SearchFilters filter = new SearchFilters();
          filter.search = "vercors" ;
          return persitence.getTracesByFilters(filter).then((traces) {
            print("Test get by traces by filter search  on title ignore case");
            expect(traces.length, 1) ;   
          });
        })        
        
        .then((_){
          SearchFilters filter = new SearchFilters();
          filter.search = "gex" ;
          return persitence.getTracesByFilters(filter).then((traces) {
            print("Test get by traces by filter search  on creator");
            expect(traces.length, 1) ;   
          });
        })
        
        .then((_){
          SearchFilters filter = new SearchFilters();
          filter.search = "description" ;
          return persitence.getTracesByFilters(filter).then((traces) {
            print("Test get by traces by filter search  on description");
            expect(traces.length, 1) ;   
          });
        })
       
        .then((_){
          SearchFilters filter = new SearchFilters();
          filter.difficultyGt = 90 ;
          return persitence.getTracesByFilters(filter).then((traces) {
            print("Test get by traces by filter search  on difficultyGt");
            expect(traces.length, 1) ;   
          });
        })        
        
        .then((_){
          SearchFilters filter = new SearchFilters();
          filter.difficultyGt = 110 ;
          return persitence.getTracesByFilters(filter).then((traces) {
            print("Test get by traces by filter search  on difficultyGt false");
            expect(traces.length, 0) ;   
          });
        })  
        
        .then((_){
          SearchFilters filter = new SearchFilters();
          filter.difficultyLt = 90 ;
          return persitence.getTracesByFilters(filter).then((traces) {
            print("Test get by traces by filter search  on difficultyLt false");
            expect(traces.length, 0) ;   
          });
        })        
        
        .then((_){
          SearchFilters filter = new SearchFilters();
          filter.difficultyLt = 110 ;
          return persitence.getTracesByFilters(filter).then((traces) {
            print("Test get by traces by filter search  on difficultyLt");
            expect(traces.length, 1) ;   
          });
        })         
        
        .then((_){
          SearchFilters filter = new SearchFilters();
          filter.difficultyLt = 100 ;
          return persitence.getTracesByFilters(filter).then((traces) {
            print("Test get by traces by filter search  on difficultyLt equals");
            expect(traces.length, 1) ;   
          });
        }) 

        .then((_){
          return persitence.deleteTraceByKey(traceKey).then((_) {
            return persitence.getTraceByKey(traceKey).then((loadedTrace) {
              print("Test delete trace");
              expect(loadedTrace, null) ;   
            });  
          });
        }) 
        
        
        .whenComplete((){
          print("close db");
          db.close();
          persitence.close();
        });
    
    
  });
  
 
  
}

