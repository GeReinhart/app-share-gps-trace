

import 'dart:html';
import 'package:bootjack/bootjack.dart';


class SpacesLayout{
  
  String spaces = ".spaces" ;
  String spaceElements  = ".space"  ;
  String spaceNW  = ".space-north-west";
  String spaceNE  = ".space-north-east";
  String spaceSW  = ".space-south-west";
  String spaceSE  = ".space-south-east" ;
  String spaceCenter = ".space-center"  ;
  String spaceMenu = ".space-menu";
  
  int centerRightPercentPosition ;
  int centerTopPercentPosition;
  int centerSize ;

  double centerRight ;
  double centerTop ;
  
  MouseEvent _startMovingCenterPosition ;
  var _movingCenter = false;
  
  SpacesLayout(this.centerSize, this.centerRightPercentPosition,  this.centerTopPercentPosition){
    
    centerRight = (window.innerWidth * centerRightPercentPosition / 100).toDouble() ;
    centerTop = (window.innerHeight * centerTopPercentPosition / 100).toDouble() ;
    _init();
  }
  
  
  void _init(){
    
    
    Dropdown.use();
    
    organizeSpaces();
    
    window.onLoad.listen(updateSpaces);
    window.onResize.listen(updateSpaces);

    query(spaceCenter).onMouseDown.listen((mouseEvent) {
      _startMovingCenterPosition = mouseEvent ;
      _movingCenter = true ;
      query(spaceCenter + " a img").attributes["src"] = "assets/img/compass_275_red.png";
    });

    query(spaceCenter).onMouseLeave.listen((mouseEvent) {
      if (_movingCenter){
        _movingCenter = false;
        _moveCenter( _startMovingCenterPosition.client, mouseEvent.client);
      }
    });

    query(spaceCenter).onMouseUp.listen((mouseEvent) {
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


    query(spaceCenter).onMouseOver.listen((mouseEvent) {
      var menu = query(spaceMenu);
      if ( menu.style.zIndex == "99" ){
        menu.style.zIndex = "102" ;
        menu.classes.add("open") ;
      }
    });
    
    query(spaceMenu).onMouseLeave.listen((mouseEvent) {
      var menu = query(spaceMenu);
      if ( menu.style.zIndex != "99" ){
        menu.style.zIndex = "99" ;
        menu.classes.remove("open") ;
      }
    });
    
    
  }
  
  void _moveCenter(Point start, Point end){
    double centerRightComputed =   -end.x + start.x  + centerRight ;
    double centerTopComputed   =  end.y - start.y  + centerTop ;  ;
    
    if (centerRightComputed < centerSize /2 ){
      centerRight = (centerSize/2).toDouble() ;
    }else{
      centerRight = centerRightComputed;
    }
    if ( centerTopComputed >  window.innerHeight - centerSize /2  ){
      centerTop = (window.innerHeight - centerSize /2).toDouble()  ;       
    }else{
      centerTop = centerTopComputed ;
    }
    organizeSpaces();
  }
  
  void updateSpaces(Event event){
    organizeSpaces();
  }
  
  void organizeSpaces(){

    query(spaceNW) 
    ..style.position = 'absolute'
    ..style.right = (centerRight+1).toString() + "px" 
    ..style.top = "Opx" 
    ..style.width = (window.innerWidth - centerRight-1).toString() + "px"
    ..style.height = centerTop.toString() + "px" ;

    query(spaceNE)
    ..style.position = 'absolute'
    ..style.right = "0px"
    ..style.top = "Opx" 
    ..style.width = centerRight.toString() + "px"
    ..style.height = centerTop.toString() + "px";

    query(spaceSW)
    ..style.position = 'absolute'
    ..style.right = (centerRight+1).toString() + "px"
    ..style.top = (centerTop+1).toString() + "px"
    ..style.width =  ( window.innerWidth - centerRight-1 ).toString() + "px"
    ..style.height =   ( window.innerHeight - centerTop-1 ).toString() + "px" ;  
    
    query(spaceSE)
    ..style.position = 'absolute'
    ..style.right = "0px"
    ..style.top = (centerTop+1).toString()+ "px" 
    ..style.width = centerRight.toString()+ "px"
    ..style.height = ( window.innerHeight - centerTop-1 ).toString() + "px" ;  
    
    query(spaceCenter)
    ..style.position = 'absolute'
    ..style.right = (centerRight  - centerSize /2 +2   ).toString() + "px"
    ..style.top = (centerTop    - centerSize /2      ).toString()+ "px"
    ..style.width = centerSize.toString()+ "px"
    ..style.height = centerSize.toString()+ "px" ;  
    query(spaceCenter + " a img").attributes["src"] = "assets/img/compass_275.png";

    query(spaceMenu)
    ..style.zIndex = "99"
    ..style.position = 'absolute'
    ..style.right = (centerRight  - centerSize /2 +2   ).toString() + "px"
    ..style.top =  centerTopPercentPosition<50 ? (centerTop+1  + centerSize /6 ).toString()+ "px" : (centerTop+1  - centerSize *5/6 ).toString()+ "px"
    ..style.width = centerSize.toString()+ "px"
    ..style.height = "0px" ;   
  }
}





