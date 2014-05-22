import 'dart:async';
import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:unittest/unittest.dart';
import "package:gps_trace/gps_trace.dart";
import '../lib/models.dart' ;
import '../lib/persistence.dart' ;

//const String mongoUrl = "mongodb://127.0.0.1/test-traces-persitence" ;
const String mongoUrl = "mongodb://la-boussole-app:FD0LzbFp6t7KJ75@ds049558.mongolab.com:49558/heroku_app18544190";
main() {
  
  TraceAnalyser traceAnalyser = new TraceAnalyser();
  
  test('Persistence tests', () {

    Db db = new Db(mongoUrl);
    DbCollection trailCollection;
    DbCollection userCollection;
    PersistenceLayer persitence = new MongoPersistence(mongoUrl);
    
    return db.open()
       
        
        .then((_){
          return persitence.open();    
        })
        

        .then((_){

          return persitence.getTraces(limit: 100000).then((traces) {
            if ( traces.isNotEmpty  ){
              
              return Future.forEach(traces, (trace){
                
                return persitence.getTraceByKey(trace.key).then( (traceWithPoints) {
                  print( "Compute analysis for " + traceWithPoints.key ) ; 
                  TraceRawData rawData=  new TraceRawData.fromPoints( traceWithPoints.points );
                  TraceAnalysis newTrace = new TraceAnalysis.fromRawData(rawData);
                  trace.up = newTrace.up ;
                  trace.difficulty = newTrace.difficulty ;
                  trace.inclinationUp = newTrace.inclinationUp ;  
                  print( "Saving analysis for " + trace.key + " with difficulty ${newTrace.difficulty} " ) ; 
                  return persitence.saveOrUpdateTrace(trace);                  
                } );
              });
            }
          });

          
          
        }) 
        
        
        .whenComplete((){
          print("close db");
          db.close();
          persitence.close();
        });
    
    
  });
  
 
  
}

