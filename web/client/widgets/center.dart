import "dart:html";
import "widget.dart" ;
import 'dart:async';
import "../controllers.dart" ;
import "../actions.dart" ;

typedef void CenterChangeCallBack(CenterPostion centerPosition);

class CenterPostion{
  int centerRightPercentPosition ;
  int centerTopPercentPosition;
  int centerSize ;

  double centerRight ;
  double centerTop ;
  
  CenterPostion clone(){
    CenterPostion other = new CenterPostion();
    other.centerRightPercentPosition = centerRightPercentPosition;
    other.centerTopPercentPosition = centerTopPercentPosition;
    other.centerSize = centerSize;
    other.centerRight = centerRight;
    other.centerTop = centerTop;
    return other;
  }
}


class CenterWidget extends Widget {
  
  StreamController _centerChangeEventStream ;
  List<ActionDescriptor> actions = new List<ActionDescriptor>(); 
  
  
  MouseEvent _startMovingCenterPosition ;
  var _movingCenter = false;
  
  CenterPostion _centerPosition ;

  
  CenterWidget(String id, int centerSize, int centerRightPercentPosition, int centerTopPercentPosition ) : super(id){
    _centerPosition = new CenterPostion();
    _centerPosition.centerSize = centerSize;
    _centerPosition.centerRightPercentPosition = centerRightPercentPosition ;
    _centerPosition.centerTopPercentPosition = centerTopPercentPosition ;
    _centerPosition.centerRight = (window.innerWidth * centerRightPercentPosition / 100).toDouble() ;
    _centerPosition.centerTop = (window.innerHeight * centerTopPercentPosition / 100).toDouble() ;
    _initCenterEventProducer();
    _listenToMovement();
  }

  void moveCenter(int centerRightPercentPosition, int centerTopPercentPosition){
    _centerPosition.centerRightPercentPosition = centerRightPercentPosition ;
    _centerPosition.centerTopPercentPosition = centerTopPercentPosition ;
    _centerPosition.centerRight = (window.innerWidth * centerRightPercentPosition / 100).toDouble() ;
    _centerPosition.centerTop = (window.innerHeight * centerTopPercentPosition / 100).toDouble() ;
    _changePositionOfTheCenter();
    
  }
  
  void userActionsChangeEventCallBack(UserActionsChangeEvent event){
   actions.clear();
   if (event.currentPageMenu != null){
     event.currentPageMenu.forEach( (action) {
       if (action.images != null ){
         actions.add(action) ;
       }
     }); 
   }
   if (event.mainApplicationMenu != null){
     event.mainApplicationMenu.forEach( (action) {
       if (action.images != null ){
         actions.add(action) ;
       }
     }); 
   }   
   
   Element actionsElement = querySelector("#${id}-actions");
   actionsElement.children.clear();
   int imageSize = 25 ;
   if (actions.length >=1 ){
     actionsElement.children.add(_newActionElement(actions[0],imageSize, (_centerPosition.centerSize -imageSize) /2 +2, 0 ));
   }
   if (actions.length >=2 ){
     actionsElement.children.add(_newActionElement(actions[1],imageSize,
                                                     (_centerPosition.centerSize -imageSize) /2 +2,
                                                     (_centerPosition.centerSize -imageSize) +2 ));
   }   
   if (actions.length >=3 ){
     actionsElement.children.add(_newActionElement(actions[2],imageSize,
                                                     0,
                                                     (_centerPosition.centerSize -imageSize) /2 +2 ));
   }     
   if (actions.length >=4 ){
     actionsElement.children.add(_newActionElement(actions[3],imageSize,
                                                      (_centerPosition.centerSize -imageSize) +2 ,
                                                     (_centerPosition.centerSize -imageSize) /2 +2 ));
   }   
   if (actions.length >=5 ){
     actionsElement.children.add(_newActionElement(actions[4],imageSize,
                                                     (_centerPosition.centerSize -imageSize) /4 +2 ,
                                                     (_centerPosition.centerSize -imageSize) /4 +2 ));
   }   

  
  }
  
  
  AnchorElement _newActionElement(ActionDescriptor action, num imageSize, num right, num top ){
       AnchorElement link = new AnchorElement();
       link.classes.add("gx-as-link");
       link.title = action.description ;
       ImageElement image = new ImageElement(src:action.images.image) ;
       link.append(image);
       image
         ..style.position = 'absolute'
         ..style.right = "${right}px"
         ..style.top = "${top}px"
         ..style.width =  "${imageSize}px"
         ..style.height =  "${imageSize}px" ; 
       
       if (action.windowTarget != null){
         link.target = action.windowTarget ;
       }
       if (action.nextPage != null){
         link.href = action.nextPage ;
       }
       if(action.launchAction != null){
         link.onClick.listen((event){
           action.launchAction(null);
         });
       }  
       link.onMouseOver.listen((e){
         image.src = action.images.imageOver;
       });
       
       link.onMouseEnter.listen((e){
         image.src = action.images.imageOver;
       });
       link.onMouseOut.listen((e){
         image.src = action.images.image;
       });       
       link.onMouseLeave.listen((e){
         image.src = action.images.image;
       });   
       return link;
  }
  
