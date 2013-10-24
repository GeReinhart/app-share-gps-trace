

import 'dart:html';

class SpacesLayout{
  
  String spaces ;
  String spaceElements  ;
  String spaceNW  ;
  String spaceNE  ;
  String spaceSW  ;
  String spaceSE  ;
  String spaceCenter  ;
  String spaceMenu =".space-menu";
  double centerRight = (window.innerWidth * 0.5) ;
  double centerTop = (window.innerHeight * 0.5) ;
  int centerSize = 180 ;
  
  MouseEvent _startMovingCenterPosition ;
  var _movingCenter = false;
  
  SpacesLayout(this.spaces, this.spaceElements, this.spaceNW, this.spaceNE, this.spaceSW,
               this.spaceSE, this.spaceCenter, this.centerSize){
    _init();
  }
  
  
  void _init(){
    
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
    ..style.top = (centerTop+1  + centerSize /6 ).toString()+ "px" 
    ..style.width = centerSize.toString()+ "px"
    ..style.height = "0px" ;   
  }
}





