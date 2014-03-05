import "dart:html";
import "dart:convert";
import "dart:async" ;
import 'package:js/js.dart' as js;
import 'dart:math';
import '../spaces.dart';
import "../forms.dart";

import 'page.dart';
import "../widgets/profile.dart" ;
import "../widgets/login.dart" ;
import "../widgets/persistentMenu.dart" ;
import "../events.dart" ;
import "../controllers.dart" ;

class SandboxPage extends Page {
  
  List<String> keys = new List<String>();
  Map<String,TraceDetails> traceDetailsByKey = new Map<String,TraceDetails>();
  ProfileWidget profile ;
  Random rng = new Random();
  
  SandboxPage(PageContext context): super("sandbox",context,50,50,false){
    profile = new ProfileWidget("profile") ;
    getKeys();
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
  
  
  void getKeys(){
    HttpRequest request = new HttpRequest();
  
    layout.startLoading();
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE ) {
        SearchForm form = new SearchForm.fromMap(JSON.decode(request.responseText));
        form.results.forEach((lightTrace){
          keys.add(lightTrace.key);
        });
        layout.stopLoading();
      }
    });
    request.open("POST",  "/j_trace_search", async: true);
    SearchForm form = new SearchForm();
    request.send(JSON.encode(form.toJson()));
  }
  
  void showPage( PageParameters pageParameters) {
    
    querySelectorAll("#btn-draw1").onClick.listen((e) {
      showProfile(keys[rng.nextInt(  keys.length )]) ;
    });
    querySelectorAll("#btn-reset").onClick.listen((e) {
      profile.reset();
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
