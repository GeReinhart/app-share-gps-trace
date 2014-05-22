import "dart:html";
import "dart:svg" hide ImageElement;
import 'dart:async';
import "widget.dart" ;
import "../forms.dart";
import "../images.dart" ;

typedef int ElevetionValue(ProfilePoint profilePoint);


class ProfileWidget extends Widget {
  
  static int SKY_HEIGHT_IN_METERS = 500 ; 
  static int PROFILE_DECORATOR_WIDTH  = 80;
  static int PROFILE_DECORATOR_HEIGHT = 73;
  static String COLOR_SKY = "#5B6DE3"; 
  static String COLOR_DEFAULT = "white"; 
  static const PROFILE_SELECTION_REFRESH_TIME = const Duration(milliseconds: 250);
  
  TraceDetails _traceDetails ;
  ProfilePoint _currentProfilePoint ;
  ImageUrlProvider imageUrlProvider = new ImageUrlProvider();
  
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
    
    DivElement watchPointElements = querySelector("#${id}-watchpoints");
    watchPointElements.children.clear();
    DivElement watchPoint = querySelector(".${id}-watchpoint-template");
    
    traceDetails.watchPoints.forEach((watchPointData){
      watchPointData.distance.forEach((distance){

        DivElement currentWatchPointElement =  watchPoint.clone(true);
        currentWatchPointElement.onMouseMove.listen((e){
          _callMoveCursor(e);
        });
        watchPointElements.children.add(currentWatchPointElement);
        Element textElement = currentWatchPointElement.children[0];
        textElement.text = watchPointData.name ;
        textElement.onMouseMove.listen((e){
          _callMoveCursor(e);
        });        
        ImageElement imageElement = currentWatchPointElement.children[1] ;
        imageElement.onMouseMove.listen((e){
          _callMoveCursor(e);
        });  
        imageElement.src = imageUrlProvider.buildUrlForWatchPoint(watchPointData.type) ;
        
        ProfilePoint point = _getPointFromDistance(distance);
        _moveProfileDecorator( currentWatchPointElement, imageElement,  point) ;
        
      });
    });
    
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
    num positionX =  e.client.x - ( window.innerWidth - width - right)  ;  
    num distance = _positionXToDistance(positionX) ;
    ProfilePoint point = _getPointFromDistance( distance);
    if ( point != null  ){
      _currentProfilePoint = point ;
      _profilePointToBeFired = point ;
      _moveCursor(point) ;
    }
  }
  
  num _positionXToDistance(num positionX){
    return ( positionX / width * _traceDetails.length ).toInt() ;
  }

  num _distanceToPositionX(num distance){
    return  width * distance /  _traceDetails.length  ;
  }
  
  void _moveCursor( ProfilePoint point){
    int elevetion =   point.elevetionInMeters  ;
    int distance =   point.distanceInMeters  ;
    String labelElevetion = "${elevetion}m" ;
    String labelDistance = "${(distance/1000).truncate()}km&nbsp;${( distance- (distance/1000).truncate()*1000)}m " ;
    
    DivElement _cursorElement = querySelector("#${id}-cursor") ;
    Element _cursorElementDistance = querySelector("#${id}-cursor-distance") ;
    Element _cursorElementElevetion = querySelector("#${id}-cursor-elevetion") ;
    ImageElement _cursorElementImg = querySelector("#${id}-cursor-img") ;
    
    _cursorElementDistance.setInnerHtml(labelDistance,validator: buildNodeValidatorBuilderForSafeHtml())  ;
    _cursorElementElevetion.setInnerHtml(labelElevetion,validator: buildNodeValidatorBuilderForSafeHtml())  ;
    _cursorElementDistance.style.width = "${PROFILE_DECORATOR_WIDTH}px";
    _cursorElementElevetion.style.width = "${PROFILE_DECORATOR_WIDTH}px";
    _cursorElementImg.src =_traceDetails.mainIconUrl ;
    _moveProfileDecorator( _cursorElement, _cursorElementImg,  point) ;
  }
  
  
  void _moveProfileDecorator(DivElement decoratorElement, ImageElement imageElement, ProfilePoint point){
    num positionY = _getPositionY( point.elevetionInMeters, _lowestElevetion, _skyElevetionInMeters);
    num positionX = _distanceToPositionX(point.distance) ;
    decoratorElement.style.position = 'absolute';
    decoratorElement.style.zIndex = '1001';
    decoratorElement.style.width = "${PROFILE_DECORATOR_WIDTH}px";
    decoratorElement.style.height = "${PROFILE_DECORATOR_HEIGHT}px";
    decoratorElement.style.left = "${positionX - PROFILE_DECORATOR_WIDTH/2}px";
    decoratorElement.style.top =  "${positionY - PROFILE_DECORATOR_HEIGHT}px"; ;
    
    imageElement.style.left   = "24px";
    imageElement.style.width  = "32px";
    imageElement.style.height = "37px";
  }
  
  ProfilePoint _getPointFromDistance(num distance){
    int index = 0;
    List<ProfilePoint> profilePoints = _traceDetails.profilePoints;
    for (int i = 0 ; i< profilePoints.length; i++){
      if (profilePoints[i].distance < distance){
        index = i;
      }else{
        return profilePoints[index];
      }
    }
    if(index == 0){
      return null;
    }
    return profilePoints[index];
  }
  
  SvgElement _buildProfileFragment( ElevetionValue elevetionValue,
                                    int lowestElevetion, int heighestElevetion,
                                    String color, String fillColor, int strokeWidth){
    
    var line = new SvgElement.tag("path");

    String points = "M0,${height} "  ;
    for (var i = 0; i < _traceDetails.profilePoints.length; i++) {
      num x = _getPositionX(i);
      num y = _getPositionY(elevetionValue(_traceDetails.profilePoints[i]),lowestElevetion,heighestElevetion ) ;
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
  
  num _getPositionX( int profilePointIndex){
    num numberOfAvailablePixels = width ;
    return ( _traceDetails.profilePoints[profilePointIndex].distance * numberOfAvailablePixels /_traceDetails.length);
  }
  
  num _getPositionY( int elevetion, int lowestElevetion, int heighestElevetion){
    num elevetionRange = heighestElevetion - lowestElevetion + SKY_HEIGHT_IN_METERS;
    num numberOfAvailablePixels = height ;
    return height - ( (elevetion - lowestElevetion ) * numberOfAvailablePixels /elevetionRange);
  }
  
  
}
