import "dart:html";
import 'dart:async';
import "dart:convert";
import 'page.dart';
import '../forms.dart';
import '../actions.dart';

class TraceFormPage extends Page {
  
  TraceFormPage(PageContext context): super("trace_form",context,20,80,false){
    description = "Ajout d'une trace gpx" ;
    layout.centerMoved.listen((_){
      updateNWPostion("#${name}NW");
    });
  }
  
  
  bool canBeLaunched(String login, bool isAdmin ) => login!= null;
  
  bool canBeLaunchedFromMainMenu()=> true;
  
  void showPage( Parameters pageParameters) {
    super.showPage(pageParameters);
    header.title = description ;
    organizeSpaces();
    getAndShowElement("/f_trace_add_form","#${name}NW", callback:_initEvents);
    
  }
  
  void _initEvents(){
    querySelector("#trace-form-submit").onClick.listen((e){
      _asyncSubmitForm();
    });
  }
  
  void _asyncSubmitForm(){
    
    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {

        TraceForm form = new TraceForm.fromMap(JSON.decode(request.responseText));
        if( form.isSuccess  ){
          window.location.href = "/#trace_details/${form.key}" ;
        }else{
          window.location.href = "/#trace_search" ;
        }
        
      }
    });

    request.open("POST",  "/j_trace_create", async: true);


    final formData = new FormData();

    querySelectorAll(".trace-form-input").forEach((e){
      if(e is SelectElement){
        formData.append(e.name, e.value );
      }else if(e is TextAreaElement){
        formData.append(e.name, e.value );
      }else if (e is InputElement){
        if (  e.type == "checkbox" ){
          if (e.checked){
            formData.append(e.name, e.checked.toString() );
          }
        }else{
          formData.append(e.name, e.value );
        }
      }
    });
    querySelectorAll(".trace-form-file-input").forEach((e){
      if ( e is FileUploadInputElement ){
        FileUploadInputElement fileUploadInputElement = e as FileUploadInputElement ;
        if (fileUploadInputElement.files.isNotEmpty){
          File gpsFile = fileUploadInputElement.files.first;
          formData.appendBlob(fileUploadInputElement.name, gpsFile, gpsFile.name);
        }
      }
    });    
    
    
    request.send(formData);
  }
  
}

