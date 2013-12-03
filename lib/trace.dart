
import 'dart:io';
import 'dart:async';
import 'dart:math' as Math ;
import 'package:xml/xml.dart';

class TraceAnalysis {
 
  List<TracePoint> _points = new List<TracePoint> ();
  List<DistanceInclinationElevetion> _distancesByInclination = new List<DistanceInclinationElevetion> ();
  
  TracePoint _upperPoint ;
  TracePoint _lowerPoint ;
  
  num _distanceUp = 0 ; // in meters  > 2% inclination
  num _upRelatedToDistanceUp =0 ; // in meters 
  num _distanceFlat ; // in meters
  num _distanceDown ; // in meters < 2% inclination
  num _downRelatedToDistanceDown =0 ; // in meters 
  
  num _length = 0;  // in meters
  num _down = 0 ; // in meters
  num _up = 0 ; // in meters

  String gpxUrl ;
  
  TraceAnalysis();

  TraceAnalysis.fromPoints(List<TracePoint> points){
    _loadFromPoints( points );
  }
  
  TraceAnalysis.fromGpxFileContent(String gpxFileContent){
    _loadFromContent( gpxFileContent );
  }
  
  static Future<TraceAnalysis> fromGpxFile(File gpxFile){
    return gpxFile.readAsString().then((content) => new TraceAnalysis.fromGpxFileContent(content));
  }
  
  static Future<TraceAnalysis> fromGpxUrl(String gpxUrl){
    DateTime now = new DateTime.now();
    String tempFile = "/tmp/" +  now.millisecondsSinceEpoch.toString();
    print(tempFile) ;
    return new HttpClient().getUrl(Uri.parse(gpxUrl))
      .then((HttpClientRequest request) => request.close())
        .then((HttpClientResponse response) => response.pipe(new File(tempFile).openWrite())).then((_) {
          File gpxFile = new File(tempFile);
          return TraceAnalysis.fromGpxFile(gpxFile).then((traceAnalysis){
            traceAnalysis.gpxUrl = gpxUrl ;
            return traceAnalysis;
          });
        } ).whenComplete((){
          try {
            new File(tempFile).delete();
          } catch(e) {
            print("Unable to delete ${tempFile}: ${e}");
          }
        } );
  }  
  
  void  _loadFromContent( String gpxFileContent ){
    XmlElement myXmlTree = XML.parse(gpxFileContent);
    XmlCollection<XmlNode> trkptNodes = myXmlTree.queryAll("trkpt") ;
    List<TracePoint> points = new List<TracePoint>();
    
    for (var iter = trkptNodes.iterator; iter.moveNext();) {
      XmlNode trkptNode = iter.current;
      XmlElement trkptElement = (trkptNode as XmlElement);
      
      TracePoint currentPoint = new TracePoint();
      currentPoint.latitude =  double.parse( trkptElement.attributes["lat"] );
      currentPoint.longitude =  double.parse( trkptElement.attributes["lon"] );
      
      XmlCollection<XmlNode> eleNodes = trkptElement.query("ele") ;
      if (eleNodes.length > 0){
        currentPoint.elevetion = double.parse( (eleNodes[0]as XmlElement).text );
      }
      
      points.add(currentPoint) ;
    }
    _loadFromPoints( points  );
  }
  
  void  _loadFromPoints( List<TracePoint> points  ){
        
    TracePoint previousPoint = null;
    num traceLength = 0.0;
    _distanceUp = 0.0;
    _upRelatedToDistanceUp = 0.0;
    _distanceDown = 0.0;
    _distanceFlat = 0.0;
    _downRelatedToDistanceDown = 0.0;
    
    Map<String,DistanceInclinationElevetion> distancesByInclinationMap = new Map<String,DistanceInclinationElevetion>();
    
    for (var iter = points.iterator; iter.moveNext();) {
      
      TracePoint currentPoint = iter.current;

      
      num currentDistance = 0;
      num currentElevetionDiff = 0;
      
      if (previousPoint == null  ){
        _upperPoint = currentPoint;
        _lowerPoint = currentPoint;
      }
      else{
        currentDistance = distance(previousPoint,currentPoint) ;
        currentElevetionDiff = currentPoint.elevetion - previousPoint.elevetion ;

        if( currentPoint.elevetion > _upperPoint.elevetion ){
          _upperPoint = currentPoint;
        }
        if( currentPoint.elevetion < _lowerPoint.elevetion ){
          _lowerPoint = currentPoint;
        }
        
        if ( previousPoint.elevetion <   currentPoint.elevetion ){
          _up += currentElevetionDiff ;
        }else{
          _down -= currentElevetionDiff ;
        }

        if ( currentDistance > 0  ){
          int  inclination =   (Math.tan(  currentElevetionDiff/currentDistance ) * 100).round() ;
          
          if( inclination > 2 ){
            _distanceUp += currentDistance ;
            _upRelatedToDistanceUp += currentElevetionDiff;
          }else if (inclination < -2 ){
            _distanceDown += currentDistance ;
            _downRelatedToDistanceDown -= currentElevetionDiff ;
          }else{
            _distanceFlat += currentDistance ;
          }
          
          
          if (  !distancesByInclinationMap.containsKey(inclination.toString()) ){
            distancesByInclinationMap[inclination.toString()] =  new DistanceInclinationElevetion(inclination.toDouble(),currentDistance,currentPoint.elevetion);
          }else{
            distancesByInclinationMap[inclination.toString()].incDistance(currentDistance) ; 
          }
        }
      }
      
      
      traceLength += currentDistance;
      currentPoint.distance = traceLength ;
      previousPoint= currentPoint;
      
      _points.add(currentPoint) ;
    }

    for (int i = -100; i <= 100; i++) {
      if (distancesByInclinationMap.containsKey(i.toString())){
        _distancesByInclination.add(distancesByInclinationMap[i.toString()]);
      }
    }
    
    this._length = traceLength.round();
    this._up = _up.round();
    this._down = _down.round();
  }
  