  void _changePositionOfTheCenter(){
    widgetElement
      ..style.position = 'absolute'
      ..style.right = (_centerPosition.centerRight  - _centerPosition.centerSize /2 +2   ).toString() + "px"
      ..style.top = (_centerPosition.centerTop    - _centerPosition.centerSize /2      ).toString()+ "px"
      ..style.width = _centerPosition.centerSize.toString()+ "px"
      ..style.height = _centerPosition.centerSize.toString()+ "px" ; 
  }
  void _listenToMovement(){
    widgetElement.onMouseDown.listen((mouseEvent) {
      _startMovingCenterPosition = mouseEvent ;
      _movingCenter = true ;
      querySelector("#${id}-img").attributes["src"] = "/assets/img/compass_275_red.png";
    });
    widgetElement.onMouseLeave.listen((mouseEvent) {
      if (_movingCenter){
        _movingCenter = false;
        _moveCenter( _startMovingCenterPosition.client, mouseEvent.client);
      }
    });
    widgetElement.onMouseUp.listen((mouseEvent) {
      if (_movingCenter){
        _movingCenter = false;
        _moveCenter( _startMovingCenterPosition.client, mouseEvent.client);
      }
    });     
    window.onMouseOver.listen((mouseEvent) {
      if (_movingCenter){
        _movingCenter = false;
        _moveCenter( _startMovingCenterPosition.client, mouseEvent.client);
      }
    });
    window.onMouseUp.listen((mouseEvent) {
      if (_movingCenter){
        _movingCenter = false;
        _moveCenter( _startMovingCenterPosition.client, mouseEvent.client);
      }
    });    
  }
  
  void _moveCenter(Point start, Point end){
    double centerRightComputed =   -end.x + start.x  + _centerPosition.centerRight ;
    double centerTopComputed   =  end.y - start.y  + _centerPosition.centerTop ;  ;
    
    if (centerRightComputed < _centerPosition.centerSize /2 ){
      _centerPosition.centerRight = (_centerPosition.centerSize/2).toDouble() ;
    }else{
      _centerPosition.centerRight = centerRightComputed;
    }
    if ( centerTopComputed >  window.innerHeight - _centerPosition.centerSize /2  ){
      _centerPosition.centerTop = (window.innerHeight - _centerPosition.centerSize /2).toDouble()  ;       
    }else{
      _centerPosition.centerTop = centerTopComputed ;
    }
    
    _changePositionOfTheCenter();
    
    querySelector("#${id}-img").attributes["src"] = "/assets/img/compass_275.png";
    
    _sendCenterChangeEvent();
  }

  void _initCenterEventProducer(){
    _centerChangeEventStream = new StreamController.broadcast( sync: true);
  }
  
  void setCenterChangeEventCallBack( CenterChangeCallBack callBack  ){
    _centerChangeEventStream.stream.listen((event) => callBack(event));
  }
  
  void _sendCenterChangeEvent(){
    _centerChangeEventStream.add(  _centerPosition.clone()  );
  }
  
  CenterPostion get centerPostion => _centerPosition.clone();
  
}