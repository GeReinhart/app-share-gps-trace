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
import '../actions.dart';

class SandboxPage extends Page {
  
  
  SandboxPage(PageContext context): super("sandbox",context,50,50,false){
  }

  
  bool canBeLaunched(String login, bool isAdmin ) => true;
  
  bool canBeLaunchedFromMainMenu()=> false;
  

  
 
  
  void showPage( Parameters pageParameters) {
    super.showPage(pageParameters);
    
    querySelectorAll("#btn-async-sumbit").onClick.listen((e) {
      _asyncSubmitForm() ;
    });
    
    organizeSpaces();
  }
  
  
 void _asyncSubmitForm(){
    
    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {

        window.location.href = "/#trace_search" ;
        
      }
    });

    request.open("POST",  "/j_trace_create", async: true);


    final formData = new FormData();
    
    FileUploadInputElement fileUploadInputElement = querySelector("#gpxUploadedFile") as FileUploadInputElement ;
    File gpxFile = fileUploadInputElement.files.first;
    formData.append("title", ( querySelector("#form-title") as InputElement ).value );
    formData.appendBlob("gpxUploadedFile", gpxFile, gpxFile.name);
    request.send(formData);
  }

  

  
}


void main() {
  SandboxPage page = new SandboxPage(new PageContext() );
  page.showPage(null);
}
