import "dart:html";
import "dart:svg";
import 'dart:async';
import "widget.dart" ;
import "../forms.dart";


typedef int ElevetionValue(ProfilePoint profilePoint);


class ProfileWidget extends Widget {
  
  static int SKY_HEIGHT_IN_METERS = 500 ; 
  static String COLOR_SKY = "#5B6DE3"; 
  static String COLOR_DEFAULT = "white"; 
  static const PROFILE_SELECTION_REFRESH_TIME = const Duration(milliseconds: 250);
  
  TraceDetails _traceDetails ;
  ProfilePoint _currentProfilePoint ;
  
  ProfilePoint _profilePointToBeFired ; 
  
  StreamController<ProfilePoint> _profilePointSelectionController = new StreamController<ProfilePoint>.broadcast();
  
  ProfileWidget(String id) : super(id){
    querySelector("#${id}").style.backgroundColor = COLOR_DEFAULT ;
    _mayFireProfilePointSelection();
    _listenToMouse();
  }
  
  Stream<ProfilePoint> get profilePointSelection => _profilePointSelectionController.stream;
  
  void reset(){
    querySelector("#${id}").style.backgroundColor = COLOR_DEFAULT ;
    querySelector("#${id}").children.clear();
  }
  
  void updatePosition(int top, int right, int width, int height){
     super.updatePosition(top,  right,  width,  height)  ;
     if (_traceDetails!= null){
       show(_traceDetails) ;
     }
  }
  
  void show(TraceDetails traceDetails){
    this._traceDetails = traceDetails;
    this.reset();
    
    var svgGroup = new SvgElement.tag("g");
    
    int lowestElevetion      = _getLowestPoint();
    int heighestElevetion    = _getHeighestPoint();
    int skyElevetionInMeters = _getSkyElevetion() ;

    svgGroup.nodes.add(_buildProfileFragment( (p)=> skyElevetionInMeters , lowestElevetion,skyElevetionInMeters ,  "none",COLOR_SKY,0));    
    svgGroup.nodes.add(_buildProfileFragment( (p)=> p.elevetionInMeters , lowestElevetion,skyElevetionInMeters ,  "none", "black",1));    
    svgGroup.nodes.add(_buildProfileFragment( (p)=> p.getSnowInMeters(skyElevetionInMeters) , lowestElevetion,skyElevetionInMeters ,  "none", "white",0));    
    svgGroup.nodes.add(_buildProfileFragment( (p)=> p.scatteredInMeters  , lowestElevetion,skyElevetionInMeters ,  "none", "#C2A385",0));    
    svgGroup.nodes.add(_buildProfileFragment( (p)=> p.thornyInMeters , lowestElevetion,skyElevetionInMeters ,  "none", "#4C8033",0));    
    svgGroup.nodes.add(_buildProfileFragment( (p)=> p.leafyInMeters , lowestElevetion,skyElevetionInMeters ,  "none", "#99FF66",0));    
    svgGroup.nodes.add(_buildProfileFragment( (p)=> p.meadowInMeters , lowestElevetion,skyElevetionInMeters ,  "none", "#FFE066",0));    
    
    SvgElement svg = new SvgElement.tag('svg');
    svg.nodes.add(svgGroup);
    svg.attributes = {
       "height": "${height}",
       "width": "${width}",
       "version": "1.1"
    };
    querySelector("#${id}").nodes.add(svg);
    
    querySelector("#${id}").style.backgroundColor = COLOR_SKY ;
  }
  
  void _mayFireProfilePointSelection(){
    if(_profilePointToBeFired != null){
      _profilePointSelectionController.add(_profilePointToBeFired);
      _profilePointToBeFired = null;
    }
    new Timer(PROFILE_SELECTION_REFRESH_TIME, _mayFireProfilePointSelection);
  }
  
