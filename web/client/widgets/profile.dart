import "dart:html";
import "dart:svg" hide ImageElement;
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
  
  int _lowestElevetion = 0;
  int _heighestElevetion = 0;
  int _skyElevetionInMeters = 0;
  
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
    
    _lowestElevetion      = _getLowestPoint();
    _heighestElevetion    = _getHeighestPoint();
    _skyElevetionInMeters = _getSkyElevetion() ;

    svgGroup.nodes.add(_buildProfileFragment( (p)=> _skyElevetionInMeters , _lowestElevetion,_skyElevetionInMeters ,  "none",COLOR_SKY,0));    
    svgGroup.nodes.add(_buildProfileFragment( (p)=> p.elevetionInMeters , _lowestElevetion,_skyElevetionInMeters ,  "black", "black",1));    
    svgGroup.nodes.add(_buildProfileFragment( (p)=> p.getSnowInMeters(_skyElevetionInMeters)-1 , _lowestElevetion,_skyElevetionInMeters ,  "none", "white",0));    
    svgGroup.nodes.add(_buildProfileFragment( (p)=> p.scatteredInMeters-1  , _lowestElevetion,_skyElevetionInMeters ,  "none", "#C2A385",0));    
    svgGroup.nodes.add(_buildProfileFragment( (p)=> p.thornyInMeters-1 , _lowestElevetion,_skyElevetionInMeters ,  "none", "#4C8033",0));    
    svgGroup.nodes.add(_buildProfileFragment( (p)=> p.leafyInMeters-1 , _lowestElevetion,_skyElevetionInMeters ,  "none", "#99FF66",0));    
    svgGroup.nodes.add(_buildProfileFragment( (p)=> p.meadowInMeters-1 , _lowestElevetion,_skyElevetionInMeters ,  "none", "#FFE066",0));    
    
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
    querySelectorAll(".profile").forEach((profileElement){
      profileElement.onMouseMove.listen((e){
        _callMoveCursor(e);
      });
    }) ;
    querySelectorAll("#spaceCenter-img").forEach((profileElement){
      profileElement.onMouseMove.listen((e){
        _callMoveCursor(e);
      });
    }) ;
  }
  
  void _callMoveCursor(MouseEvent e){
    if (_traceDetails == null){
      return;
    }
    
    num clientX =  e.client.x - ( window.innerWidth - width - right)  ;  
    num distance = ( clientX / width * _traceDetails.length ).toInt() ;
    int index = _getIndexFromDistance( distance);
    if (  index >= 0 && index < _traceDetails.profilePoints.length  ){
      _currentProfilePoint = _traceDetails.profilePoints[index] ;
      _profilePointToBeFired = _currentProfilePoint ;
      _moveCursor(clientX, _currentProfilePoint) ;
    }
  }
  
  
  void _moveCursor( num clientX, ProfilePoint point){

    int valueX =   point.elevetionInMeters  ;
    int valueY =   point.distanceInMeters  ;
    String elevetion = "${valueX}m" ;
    String distance = "${(valueY/1000).truncate()}km&nbsp;${( valueY- (valueY/1000).truncate()*1000)}m " ;
    
    Element _cursorElement = querySelector("#${id}-cursor") ;
    Element _cursorElementDistance = querySelector("#${id}-cursor-distance") ;
    Element _cursorElementElevetion = querySelector("#${id}-cursor-elevetion") ;
    ImageElement _cursorElementImg = querySelector("#${id}-cursor-img") ;
    _cursorElementDistance.setInnerHtml(distance,validator: buildNodeValidatorBuilderForSafeHtml())  ;
    _cursorElementElevetion.setInnerHtml(elevetion,validator: buildNodeValidatorBuilderForSafeHtml())  ;
    
    int cursorWidth = 80;
    int cursorHeight = 36 + 37;
    num yPosition = _getYPosition( point.elevetionInMeters, _lowestElevetion, _skyElevetionInMeters);
    
    _cursorElement.style.position = 'relative';
    _cursorElement.style.zIndex = '1001';
    _cursorElement.style.width = "${cursorWidth}px";
    _cursorElement.style.height = "${cursorHeight}px";
    _cursorElement.style.left = "${clientX - cursorWidth/2}px";
    _cursorElement.style.top = "${yPosition - cursorHeight}px"; ;

    _cursorElementDistance.style.width = "${cursorWidth}px";
    _cursorElementElevetion.style.width = "${cursorWidth}px";
    
    _cursorElementImg.src =_traceDetails.mainIconUrl ;
    _cursorElementImg.style.left = "24px";
    _cursorElementImg.style.width = "32px";
    _cursorElementImg.style.height = "37px";
    
    
  }
  
  int _getIndexFromDistance(num distance){
    int index = 0;
    List<ProfilePoint> profilePoints = _traceDetails.profilePoints;
    for (int i = 0 ; i< profilePoints.length; i++){
      if (profilePoints[i].distance < distance){
        index = i;
      }else{
        return index;
      }
    }
    
    return index ;
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
    num numberOfAvailablePixels = width ;
    return ( _traceDetails.profilePoints[profilePointIndex].distance * numberOfAvailablePixels /_traceDetails.length);
  }
  
  num _getYPosition( int elevetion, int lowestElevetion, int heighestElevetion){
    num elevetionRange = heighestElevetion - lowestElevetion + SKY_HEIGHT_IN_METERS;
    num numberOfAvailablePixels = height ;
    return height - ( (elevetion - lowestElevetion ) * numberOfAvailablePixels /elevetionRange);
  }
  
  
}
