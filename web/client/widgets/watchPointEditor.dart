import "dart:html";
import 'dart:async';
import "dart:convert";

import "widget.dart" ;
import "modal.dart" ;
import "loading.dart" ;
import "../events.dart" ;
import "../spaces.dart";
import "../forms.dart";


typedef void WatchPointEditorEventCallBack(WatchPointEditorEvent event);

class WatchPointEditorEvent{
  bool isCancel ;
  bool _isUpdated ;
  WatchPointForm _form;
  
  WatchPointEditorEvent(this._isUpdated, this.isCancel, this._form);
  
  WatchPointForm get form => _form;
  bool get isCreated => _isUpdated ;
  bool get isDeleted => !_isUpdated ;
}



class WatchPointEditorWidget extends Widget with ModalWidget {
  
  StreamController<WatchPointEditorEvent> _watchPointEditorEventStream ;
  
  String _traceKey;
  num _latitude;
  num _longitude;
  
  
  WatchPointEditorWidget(String id): super(id){
    initModalWidget(id);
    initWatchPointEditorEventProducer();
    _initRegisterWidget();
  }
  
  
  void initWatchPointEditorEventProducer(){
    _watchPointEditorEventStream = new StreamController<WatchPointEditorEvent>.broadcast( sync: true);
  }
  
  void setWatchPointEditorEventCallBack( WatchPointEditorEventCallBack callBack  ){
    _watchPointEditorEventStream.stream.listen((event) => callBack(event));
  }
  
  void sendWatchPointEditorEvent(  bool isUpdated , bool isCancel , WatchPointForm form){
    _watchPointEditorEventStream.add(  new WatchPointEditorEvent(isUpdated,isCancel,form)  );
  }
  
  void _initRegisterWidget(){
    querySelector("#${this.id}-btn-submit").onClick.listen((e) {
      _callAddWatchPoint();
    });
    querySelector("#${this.id}-btn-cancel").onClick.listen((e) {
      hideModalWidget(id);
      sendWatchPointEditorEvent(true,true, null);
    });
    querySelector("#${this.id}-btn-delete").onClick.listen((e) {
      _callDeleteWatchPoint();
    });
  }

  void _callAddWatchPoint(){
      
      startLoading();
      HttpRequest request = new HttpRequest();
      
      request.onReadyStateChange.listen((_) {
        
        if (request.readyState == HttpRequest.DONE ) {

          WatchPointForm form = new WatchPointForm.fromJson(JSON.decode(request.responseText));
          var message = querySelector("#${this.id}-error-message");
          stopLoading();
          if (form.isSuccess){
            message.text = "" ;
            hideModalWidget(id);
            sendWatchPointEditorEvent(true,false, form);
          }else {
            message.text = "Erreur lors de l'enregistrement" ;
            switch (form.error) {
              case WATCH_POINT_ERROR_NAME_MIN_LENGTH:
                message.text = "Un nom doit être défini" ;
                break;
            }
          }
        }
      });

      request.open("POST",  "/j_watch_point_create_or_update", async: true);
      
      String name= (querySelector("#${this.id}-name") as InputElement).value ;
      String description= (querySelector("#${this.id}-description") as TextAreaElement).value ;
      String type= (querySelector("#${this.id}-type") as SelectElement).value ;
      
      WatchPointForm form = new WatchPointForm(name, description, type, _latitude, _longitude);
      form.traceKey = _traceKey ;
      request.send(JSON.encode(form.toJson()));      
  }
  
  void _callDeleteWatchPoint(){
      
      startLoading();
      HttpRequest request = new HttpRequest();
      
      request.onReadyStateChange.listen((_) {
        
        if (request.readyState == HttpRequest.DONE ) {

          WatchPointForm form = new WatchPointForm.fromJson(JSON.decode(request.responseText));
          var message = querySelector("#${this.id}-error-message");
          stopLoading();
          if (form.isSuccess){
            message.text = "" ;
            hideModalWidget(id);
            sendWatchPointEditorEvent(true,false, form);
          }else {
            message.text = "Erreur lors de la suppression" ;
          }
        }
      });

      request.open("POST",  "/j_watch_point_delete", async: true);
      WatchPointForm form = new WatchPointForm.empty();
      form.traceKey = _traceKey ;
      form.latitude = _latitude ;
      form.longitude = _longitude ;
      request.send(JSON.encode(form.toJson()));      
  }
  
  void showWatchPointEditorModal(  String traceKey, num latitude,  num longitude){
    _traceKey = traceKey ;
    _latitude = latitude ;
    _longitude = longitude;
    
    (querySelector("#${this.id}-name") as InputElement).value = "";
    (querySelector("#${this.id}-description") as TextAreaElement).value = "" ;
    querySelector("#${this.id}-latitude").text = latitude.toString() ;
    querySelector("#${this.id}-longitude").text = longitude.toString() ;
    querySelector("#${this.id}-error-message").text = "";
    querySelector("#${this.id}-btn-submit").text = "Ajouter" ;
    hideBySelector("#${this.id}-btn-delete") ;
    
    _getWatchPoint( traceKey,  latitude,  longitude) ;
    showModalWidget(id);
  }
  
  void _getWatchPoint(String traceKey, num latitude,  num longitude){
    
     HttpRequest request = new HttpRequest();
     
     request.onReadyStateChange.listen((_) {
       
       if (request.readyState == HttpRequest.DONE ) {

         WatchPointForm form = new WatchPointForm.fromJson(JSON.decode(request.responseText));
         if (form.isSuccess){
           (querySelector("#${this.id}-name") as InputElement).value = form.name;
           (querySelector("#${this.id}-description") as TextAreaElement).value = form.description ;
           (querySelector("#${this.id}-type") as SelectElement).value = form.type;
           querySelector("#${this.id}-btn-submit").text = "Modifier" ;
           showBySelector("#${this.id}-btn-delete") ;
         }
       }
     });

     request.open("POST",  "/j_watch_point_select", async: true);
     
     WatchPointForm form = new WatchPointForm.empty();
     form.traceKey = traceKey ;
     form.latitude = latitude ;
     form.longitude = longitude ;
     request.send(JSON.encode(form.toJson()));    
  }
  
  
}