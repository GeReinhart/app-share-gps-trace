
import 'package:xml/xml.dart';
import 'dart:io';
import 'dart:async';
import 'dart:math' as Math ;


class Trace {
 
  List<TracePoint> _points = new List<TracePoint> ();
  num _length = 0;  // in meters
  num _down = 0 ; // in meters
  num _up = 0 ; // in meters

  num _distanceDown = 0 ; // in meters
  num _distanceUp = 0 ; // in meters

  
  Trace();

  Trace.fromGpxFileContent(String gpxFileContext){
    XmlElement myXmlTree = XML.parse(gpxFileContext);
    XmlCollection<XmlNode> trkptNodes = myXmlTree.queryAll("trkpt") ;
        
    TracePoint previousPoint = null;
    num traceLength = 0.0;
    for (var iter = trkptNodes.iterator; iter.moveNext();) {
      XmlNode trkptNode = iter.current;
      XmlElement trkptElement = (trkptNode as XmlElement);
      
      TracePoint currentPoint = new TracePoint();
      currentPoint.latitute =  double.parse( trkptElement.attributes["lat"] );
      currentPoint.longitude =  double.parse( trkptElement.attributes["lon"] );
      XmlCollection<XmlNode> eleNodes = trkptElement.query("ele") ;
      if (eleNodes.length > 0){
        currentPoint.elevetion = double.parse( (eleNodes[0]as XmlElement).text );
      }
      
      num currentDistance = 0;
      if (previousPoint != null){
        currentDistance = distance(previousPoint,currentPoint) ;
        
        if ( previousPoint.elevetion <   currentPoint.elevetion ){
          _up += (currentPoint.elevetion - previousPoint.elevetion ) ;
          _distanceUp += currentDistance ;
        }else{
          _down += (previousPoint.elevetion -  currentPoint.elevetion) ;
          _distanceDown += currentDistance ;
        }
        
      }
      traceLength += currentDistance;
      currentPoint.distance = traceLength ;
      previousPoint= currentPoint;
      
      _points.add(currentPoint) ;
    }
    
    this._length = traceLength.round();
    this._up = _up.round();
    this._down = _down.round();
    this._distanceUp = _distanceUp.round() ;
    this._distanceDown = _distanceDown.round() ;
  }
  
  static Future<Trace> fromGpxFile(File gpxFile){
    return gpxFile.readAsString().then((content) => new Trace.fromGpxFileContent(content));
  }

  
  /* 
  Distance http://www.movable-type.co.uk/scripts/latlong.html
 
  Distance in meters
  */
  
  static double distance(TracePoint start, TracePoint end){
    
    double R = 6371.0; 
    double dLat = ( end.latitute   - start.latitute  ) * Math.PI / 180; 
    double dLon = ( end.longitude  - start.longitude ) * Math.PI / 180;
    double lat1 = (                  start.latitute  ) * Math.PI / 180; 
    double lat2 = (                    end.latitute  ) * Math.PI / 180; 
    
    double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
    
    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
    double distance = R * c ;
    return  distance * 1000;
  }
  
  
  List<TracePoint> get points => _points;
  
  TracePoint get startPoint =>  _points.isNotEmpty ? _points.first : null ;
  
  num get length => _length ;
  
  num get down => _down ;
  
  num get up => _up ;
  
  num get distanceDown => _distanceDown ;

  num get distanceUp => _distanceUp ;

  num get inclinationDown {
    return Math.tan(_up /_distanceDown );
  }

  num get inclinationUp {
    return Math.tan(_up /_distanceUp );
  }
  
  
}


class TracePoint{
  
  double latitute;
  double longitude;
  double elevetion; // in meters
  double distance; // in meters
  
  TracePoint();
  
  TracePoint.basic(this.latitute,this.longitude);
  
  String toString(){
    return latitute.toString() +"/"+longitude.toString() + " e:"+elevetion.toString()+"m d:"+ distance.toString()+"km";
  }
  
}