import 'dart:io';
import 'package:unittest/unittest.dart';
import '../lib/trace.dart';

main() {
  
 test('Load gpx file', () {
    File file = new File("test/resources/12590.gpx");
    TraceAnalysis.fromGpxFile(file).then((trace){
      expect(trace.points.length, equals(158));
      expect(trace.points[0].latitude, equals(45.140394900));    
      expect(trace.points[0].longitude, equals(5.719580050));    
      expect(trace.points[0].elevetion, equals(238));
      expect(trace.points[0].distance, equals(0));  
      expect(trace.points[157].latitude, equals(45.190577800));    
      expect(trace.points[157].longitude, equals(5.726594030));    
      expect(trace.points[157].elevetion, equals(209));     
      expect(trace.points[157].distance, equals(8224.307927187921));
      expect(trace.startPoint.latitude, equals(45.140394900));    
      expect(trace.startPoint.longitude, equals(5.719580050));    
      expect(trace.startPoint.elevetion, equals(238));
      
      expect( trace.inclinations.length, equals(6)   );
      expect( trace.inclinations[0].toString(), equals("-3% on 49m")   );
      expect( trace.inclinations[1].toString(), equals("-2% on 696m")   );
      expect( trace.inclinations[2].toString(), equals("-1% on 2013m")   );
      expect( trace.inclinations[3].toString(), equals("0% on 5019m")   );
      expect( trace.inclinations[4].toString(), equals("1% on 329m")   );
      expect( trace.inclinations[5].toString(), equals("2% on 118m")   );

      expect(trace.difficulty, equals(8));
      expect(trace.length, equals(8224));
      expect(trace.down, equals(35));
      expect(trace.distanceUp, equals(0));
      expect(trace.distanceFlat, equals(8176));
      expect(trace.distanceDown, equals(49));
      expect(trace.inclinationUp, equals(0));
      expect(trace.inclinationDown, equals(3));
    });
    
    file = new File("test/resources/12590_with_errors.gpx");
    TraceAnalysis.fromGpxFile(file).then((trace){
      expect(trace.length, equals(8224));   
      expect(trace.up, equals(6));
      expect(trace.down, equals(35));
    });
    
    file = new File("test/resources/16231.gpx");
    TraceAnalysis.fromGpxFile(file).then((trace){
      expect(trace.length, equals(35855));   
      expect(trace.up, equals(1316));
      expect(trace.down, equals(1316));
    });

    file = new File("test/resources/12645.gpx");
    TraceAnalysis.fromGpxFile(file).then((trace){
      expect(trace.length, equals(21966));   
      expect(trace.up, equals(1031));
      expect(trace.down, equals(1591));
    });
  });
 
 
  test('Calculate distance between 2 points', () {
    TracePoint start =new TracePoint.basic(45.140394900,5.719580050);
    TracePoint end =new TracePoint.basic(45.190577800,5.726594030);
    double distance = TraceAnalysis.distance(start, end) ;
    expect(distance.round(), equals(5607));
  });
  
  
  
}
