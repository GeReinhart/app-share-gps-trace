import 'spaces.dart';
import 'dart:html';

void main() {
  SpacesLayout layout = new SpacesLayout(180,50,50);
  moveTraceGpxViewer(layout.postions);
  
  layout.centerMoved.listen((_){
    moveTraceGpxViewer( _ as SpacesPositions);
  });
}

void moveTraceGpxViewer(SpacesPositions spacesPositions ){
  
  querySelector("#traceGpxViewer") 
  ..style.position = 'absolute'
  ..style.right  =  "0px" 
  ..style.top    =  "0px" 
  ..style.width  = (spacesPositions.spaceSW_Width).toString() + "px"
  ..style.height = (spacesPositions.spaceSW_Height).toString() + "px" ;
  
}



