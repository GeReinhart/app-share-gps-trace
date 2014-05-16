import "dart:html";
import 'dart:async';
import "dart:convert";
import 'page.dart';
import 'traceDetails.dart';
import '../forms.dart';
import '../widgets/watchPointEditor.dart';
import '../widgets/uploadFile.dart';
import '../actions.dart';
import 'package:js/js.dart' as js;

class TraceFormPage extends Page {
  
  String _currentKey ;
  WatchPointEditorWidget _watchPointEditorWidget ;
  UploadFileWidget _gpsUploadFileWidget;
  TraceDetailsPage _traceDetailsPage ;
  
  TraceFormPage(PageContext context, TraceDetailsPage traceDetailsPage): super("trace_form",context,50,50,false){
    description = "Ajout d'une trace" ;
    actionImages =  new ActionImages("assets/img/trace_add.png", imageOver: "assets/img/trace_add_blue.png") ;
    this._traceDetailsPage = traceDetailsPage;
  }
  
  bool isUpdate(){
    return _currentKey != null;
  }
  
  void initPage(){
    super.initPage();
    _watchPointEditorWidget = new WatchPointEditorWidget("watchPointEditor");
    _watchPointEditorWidget.setWatchPointEditorEventCallBack(this.watchPointEditorEventCallBack);
    
    HtmlDocument document = js.context.document;
    document.on['right_click_on_map'].listen((e ){
      if ( active && this.isUpdate()){
          js.context.traceDetailsMap.drawRightClickMark();
          var latLng = js.context.traceDetailsMap.lastRightClickMarker.getLatLng();
          _watchPointEditorWidget.showWatchPointEditorModal( _currentKey, latLng.lat, latLng.lng) ;
      }
    });
    document.on['right_click_on_marker'].listen((e ){
      if ( active &&  this.isUpdate()){
          var latLng = js.context.traceDetailsMap.lastRightClickOnMarker.latlng;
          _watchPointEditorWidget.showWatchPointEditorModal( _currentKey, latLng.lat, latLng.lng) ;
      }
    });
  
  }

  
  bool canShowPage(Parameters pageParameters){
    if ( pageParameters.pageName == this.name){
      return true;
    };
    if(pageParameters.pageName.startsWith(this.name) && _extractKey(pageParameters.pageName) != null ){
      return true;
    }
    if(pageParameters.pageName.startsWith("trace_update") ){
      return true; 
    }
    return false ;
  }
  
  String _extractKey(String pageName) {
    List<String> elements = pageName.split("/");
    if (  elements.length != 3 ){
      return null;
    }else{
      return "${elements[1]}/${elements[2]}" ; 
    }
  }
  
  
  bool canBeLaunched(String login, bool isAdmin ) => login!= null;
  
  bool canBeLaunchedFromMainMenu()=> true;
  
  void showPage( Parameters pageParameters) {
    super.showPage(pageParameters);
    _currentKey = _extractKey(pageParameters.pageName); 
    getAndShowElement("/f_trace_form","#${name}NW", callback:_initEvents, show:false);
    if ( _currentKey == null ){
      querySelector("#trace-form-submit").text = "Ajouter cette trace" ;
      header.title = "Ajout d'une trace" ;
      layout.organizeSpaces(20,80,showWestSpace:false );
      showBySelector(".trace-form-file-input");
      showBySelector(".trace-form-file-smoothing");
      showBySelector("#${name}SW");
      showBySelector("#${name}NW");
      hideBySelector("#trace-form-update-message");
      
      hideBySelector("#trace_detailsNE");
      hideBySelector("#trace_detailsSE", hiddenClass: "gx-hidden-map");
      
    }else{
      layout.organizeSpaces(50,50,showWestSpace:false );
      showBySelector("#trace-form-update-message");
      _loadForm(_currentKey) ;
    }
    sendPageChangeEvent(description, "#${name}" ) ;
  }
  
  void hidePage() {
    active = false;
    hideBySelector("#${name}NW");
    hideBySelector("#trace_detailsNE");
    hideBySelector("#trace_detailsNW");
    hideBySelector("#trace_detailsSW");
    hideBySelector("#${name}SW");
    hideBySelector("#trace_detailsSE", hiddenClass: "gx-hidden-map");
    js.context.traceDetailsMap.hideRightClickMark();
  }  
  
