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

  Future<TraceAnalysis> buildTraceAnalysisFromGpxFile(File gpxFile,{bool applyPurge: false,
    int idealMaxPointNumber:3500, 
    SmoothingParameters smoothingParameters:null}){
    return gpxFile.readAsString().then((gpxFileContent) {
      return traceAnalyser.buildTraceAnalysisFromGpxFileContent(gpxFileContent,applyPurge: applyPurge,
           idealMaxPointNumber:idealMaxPointNumber, 
           smoothingParameters:smoothingParameters);
    });
  }
  
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
          return buildTraceAnalysisFromGpxFile(file).then((traceAnalysis){
            
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
          
          File file = new File("test/resources/12590.gpx");
          return buildTraceAnalysisFromGpxFile(file).then((traceAnalysis){
            
            Trace trace = new Trace.fromTraceAnalysis("Gex", traceAnalysis); 
            trace.title = "Tour du Vercors - Autrans - Saint Nizier du Moucherotte";
            traceKey = trace.buildKey() ;
            
            bool exceptionThrown = false ;
            
            return persitence.saveOrUpdateTrace(trace).then((trace) {
                  return new Future.value();   
                }).catchError((e){
                    exceptionThrown = true;
                }).then((_){
                  print("Test cannot save twice the same trace");
                  expect(exceptionThrown, true) ;  
                  return new Future.value();   
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
          WatchPoint wp1 = new WatchPoint("Gex","water name", "water desc", "water", 12.89, 34.98);
          WatchPoint wp2 = new WatchPoint("Gex","water name2", "water desc2", "water", 77.89, 89.98);
          wp1.traceKey = traceKey;
          return persitence.saveOrUpdateWatchPoint(wp1).then((_) {
            return persitence.saveOrUpdateWatchPoint(wp2).then((_) {
              return persitence.getWatchPointByTraceKey(traceKey).then((wps) {
                print("Test get WatchPoint ");
                expect(wps.length, 1) ;
                expect(wps[0].description,  "water desc") ;
              });
            });  
          });
        })         
        
       .then((_){
          return persitence.getWatchPointByTraceKeyAndPosition(traceKey, 12.89, 34.98).then((wp){
            print("Test get WatchPoint by position ");
            expect(wp.name, "water name") ;      
          });
       })
       .then((_){
          WatchPoint wp1 = new WatchPoint("Gex","water name update", "water desc", "water", 12.89, 34.98);
          wp1.traceKey = traceKey;         
          return persitence.saveOrUpdateWatchPoint(wp1).then((wp){
            return persitence.getWatchPointByTraceKeyAndPosition(traceKey, 12.89, 34.98).then((wp){
              print("Test update WatchPoint");
              expect(wp.name, "water name update") ;      
            });      
          });
       })        
       .then((_){
          return persitence.deleteWatchPoint(traceKey, 12.89, 34.98).then((wp){
            return persitence.getWatchPointByTraceKeyAndPosition(traceKey, 12.89, 34.98).then((_){
              print("Test delete WatchPoint");
              expect(wp, null) ;      
            });      
          });
       })         
       
       
       .then((_){
          Comment comment1 = new Comment("Gex",traceKey, CommentTargetType.TRACE, "comment 1") ;
          Comment comment2 = new Comment("Gex",traceKey, CommentTargetType.TRACE, "comment 2") ;
          return persitence.saveOrUpdateComment(comment1).then((_) {
            
            comment1.content = "comment 1 updated" ;
            return persitence.saveOrUpdateComment(comment1).then((_) {
             return persitence.saveOrUpdateComment(comment2).then((_) {
              return persitence.getCommentByTraceKey(traceKey).then((comments) {
                print("Test save and  get Comment ");
                expect(comments.length, 2) ;
                expect(comments[0].content,  "comment 2") ;
                expect(comments[1].content,  "comment 1 updated") ;
                
                return persitence.deleteCommentById(comment1.id).then((_){
                  return persitence.getCommentByTraceKey(traceKey).then((comments) {
                    print("Test delete comment ");
                    expect(comments.length, 1) ;       
                    expect(comments[0].content,  "comment 2") ;
                  });
                });
                
              });
             });    
            });  
          });
        }) 
       
       
       .then((_){
          return persitence.deleteTraceByKey(traceKey).then((_) {
            return persitence.getTraceByKey(traceKey).then((loadedTrace) {
              print("Test delete trace");
              expect(loadedTrace, null) ;   
              
              return persitence.getCommentByTraceKey(traceKey).then((comments) {
                expect(comments.length, 0) ;
              });
              
              
              
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

