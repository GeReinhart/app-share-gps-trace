import "dart:html";
import 'dart:async';
import "dart:convert";
import 'page.dart';
import '../forms.dart';
import '../actions.dart';

class TraceFormPage extends Page {
  
  TraceFormPage(PageContext context): super("trace_form",context,20,80,false){
    description = "Ajout d'une trace" ;
    layout.centerMoved.listen((_){
      updateNWPostion("#${name}NW");
      updateSWPostion("#${name}SW");
    });
  }
  
  
  bool canBeLaunched(String login, bool isAdmin ) => login!= null;
  
  bool canBeLaunchedFromMainMenu()=> true;
  
  void showPage( Parameters pageParameters) {
    super.showPage(pageParameters);
    header.title = description ;
    organizeSpaces();
    getAndShowElement("/f_trace_add_form","#${name}NW", callback:_initEvents);
    showBySelector("#${name}SW");
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
        layout.stopLoading();
        TraceForm traceForm = new TraceForm.fromMap(JSON.decode(request.responseText));
        if( traceForm.isSuccess  ){
          window.location.href = "/#trace_details/${traceForm.key}" ;
        }else{
          _hideDisplayMessage(traceForm) ;
        }
        
      }
    });

    request.open("POST",  "/j_trace_create", async: true);


    final formData = new FormData();
    Map jsonMap = new Map();
    List<String> activities = new List<String>();
    jsonMap["isUpdate"] = false ;
    querySelectorAll(".trace-form-input").forEach((e){
      if(e is SelectElement){
        formData.append(e.name, e.value );
        jsonMap[e.name] = e.value;
      }else if(e is TextAreaElement){
        formData.append(e.name, e.value );
        jsonMap[e.name] = e.value;
      }else if (e is InputElement){
        if (  e.type == "checkbox" ){
          if (e.checked){
            formData.append(e.name, e.checked.toString() );
            if ( e.name.startsWith("activity" )){
              activities.add(e.name);
            }
          }
        }else{
          formData.append(e.name, e.value );
          jsonMap[e.name] = e.value;
        }
      }
    });
    jsonMap["activityKeys"] = activities ;
    
    
    querySelectorAll(".trace-form-file-input").forEach((e){
      if ( e is FileUploadInputElement ){
        FileUploadInputElement fileUploadInputElement = e as FileUploadInputElement ;
        if (fileUploadInputElement.files.isNotEmpty){
          File gpsFile = fileUploadInputElement.files.first;
          jsonMap["gpsFileName"] = gpsFile.name ;
          formData.appendBlob(fileUploadInputElement.name, gpsFile, gpsFile.name);
        }
      }
    });    
    TraceForm traceForm = new TraceForm.fromMap(jsonMap);
    traceForm.validate() ;
    if( traceForm.isSuccess  ){
      layout.startLoading();
      request.send(formData);
    }
    _hideDisplayMessage(traceForm) ;
    
    
  }
  
  bool _hideDisplayMessage(TraceForm traceForm) {
  
    String errorMessageSelector = "#trace-form-error-message";
    
    if(  ! traceForm.isSuccess){
      Element errorMessage = querySelector(errorMessageSelector) ;
   
      switch (traceForm.error) {
        case TRACE_ERROR_TITLE_MIN_LENGTH:
          errorMessage.text = "Le titre de la trace doit être définie" ;
          break;
        case TRACE_ERROR_ACTIVITY_MISSING:
          errorMessage.text = "Une ou plusieurs activitées doivent être définies" ;
          break;
        case TRACE_ERROR_GPS_FILE_MISSING:
          errorMessage.text = "Un fichier representant la trace gps doit être choisi" ;
          break;
        case TRACE_ERROR_GPS_FILE_TOO_BIG:
          errorMessage.text = "Le fichier choisi est trop volumineux" ;
          break;
        case TRACE_ERROR_GPS_FILE_ON_SCAN:
          errorMessage.text = "Impossible de lire le fichier choisi" ;
          break;
      }
      showBySelector(errorMessageSelector) ;
    }else{
      hideBySelector(errorMessageSelector) ;
    }
    
  }
  
  
}

