import "dart:html";
import "dart:convert";
import 'package:bootjack/bootjack.dart';

import "spaces.dart";
import "forms.dart";
import 'package:js/js.dart' as js;

SpacesLayout layout ;

void main() {
  layout = new SpacesLayout(180,30,35);
  moveTraceViewers(layout.postions);
  
  layout.centerMoved.listen((_){
    moveTraceViewers( _ as SpacesPositions);
  });

  querySelectorAll(".trace-delete-menu").onClick.listen((event){
    callDeleteConfirmation();
  });
  
  
}

void callDeleteConfirmation() {

    layout.startLoading();
    
    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {

        DeleteTraceForm form = new DeleteTraceForm.fromJson(JSON.decode(request.responseText));
        var message = querySelector(".form-error-message");
        if (form.success){
          window.location.assign('/trace.search');
        }
        
        layout.stopLoading();
      }
    });

    request.open("POST",  "/trace.as_delete", async: false);
    
    DeleteTraceForm form =  new  DeleteTraceForm( querySelector("[data-key]").attributes["data-key"] );
    request.send(JSON.encode(form.toJson()));
  
}

void moveTraceViewers(SpacesPositions spacesPositions ){
  
  Element traceGpxViewer = querySelector("#traceGpxViewer") ;
  if (traceGpxViewer != null){
    num decalHeight = 180 ;
    num decalRight = 30 ;
    
    traceGpxViewer..style.position = 'absolute'
    ..style.right  =  "0px" 
    ..style.top    =  "-"+decalHeight.toString()+"px" 
    ..style.width  = (spacesPositions.spaceSW_Width+decalRight).toString() + "px"
    ..style.height = (spacesPositions.spaceSW_Height+decalHeight).toString() + "px" ;
  }
  
  Element traceProfileViewer = querySelector("#traceProfileViewer") ;
  if (traceProfileViewer != null){
    num traceHeightWidthRatio = js.context.traceHeightWidthRatio;
    num traceProfileViewerWidth = spacesPositions.spaceNW_Width  * 0.95;
    num traceProfileViewerHeight = traceProfileViewerWidth * traceHeightWidthRatio * 10;
    
    if (  traceProfileViewerHeight >  spacesPositions.spaceNW_Height * 0.95){
      traceProfileViewerWidth = traceProfileViewerHeight / traceHeightWidthRatio / 10  ;
      traceProfileViewerHeight = spacesPositions.spaceNW_Height * 0.80;
    }
    
    
    traceProfileViewer..style.position = 'absolute'
    ..style.right  = (spacesPositions.spaceNW_Width  * 0.05 ).toString() + "px" 
    ..style.top    = (spacesPositions.spaceNW_Height * 0.15 ).toString() + "px" 
    ..style.width  = (traceProfileViewerWidth ).toString() + "px" 
    ..style.height = (traceProfileViewerHeight ).toString() + "px" ;
  
    js.context.drawTraceProfile();
  }
  
  Element traceStatisticsViewer = querySelector("#traceStatisticsViewer") ;
  if (traceStatisticsViewer != null){
    traceStatisticsViewer..style.position = 'absolute'
    ..style.right  = (spacesPositions.spaceSE_Width  * 0.10 ).toString() + "px" 
    ..style.top    = (spacesPositions.spaceSE_Height * 0.10 ).toString() + "px" 
    ..style.width  = (spacesPositions.spaceSE_Width  * 0.70 ).toString() + "px" 
    ..style.height = (spacesPositions.spaceSE_Height * 0.70 ).toString() + "px" ;
  }
  
}