  void _initEvents(){
    querySelector("#trace-form-submit").onClick.listen((e){
      _asyncSubmitForm();
    });
    _gpsUploadFileWidget= new UploadFileWidget("uploadGpsFile");
    hideBySelector("#uploadGpsFile-info");
  }
  
 void _loadForm(String key){
    
    HttpRequest request = new HttpRequest();
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {
        TraceDetails traceDetails = new TraceDetails.fromMap(JSON.decode(request.responseText));
        if (traceDetails.key != null){
          header.title = "Modification de " + traceDetails.title ;
          querySelector("#trace-form-submit").text = "Modifier le topo" ;
          
          InputElement titleElement = querySelector(".trace-form-input[name=title]") as InputElement ;
          titleElement.value = traceDetails.title;
  
          TextAreaElement descriptionElement = querySelector(".trace-form-input[name=description]") as TextAreaElement ;
          descriptionElement.value = traceDetails.description;        
          if (traceDetails.activityKeys != null){
            traceDetails.activityKeys.forEach((activityKey){
              InputElement activityCheck = querySelector(".trace-form-input[name=activity-${activityKey}]") as InputElement ;
              if (activityCheck != null){
                activityCheck.checked = true;
              }
            });
          }
        }      
        organizeSpaces();
        hideBySelector(".trace-form-file-input");
        hideBySelector(".trace-form-file-smoothing");
        showBySelector("#${name}SW");
        showBySelector("#${name}NW");
        showBySelector("#trace_detailsNE");
        showBySelector("#trace_detailsSE", hiddenClass: "gx-hidden-map");        

      }
    });
    request.open("GET",  "/j_trace_details/${key}", async: true);
    request.send();      
  }
  
  
  void _asyncSubmitForm(){
    
    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {
        layout.stopLoading();
        TraceForm traceForm = new TraceForm.fromMap(JSON.decode(request.responseText));
        if( traceForm.isSuccess  ){
          context.pagesController.fireTraceChangeEvent(traceForm.key);
          _traceDetailsPage.showPageByKey(traceForm.key, true, needToSendPageChangeEvent:false);
          window.location.href = "/#trace_update/${traceForm.key}" ;
        }else{
          _hideDisplayMessage(traceForm) ;
        }
        
      }
    });

    request.open("POST",  "/j_trace_create_or_update", async: true);


    final formData = new FormData();
    Map jsonMap = new Map();
    List<String> activities = new List<String>();
    jsonMap["_isUpdate"] =  _currentKey != null ? "true" : "false" ;
    formData.append("isUpdate", _currentKey != null ? "true" : "false" ) ;
    formData.append("key", _currentKey) ;
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
    
    
    FileUploadInputElement fileUploadInputElement = querySelector("#uploadGpsFile-input") as FileUploadInputElement ;
    if (fileUploadInputElement.files.isNotEmpty){
        File gpsFile = fileUploadInputElement.files.first;
        jsonMap["gpsFileName"] = gpsFile.name ;
        jsonMap["gpsFileSizeInBytes"] = gpsFile.size ;
        formData.appendBlob("gps-file", gpsFile, gpsFile.name);
    }
        
    TraceForm traceForm = new TraceForm.fromMap(jsonMap);
    
    traceForm.validate() ;
    if( traceForm.isSuccess  ){
      layout.startLoading();
      request.send(formData);
    }
    _hideDisplayMessage(traceForm) ;
    
    
  }
  
  void _hideDisplayMessage(TraceForm traceForm) {
  
    String errorMessageSelector = "#trace-form-error-message";
    
    if(  ! traceForm.isSuccess){
      Element errorMessage = querySelector(errorMessageSelector) ;
      errorMessage.text = "Erreur inconnue coté serveur, la trace n'est pas ajoutée" ;
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
  
  
  void watchPointEditorEventCallBack(WatchPointEditorEvent event){
    if(!event.isCancel && event.form.isSuccess){
      js.context.traceDetailsMap.removeCurrentMarker();
      context.pagesController.fireTraceChangeEvent(event.form.traceKey);
    }
    js.context.traceDetailsMap.hideRightClickMark();
  }
  
}

