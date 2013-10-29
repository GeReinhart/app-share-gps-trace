import 'package:unittest/unittest.dart';
import 'dart:io';
import '../lib/trace.dart';

main() {
  
 test('Load gpx file', () {
    File file = new File("test/resources/12590.gpx");
    Trace.fromGpxFile(file).then((trace){
      expect(trace.points.length, equals(158));
      expect(trace.points[0].latitute, equals(45.140394900));    
      expect(trace.points[0].longitude, equals(5.719580050));    
      expect(trace.points[0].elevetion, equals(238));
      expect(trace.points[0].distance, equals(0));  
      expect(trace.points[157].latitute, equals(45.190577800));    
      expect(trace.points[157].longitude, equals(5.726594030));    
      expect(trace.points[157].elevetion, equals(209));     
      expect(trace.points[157].distance, equals(8224.307927187921));
      expect(trace.startPoint.latitute, equals(45.140394900));    
      expect(trace.startPoint.longitude, equals(5.719580050));    
      expect(trace.startPoint.elevetion, equals(238));
      
      expect(trace.length, equals(8224));
      expect( (trace.inclinationUp * 100).round()  , equals(1));
      expect( (trace.inclinationDown * 100).round()  , equals(0)); 
    });
    
    file = new File("test/resources/16231.gpx");
    Trace.fromGpxFile(file).then((trace){
      expect(trace.length, equals(35855));   
      expect(trace.up, equals(1316));
      expect(trace.down, equals(1316));
      expect(trace.distanceUp, equals(18104));
      expect(trace.distanceDown, equals(17751));
      expect( (trace.inclinationUp * 100).round()  , equals(7));
      expect( (trace.inclinationDown * 100).round()  , equals(7));      
    });

    file = new File("test/resources/12645.gpx");
    Trace.fromGpxFile(file).then((trace){
      expect(trace.length, equals(21966));   
      expect(trace.up, equals(1031));
      expect(trace.down, equals(1591));
      expect(trace.distanceUp, equals(8723));
      expect(trace.distanceDown, equals(13242));
      expect( (trace.inclinationUp * 100).round()  , equals(12));
      expect( (trace.inclinationDown * 100).round()  , equals(8));      
    });
    
    
  });
 
 
  test('Calculate distance between 2 points', () {
    TracePoint start =new TracePoint.basic(45.140394900,5.719580050);
    TracePoint end =new TracePoint.basic(45.190577800,5.726594030);
    double distance = Trace.distance(start, end) ;
    expect(distance.round(), equals(5607));
  });
 
}

