import 'dart:html';
import 'package:html5_dnd/html5_dnd.dart';

class SpacesLayout{
  
  String spaces ;
  String spaceElements  ;
  String spaceNW  ;
  String spaceNE  ;
  String spaceSW  ;
  String spaceSE  ;
  String spaceCenter  ;
  double centerRight = (window.innerWidth * 0.5) ;
  double centerTop = (window.innerHeight * 0.5) ;
  int centerSize = 180 ;
  
  MouseEvent _currentPosition ;
  var _moveCenter = false ;
  
  SpacesLayout(this.spaces, this.spaceElements, this.spaceNW, this.spaceNE, this.spaceSW,
               this.spaceSE, this.spaceCenter, this.centerSize ){
    _init();
  }
  
  
  void _init(){
    
    organizeSpaces();
    
    window.onLoad.listen(updateSpaces);
    window.onResize.listen(updateSpaces);
    
    window.onMouseMove.listen((mouseEvent) {
      _currentPosition = mouseEvent ;
      if(_moveCenter){
        _moveCenter = false ; 
        
        double centerRightComputed = (window.innerWidth -  _currentPosition.client.x + centerSize /2 ).toDouble()   ;
        double centerTopComputed   =  (_currentPosition.client.y - centerSize/2 ).toDouble()  ;
        
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
    });
    
    DraggableGroup dragGroup = new DraggableGroup();
    dragGroup.installAll(queryAll(spaceCenter));
    DropzoneGroup dropGroup = new DropzoneGroup();
    dropGroup.installAll(queryAll(spaceElements));
    dropGroup.accept.add(dragGroup);
    
    dropGroup.onDrop.listen(
        (DropzoneEvent event) { 
          _moveCenter = true ;
        }
    );
    
    
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
  }
}