  /* 
  Distance http://www.movable-type.co.uk/scripts/latlong.html
 
  Distance in meters
  */
  static double distance(TracePoint start, TracePoint end){
    
    double R = 6371.0; 
    double dLat = ( end.latitude   - start.latitude  ) * Math.PI / 180; 
    double dLon = ( end.longitude  - start.longitude ) * Math.PI / 180;
    double lat1 = (                  start.latitude  ) * Math.PI / 180; 
    double lat2 = (                    end.latitude  ) * Math.PI / 180; 
    
    double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2); 
    
    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
    double distance = R * c ;
    return  distance * 1000;
  }
  
  
  List<TracePoint> get points => _points;

  void addPoint(TracePoint point) => _points.add(point) ;
  
  TracePoint get upperPoint => _upperPoint;

  TracePoint get lowerPoint => _lowerPoint;
  
  List<DistanceInclinationElevetion>  get inclinations => _distancesByInclination;
  
  TracePoint get startPoint =>  _points.isNotEmpty ? _points.first : null ;
  
  num get length => _length ;
  
  num get down => _down ;
  
  num get up => _up ;

  num get distanceUp =>   _distanceUp.round() ;
  
  num get distanceFlat => _distanceFlat.round() ;
  
  num get distanceDown => _distanceDown.round() ;
  
  num get inclinationUp { 
    if(_distanceUp == 0){
      return 0;
    }
    return (Math.tan(  _upRelatedToDistanceUp/_distanceUp ) * 100).round() ;
  }
  
  num get inclinationDown {
    if(_distanceDown == 0){
      return 0;
    }    
   return (Math.tan(  _downRelatedToDistanceDown/_distanceDown ) * 100).round() ; 
  }
  
  DistanceInclinationElevetion get maxInclinationUp { 
    return _distancesByInclination.last ;
  }
  
  
  static const double FLAT_INCLINATION_WEIGHT = 1/1000 ;
  static const double DOWN_INCLINATION_WEIGHT = 1/1000 / 5 * 1 ; 
  static const double UP_INCLINATION_WEIGHT   = 1/1000 / 5 * 3 ;
  
  int get difficulty {
    double currentDifficulty = 0.toDouble();
    for (DistanceInclinationElevetion di in _distancesByInclination) {
      
      double loopDifficulty = 0.toDouble();
      if ( di.inclination >=  -2 &&  di.inclination <=  2 ){
        loopDifficulty = di.distance * FLAT_INCLINATION_WEIGHT ;
      }else if ( di.inclination < 0 ){
        loopDifficulty = (di.distance * FLAT_INCLINATION_WEIGHT) +  ( di.distance *  (-di.inclination) * DOWN_INCLINATION_WEIGHT ) ;
      }else{
        loopDifficulty = (di.distance * FLAT_INCLINATION_WEIGHT) +  ( di.distance *  di.inclination * UP_INCLINATION_WEIGHT ) ;
      }
      
      double elevetionFactor = 1.0 ;
      if (di.elevetion > 1000){
        elevetionFactor = di.elevetion / 1000 ; 
      }
      currentDifficulty += (loopDifficulty * elevetionFactor) ;
    }
    return currentDifficulty.round() ;
  }
 
}


class TracePoint{
  
  double latitude;
  double longitude;
  double elevetion; // in meters
  double distance; // in meters
  
  TracePoint();
  
  TracePoint.basic(this.latitude,this.longitude);
  
  String toString(){
    return latitude.toString() +"/"+longitude.toString() + " e:"+elevetion.toString()+"m d:"+ distance.toString()+"km";
  }
  
}

class DistanceInclinationElevetion{
  
  double _inclination; // in %
  double _distance; // in meters
  double _elevetion; 
  
  DistanceInclinationElevetion(this._inclination,this._distance,this._elevetion);
  
  void incDistance(currentDistance) {
    _distance+= currentDistance ;
  }
  
  int get inclination => _inclination.round() ;
  int get distance => _distance.round() ;
  int get elevetion => _elevetion.round() ;
 
  String toString(){
    return inclination.toString() +"% on "+distance.toString() + "m";
  }
 
  
}