import "dart:html";
import "dart:convert";
import 'package:bootjack/bootjack.dart';
import 'package:js/js.dart' as js;


import 'page.dart';
import "../controllers.dart" ;
import "../spaces.dart";
import "../forms.dart";
import "../widgets/confirm.dart" ;
import "../widgets/profile.dart" ;
import "../events.dart" ;

class TraceDetailsPage extends Page {

  ConfirmWidget _deleteConfirm ;
  ProfileWidget _profile ;
  
  List<String> keys = new List<String>();
  Map<String,TraceDetails> traceDetailsByKey = new Map<String,TraceDetails>();
  String currentKey = null;
  
  TraceDetailsPage(PageContext context): super("trace_details",context,65,40,false){
    _deleteConfirm = new ConfirmWidget("deleteTraceConfirmModal", deleteTrace);
    _profile = new ProfileWidget("profile") ;
    
    layout.centerMoved.listen((_){
      updateNWPostion("#${name}NW");
      _moveMap( _ as SpacesPositions);
      moveTraceViewers( _ as SpacesPositions);
    });

    _profile.profilePointSelection.listen((p){
      if (currentKey != null){
        js.context.traceDetailsMap.moveMarker(traceDetailsByKey[currentKey].keyJsSafe,p.latitude,p.longitude);
      }
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
  

  void _moveMap(SpacesPositions spacesPositions ){
    
    Element map = querySelector("#trace-details-map-canvas") ;
    if (map != null){
        map..style.position = 'absolute'
            ..style.right  = "0px"
            ..style.top    = "0px"
            ..style.width  = (spacesPositions.spaceSE_Width).toString() + "px"
            ..style.height = (spacesPositions.spaceSE_Height).toString() + "px" ;
        
        js.context.traceDetailsMap.refreshTiles();
    }
  }
  
  void _moveProfile(SpacesPositions positions){
    _profile.updatePosition(positions.spaceNE_Top.toInt(),
        positions.spaceNE_Right.toInt(), 
        positions.spaceNE_Width.toInt(),
        positions.spaceNE_Height.toInt());
  }
  
  void moveTraceViewers(SpacesPositions spacesPositions ){

    _moveProfile( spacesPositions);
    Element traceProfileViewer = querySelector("#traceProfileViewer") ;
    if (traceProfileViewer != null && currentKey != null){
      _displayProfile(traceDetailsByKey[currentKey]) ;
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
    _moveMap(layout.postions);
    
    String key = pageParameters.pageName.substring( "trace_details_".length  ) ;
    String keyJsSafe = _transformJsSafe(key) ;
    loadingNE.startLoading();
    loadingSE.startLoading();
    
    if(   keys.contains(key)    ){
      showBySelector( "#${name}NW_${keyJsSafe}");
      showBySelector( "#${name}SW_${keyJsSafe}");
      loadingNE.stopLoading();
      loadingSE.stopLoading();
      _displayProfile( traceDetailsByKey[key] );
      showBySelector("#${name}NE");
      _displayMap( traceDetailsByKey[key] );
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
    loadingSW.startLoading();
    HttpRequest request = new HttpRequest();
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {
        TraceDetails traceDetails = new TraceDetails.fromMap(JSON.decode(request.responseText));
        traceDetailsByKey[key] = traceDetails;
        keys.add(key);
        this.currentKey = key;
        
        Element nwFragment  =_injectInDOMCloneEmptyElement("${name}NW",  keyJsSafe ) ;
        _displayData("trace-details-title",keyJsSafe,traceDetails.title) ;
        _displayData("trace-details-activities",keyJsSafe,traceDetails.activities) ;
        _displayData("trace-details-description",keyJsSafe,traceDetails.descriptionToRender) ;
        _displayData("trace-details-creator",keyJsSafe,traceDetails.creator) ;
        _displayData("trace-details-lastupdate",keyJsSafe,traceDetails.lastupdate) ;
        nwFragment.classes.remove("gx-hidden") ;
        loadingNW.stopLoading();
        
        
        Element swFragment  =_injectInDOMCloneEmptyElement("${name}SW",  keyJsSafe ) ;
        _displayData("trace-details-lengthKmPart",keyJsSafe,"${traceDetails.lengthKmPart} km") ;
        _displayData("trace-details-lengthMetersPart",keyJsSafe,"${traceDetails.lengthMetersPart} m") ;
        _displayData("trace-details-up",keyJsSafe, "${traceDetails.up} m") ;
        _displayData("trace-details-inclinationUp",keyJsSafe,"${traceDetails.inclinationUp} %") ;
        _displayData("trace-details-upperPointElevetion",keyJsSafe,"${traceDetails.upperPointElevetion} m") ;
        _displayData("trace-details-difficulty",keyJsSafe,"${traceDetails.difficulty} points") ;
        swFragment.classes.remove("gx-hidden") ;
        loadingSW.stopLoading();
        
        _displayMap(traceDetails);
        _displayProfile(traceDetails) ;
        showBySelector("#${name}NE");
        
        

      }
    });
    request.open("GET",  "/j_trace_details/${key}", async: true);
    request.send();      
  }
 
 Element _injectInDOMCloneEmptyElement(String selectorId, String keyJsSafe ){
   Element original = querySelector("#${selectorId}") ;
   Element clone =  original.clone(true) ;
   clone.setAttribute("id", "${selectorId}_${keyJsSafe}") ;
   original.parentNode.append(clone);
   return clone ;
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
 
 void _moveMarkerOnMap(ProfilePoint profilePoint){
   
 }
 
 void _displayMap(TraceDetails traceDetails){
   js.context.traceDetailsMap.addMarkerToMap( traceDetails.keyJsSafe, traceDetails.mainActivity , traceDetails.titleJsSafe, traceDetails.startPointLatitude,traceDetails.startPointLongitude,traceDetails.gpxUrl );
   js.context.traceDetailsMap.viewGpxByKey(traceDetails.keyJsSafe) ;
   js.context.traceDetailsMap.refreshTiles();
   showBySelector("#${name}SE", hiddenClass: "gx-hidden-map");
   loadingSE.stopLoading();
 }
 
 void _displayProfile(TraceDetails traceDetails){
   _profile.show(traceDetails);
 }
 
 void hidePage() {
    String keyJsSafe = _transformJsSafe(currentKey) ;
    hideBySelector("#${name}SE", hiddenClass: "gx-hidden-map");
    hideBySelector("#${name}NE");
    hideBySelector("#${name}NW_${keyJsSafe}");
    hideBySelector("#${name}SW_${keyJsSafe}");
 }
 
 
}





