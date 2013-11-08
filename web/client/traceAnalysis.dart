import 'spaces.dart';
import 'dart:html';
import 'package:js/js.dart' as js;

void main() {
  SpacesLayout layout = new SpacesLayout(180,30,35);
  moveTraceViewers(layout.postions);
  
  layout.centerMoved.listen((_){
    moveTraceViewers( _ as SpacesPositions);
  });
  
  querySelector(".btn-analysis").onClick.listen((e){
    layout.startLoading();
    FormElement form = querySelector("#trace-analysis-form");
    form.submit();

    // stop event
    e.preventDefault();
    e.stopPropagation();
  });
  
}

void moveTraceViewers(SpacesPositions spacesPositions ){
  
  querySelector("#traceGpxViewer") 
  ..style.position = 'absolute'
  ..style.right  =  "0px" 
  ..style.top    =  "0px" 
  ..style.width  = (spacesPositions.spaceSW_Width).toString() + "px"
  ..style.height = (spacesPositions.spaceSW_Height).toString() + "px" ;

  num traceHeightWidthRatio = js.context.traceHeightWidthRatio;
  
  
  num traceProfileViewerWidth = spacesPositions.spaceNE_Width  * 0.95;
  num traceProfileViewerHeight = traceProfileViewerWidth * traceHeightWidthRatio * 10;
  
  querySelector("#traceProfileViewer") 
  ..style.position = 'absolute'
  ..style.right  = (spacesPositions.spaceNE_Width  * 0.05 ).toString() + "px" 
  ..style.top    = (spacesPositions.spaceNE_Height * 0.15 ).toString() + "px" 
  ..style.width  = (traceProfileViewerWidth ).toString() + "px" 
  ..style.height = (traceProfileViewerHeight ).toString() + "px" ;
  
  js.context.drawTraceProfile();
}