  void _listenToMouse(){

    
    Element profileElement = querySelector("#${id}") ;

    profileElement.onMouseMove.listen((e){
      
      if (_traceDetails == null){
        return;
      }
      
      Element verticalLineElement = querySelector("#${id}-vertical-line") ;

      var clientX =  e.client.x - ( window.innerWidth - width - right)  ;  
      
      verticalLineElement.style.position = 'absolute';
      verticalLineElement.style.zIndex = '1000';
      verticalLineElement.style.width = '1px';
      verticalLineElement.style.backgroundColor = 'black';
      
      int index = ( clientX / width * _traceDetails.profilePoints.length ).toInt() ;

      if (  index >= 0 && index < _traceDetails.profilePoints.length  ){
        
        _currentProfilePoint = _traceDetails.profilePoints[index] ;
        _profilePointToBeFired = _currentProfilePoint ;
        
        int valueX =   _currentProfilePoint.elevetionInMeters  ;
        int valueY =   _currentProfilePoint.distanceInMeters  ;
        var elevetion = "${valueX}m" ;
        var distance = "${(valueY/1000).truncate()}km&nbsp;${( valueY- (valueY/1000).truncate()*1000)}m " ;

        verticalLineElement.style.left = "${clientX}px";
        verticalLineElement.style.top = "${top}px"; ;
        verticalLineElement.style.height = "${height}px";
        verticalLineElement.setInnerHtml("<span style='border-style: solid; border-width:1px; background-color:white; '  >&nbsp;${distance}&nbsp;${elevetion}&nbsp;</span>",
            validator: buildNodeValidatorBuilderForSafeHtml());
        
        
      }

  });
  }
  
  SvgElement _buildProfileFragment( ElevetionValue elevetionValue,
                                    int lowestElevetion, int heighestElevetion,
                                    String color, String fillColor, int strokeWidth){
    
    var line = new SvgElement.tag("path");

    String points = "M0,${height} "  ;
    for (var i = 0; i < _traceDetails.profilePoints.length; i++) {
      num x = _getXPosition(i);
      num y = _getYPosition(elevetionValue(_traceDetails.profilePoints[i]),lowestElevetion,heighestElevetion ) ;
      points += "L${x},${y} " ;
    }
    points += "L${width},${height} Z" ;
    
    line.attributes = {
                       "d" : points,
                       "style": "fill:${fillColor};stroke:${color};stroke-width:${strokeWidth}"
    };    
    return line;
  }
  
  int _getSkyElevetion(){
       num numberOfMeterPerPixel = _traceDetails.length / width;
       num skyElevetionInMeters  = (height * numberOfMeterPerPixel / 10) + SKY_HEIGHT_IN_METERS;
       
       if ( skyElevetionInMeters + SKY_HEIGHT_IN_METERS < _traceDetails.upperPointElevetion) {
	            skyElevetionInMeters = _traceDetails.upperPointElevetion + SKY_HEIGHT_IN_METERS ;
       }
       return skyElevetionInMeters.round();
  }

  
  int _getLowestPoint(){
    int lowestElevetion = _traceDetails.profilePoints.first.elevetionInMeters ;
    _traceDetails.profilePoints.forEach((p){
      if(p.elevetionInMeters<lowestElevetion){
        lowestElevetion = p.elevetionInMeters;
      }
    });
    return lowestElevetion;
  }
  
  int _getHeighestPoint(){
    int heighestElevetion = _traceDetails.profilePoints.first.elevetionInMeters ;
    _traceDetails.profilePoints.forEach((p){
      if(p.elevetionInMeters>heighestElevetion){
        heighestElevetion = p.elevetionInMeters;
      }
    });
    return heighestElevetion;
  }
  
  num _getXPosition( int profilePointIndex){
    num numberOfPoints = _traceDetails.profilePoints.length;
    num numberOfAvailablePixels = width ;
    return (profilePointIndex * numberOfAvailablePixels /numberOfPoints);
  }
  
  num _getYPosition( int elevetion, int lowestElevetion, int heighestElevetion){
    num elevetionRange = heighestElevetion - lowestElevetion + SKY_HEIGHT_IN_METERS;
    num numberOfAvailablePixels = height ;
    return height - ( (elevetion - lowestElevetion ) * numberOfAvailablePixels /elevetionRange);
  }
  
  
}
