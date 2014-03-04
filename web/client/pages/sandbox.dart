import "dart:html";
import "dart:convert";
import "dart:async" ;
import 'package:js/js.dart' as js;

import '../spaces.dart';
import "../forms.dart";

import 'page.dart';
import "../widgets/profile.dart" ;
import "../widgets/login.dart" ;
import "../widgets/persistentMenu.dart" ;
import "../events.dart" ;
import "../controllers.dart" ;

class SandboxPage extends Page {
  
  
  Map<String,TraceDetails> traceDetailsByKey = new Map<String,TraceDetails>();
  ProfileWidget profile ;
  
  
  SandboxPage(PageContext context): super("sandbox",context,50,50,false){
    profile = new ProfileWidget("profile") ;
    
    layout.centerMoved.listen((_){
      _updateWidgetsPositions();
    });
  }

  void _updateWidgetsPositions(){
    SpacesPositions positions = layout.postions;
    profile.updatePosition(positions.spaceNE_Top.toInt(),
                           positions.spaceNE_Right.toInt(), 
                           positions.spaceNE_Width.toInt(),
                           positions.spaceNE_Height.toInt());
  }
  
  void showPage( PageParameters pageParameters) {
    
    querySelectorAll("#btn-draw1").onClick.listen((e) {
      showProfile("user1/gsadg_dgsdg") ;
    });
    querySelectorAll("#btn-reset").onClick.listen((e) {
      profile.reset();
    }); 
    querySelectorAll("btn-draw2").onClick.listen((e) {
      showProfile("user1/jhjhg");
    }); 
    
    organizeSpaces();
    _updateWidgetsPositions();
  }
  
  void showProfile(String key){
    
    if (traceDetailsByKey.containsKey(key)){
      profile.show(traceDetailsByKey[key]);
    }
    
    HttpRequest request = new HttpRequest();
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {
        TraceDetails traceDetails = new TraceDetails.fromMap(JSON.decode(request.responseText));
        traceDetailsByKey[key] = traceDetails;
        profile.show(traceDetails);
      }
    });
    request.open("GET",  "/j_trace_details/${key}", async: true);
    request.send(); 
    
    
    
  }
  

  
}


void main() {
  SandboxPage page = new SandboxPage(new PageContext() );
  page.showPage(null);
}
