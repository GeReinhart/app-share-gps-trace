import "dart:html";
import "dart:convert";
import 'package:bootjack/bootjack.dart';
import 'package:js/js.dart' as js;


import 'page.dart';
import "../controllers.dart" ;
import "../spaces.dart";
import "../forms.dart";
import "../widgets/confirm.dart" ;
import "../events.dart" ;

class TraceDetailsPage extends Page {

  ConfirmWidget _deleteConfirm ;
  
  List<String> keys = new List<String>();
  String currentKey = null;
  
  
  TraceDetailsPage(PageContext context): super("trace_details",context,65,40,false){
    _deleteConfirm = new ConfirmWidget("deleteTraceConfirmModal", deleteTrace);
    
    moveTraceViewers(layout.postions);
    
    layout.centerMoved.listen((_){
      moveTraceViewers( _ as SpacesPositions);
    });

    querySelectorAll(".trace-delete-menu").onClick.listen((event){
      _deleteConfirm.showConfirmModal();
    });    
  }
  
  
  void deleteTrace(OKCancelEvent event) {
  
    if (event.cancel){
      return;
    }
    layout.startLoading();
    
    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {
  
        DeleteTraceForm form = new DeleteTraceForm.fromJson(JSON.decode(request.responseText));
        var message = querySelector(".form-error-message");
        if (form.success){
          window.location.assign('/#trace_search');
        }
        
        layout.stopLoading();
      }
    });
  
    request.open("POST",  "/j_trace_delete", async: false);
    
    DeleteTraceForm form =  new  DeleteTraceForm( querySelector("[data-key]").attributes["data-key"] );
    request.send(JSON.encode(form.toJson()));
  
  }
  
  
  
  void moveTraceViewers(SpacesPositions spacesPositions ){
    
    Element traceGpxViewer = querySelector("#traceGpxViewer") ;
    if (traceGpxViewer != null){
     
      traceGpxViewer..style.position = 'absolute'
      ..style.right  =  "0px" 
      ..style.top    =  "0px" 
      ..style.width  = (spacesPositions.spaceSE_Width).toString() + "px"
      ..style.height = (spacesPositions.spaceSE_Height).toString() + "px" ;
    }
    
    Element traceProfileViewer = querySelector("#traceProfileViewer") ;
    if (traceProfileViewer != null){
      num traceHeightWidthRatio = js.context.traceHeightWidthRatio;
      num traceProfileViewerWidth = spacesPositions.spaceNE_Width  * 0.95;
      num traceProfileViewerHeight = traceProfileViewerWidth * traceHeightWidthRatio * 10;
      
      if (  traceProfileViewerHeight >  spacesPositions.spaceNE_Height * 0.95){
        traceProfileViewerWidth = traceProfileViewerHeight / traceHeightWidthRatio / 10  ;
        traceProfileViewerHeight = spacesPositions.spaceNW_Height * 0.80;
      }
      
      
      traceProfileViewer..style.position = 'absolute'
      ..style.right  = (spacesPositions.spaceNE_Width  * 0.05 ).toString() + "px" 
      ..style.top    = (spacesPositions.spaceNE_Height * 0.15 ).toString() + "px" 
      ..style.width  = (traceProfileViewerWidth ).toString() + "px" 
      ..style.height = (traceProfileViewerHeight ).toString() + "px" ;
    
      js.context.drawTraceProfile();
    }
    
    Element traceStatisticsViewer = querySelector("#traceStatisticsViewer") ;
    if (traceStatisticsViewer != null){
      traceStatisticsViewer..style.position = 'absolute'
      ..style.right  = (spacesPositions.spaceSW_Width  * 0.10 ).toString() + "px" 
      ..style.top    = (spacesPositions.spaceSW_Height * 0.10 ).toString() + "px" 
      ..style.width  = (spacesPositions.spaceSW_Width  * 0.70 ).toString() + "px" 
      ..style.height = (spacesPositions.spaceSW_Height * 0.70 ).toString() + "px" ;
    }
    
  }

  bool canShowPage(PageParameters pageParameters){
    if (pageParameters.pageName == null){
      return false;
    }
    return pageParameters.pageName.startsWith("trace_details") ;
  }

  void showPage( PageParameters pageParameters) {
    organizeSpaces();
    String key = pageParameters.pageName.substring( "trace_details_".length  ) ;
    String keyJsSafe = _transformJsSafe(key) ;
    if(   keys.contains(key)    ){
      showBySelector( "#${name}NW_${keyJsSafe}");
      this.currentKey = key;
    }else{
      _showPage( key);       
    }
  }
 
 String _transformJsSafe(String input){
   return input.replaceAll("/", "_").replaceAll("'", "-");
 }
  
 void _showPage(String key){
    
    String keyJsSafe = _transformJsSafe(key) ;
    loadingNW.startLoading();
    HttpRequest request = new HttpRequest();
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {
        TraceDetails traceDetails = new TraceDetails.fromMap(JSON.decode(request.responseText));
        Element nw = querySelector("#${name}NW") ;
        Element textFragment =  nw.clone(true) ;
        textFragment.setAttribute("id", "${name}NW_${keyJsSafe}") ;
        nw.parentNode.append(textFragment);
        
        _displayData("trace-details-title",keyJsSafe,traceDetails.title) ;
        _displayData("trace-details-activities",keyJsSafe,traceDetails.activities) ;
        _displayData("trace-details-description",keyJsSafe,traceDetails.descriptionToRender) ;
        _displayData("trace-details-creator",keyJsSafe,traceDetails.creator) ;
        _displayData("trace-details-lastupdate",keyJsSafe,traceDetails.lastupdate) ;
        
        
        textFragment.classes.remove("gx-hidden") ;
        loadingNW.stopLoading();
        
        keys.add(key);
        this.currentKey = key;
      }
    });
    request.open("GET",  "/j_trace_details/${key}", async: true);
    request.send();      
  }
  
 void _displayData(String classSelector, String key, String data){
   bool first= true ;
   querySelectorAll(".${classSelector}").forEach((e){
     Element element = e as Element;
     if( !first   && (element.id == null || element.id.isEmpty) ){
       element.setAttribute("id", "${name}NW_${key}_${classSelector}") ;
       element.setInnerHtml(data) ;
     }
     first = false;
   }) ;
 }
  
  void hidePage() {
    String keyJsSafe = _transformJsSafe(currentKey) ;
    hideBySelector( "#${name}NW_${keyJsSafe}");
  }
}


void main() {
  TraceDetailsPage page = new TraceDetailsPage(new PageContext());
}




