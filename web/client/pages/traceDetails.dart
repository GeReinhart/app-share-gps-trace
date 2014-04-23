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
import '../actions.dart';


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
      SpacesPositions positions = _ as SpacesPositions ;
      updateNWPostion(".${name}NW");
      updateNWPostion(".trace-details-text");
      querySelectorAll(".trace-details-statistics ").forEach((e){
        e.style.width = "${positions.spaceNW_Width}px" ;   
      });
      
      _moveMap(positions);
      moveTraceViewers(positions);
    });

    _profile.profilePointSelection.listen((p){
      if (currentKey != null){
        js.context.traceDetailsMap.moveMarker(traceDetailsByKey[currentKey].keyJsSafe,p.latitude,p.longitude);
      }
    });
    
    context.pagesController.setTraceChangeEventCallBack(traceChangeCallBack);
    
  }
  
  
  bool canBeLaunched(String login, bool isAdmin ) => true;
  
  bool canBeLaunchedFromMainMenu()=> false;
  
  List<ActionDescriptor> getActionsFor(String login, bool isAdmin){
    List<ActionDescriptor> actions = new List<ActionDescriptor>();
    if (currentKey == null){
      return actions ;
    }
    String creator = _creatorFromKey(currentKey) ;
    
    ActionDescriptor download = new ActionDescriptor();
    download.name = "Téléchargement";
    download.description =  "Téléchargement du fichier gpx";
    download.windowTarget = "_blank" ;
    download.nextPage = "/trace.gpx/${currentKey}"; 
    actions.add(download);
    
    if ( isAdmin ||  login != null &&  creator == login  ){
      ActionDescriptor update = new ActionDescriptor();
      update.name = "Modifier";
      update.description =  "Modifier la trace";
      update.nextPage = "/#trace_form/${currentKey}"; 
      actions.add(update);
      
      ActionDescriptor delete = new ActionDescriptor();
      delete.name = "Supprimer";
      delete.description =  "Supprimer la trace";
      delete.launchAction = (params) =>  _deleteConfirm.showConfirmModal(); 
      actions.add(delete);    
    
    }

    return actions;
  }
  
  void traceChangeCallBack(TraceChangeEvent event){
    traceDetailsByKey.remove(event.key) ;
    keys.remove(event.key);
    if (event.key == currentKey ){
      _showPage(currentKey,true);
    }
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
    
    DeleteTraceForm form =  new  DeleteTraceForm( currentKey );
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
    _profile.updatePosition(0,0, 
        positions.spaceNE_Width.toInt(),
        positions.spaceNE_Height.toInt());
  }
  
  void moveTraceViewers(SpacesPositions spacesPositions ){

    _moveProfile( spacesPositions);
    Element traceProfileViewer = querySelector("#traceProfileViewer") ;
    if (traceProfileViewer != null && currentKey != null){
      _displayProfile(traceDetailsByKey[currentKey]) ;
    }

    
  }

  bool canShowPage(Parameters pageParameters){
    if (pageParameters.pageName == null){
      return false;
    }
    return pageParameters.pageName.startsWith("trace_details") ;
  }

  void showPage( Parameters pageParameters) {
    super.showPage(pageParameters);
    organizeSpaces();
    _moveMap(layout.postions);
    
    String key = pageParameters.pageName.substring( "trace_details_".length  ) ;
    String keyJsSafe = _transformJsSafe(key) ;
    this.currentKey = key;
    
    if(   keys.contains(key)    ){
      TraceDetails traceDetails = traceDetailsByKey[key];
      header.title = traceDetails.title ;
      showBySelector( "#${name}NW_${keyJsSafe}");
      showBySelector( "#${name}SW_${keyJsSafe}");
      _displayProfile( traceDetails );
      showBySelector("#${name}NE");
      _displayMap( traceDetails );
      _updateDeleteConfirmText( traceDetails);
    }else{
      _showPage( key,false);       
    }
  }
 
  void _updateDeleteConfirmText(TraceDetails traceDetails){
    _deleteConfirm.confirmTitle = "Supprimer" ;
    _deleteConfirm.confirmText = "Je confirme la suppression définitive de la trace ${traceDetails.title}" ;
  }
  
 String _creatorFromKey(String key){
   return  key.substring(0, key.indexOf("/") );
 }
  
 String _transformJsSafe(String input){
   return input.replaceAll("/", "_").replaceAll("'", "-");
 }
  
 
 void _showPage(String key, bool onlyRefreshContent){
    
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
        
        header.title = traceDetails.title ;
        
        Element nwFragment  =_injectInDOMCloneEmptyElement("${name}NW",  keyJsSafe ) ;
        _displayData("trace-details-title",keyJsSafe,traceDetails.title) ;
        _displayData("trace-details-activities",keyJsSafe,traceDetails.activities) ;
        _displayData("trace-details-description",keyJsSafe,traceDetails.descriptionToRender) ;
        _displayData("trace-details-creator",keyJsSafe,traceDetails.creator) ;
        _displayData("trace-details-lastupdate",keyJsSafe,traceDetails.lastupdate) ;
        _displayData("trace-details-lengthKmPart",keyJsSafe,"${traceDetails.lengthKmPart} km") ;
        _displayData("trace-details-lengthMetersPart",keyJsSafe,"${traceDetails.lengthMetersPart} m") ;
        _displayData("trace-details-up",keyJsSafe, "${traceDetails.up} m") ;
        _displayData("trace-details-upperPointElevetion",keyJsSafe,"${traceDetails.upperPointElevetion} m") ;
        nwFragment.classes.remove("gx-hidden") ;
        loadingNW.stopLoading();
        
        
        Element swFragment  =_injectInDOMCloneEmptyElement("${name}SW",  keyJsSafe ) ;
        swFragment.classes.remove("gx-hidden") ;
        loadingSW.stopLoading();
        
        _displayMap(traceDetails);
        _displayProfile(traceDetails) ;
        _updateDeleteConfirmText( traceDetails);
        if(!onlyRefreshContent){
          showBySelector("#${name}NE");
        }
        
        

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
 
   js.context.traceDetailsMap.addOtherMarkerToMap(traceDetails.keyJsSafe, "end", "Arrivée","", traceDetails.endPointLatitude,traceDetails.endPointLongitude);
   js.context.traceDetailsMap.addOtherMarkerToMap(traceDetails.keyJsSafe, "start", "Départ","", traceDetails.startPointLatitude,traceDetails.startPointLongitude);

   if (traceDetails.watchPoints != null){
     traceDetails.watchPoints.forEach( (wp){
       js.context.traceDetailsMap.addOtherMarkerToMap(traceDetails.keyJsSafe, wp.type, wp.name, wp.description, wp.latitude, wp.longitude);
     });
   }
   
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





