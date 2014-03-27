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
  bool _isCreated ;
  WatchPointForm _form;
  
  WatchPointEditorEvent(this._isCreated, this.isCancel, this._form);
  
  WatchPointForm get form => _form;
  bool get isCreated => _isCreated ;
  bool get isDeleted => !_isCreated ;
}



class WatchPointEditorWidget extends Widget with ModalWidget {
  
  StreamController<WatchPointEditorEvent> _watchPointEditorEventStream ;
  
  String _traceKey;
  num _latitude;
  num _longitude;
  
  
  WatchPointEditorWidget(String id): super(id){
    initModalWidget();
    initWatchPointEditorEventProducer();
    _initRegisterWidget();
  }
  
  
  void initWatchPointEditorEventProducer(){
    _watchPointEditorEventStream = new StreamController<WatchPointEditorEvent>.broadcast( sync: true);
  }
  
  void setWatchPointEditorEventCallBack( WatchPointEditorEventCallBack callBack  ){
    _watchPointEditorEventStream.stream.listen((event) => callBack(event));
  }
  
  void sendWatchPointEditorEvent(  bool isCreated , bool isCancel , WatchPointForm form){
    _watchPointEditorEventStream.add(  new WatchPointEditorEvent(isCreated,isCancel,form)  );
  }
  
  void _initRegisterWidget(){
    querySelector("#${this.id}-btn-submit").onClick.listen((e) {
      _callAddWatchPoint();
    });
    querySelector("#${this.id}-btn-cancel").onClick.listen((e) {
      hideModalWidget(id);
      sendWatchPointEditorEvent(true,true, null);
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
            hideModalWidget(id);
            sendWatchPointEditorEvent(true,false, form);
          }else {
 
            
          }
        }
      });

      request.open("POST",  "/j_watch_point_create", async: true);
      
      String name= (querySelector("#${this.id}-name") as InputElement).value ;
      String description= (querySelector("#${this.id}-description") as TextAreaElement).value ;
      String type= (querySelector("#${this.id}-type") as SelectElement).value ;
      
      WatchPointForm form = new WatchPointForm(name, description, type, _latitude, _longitude);
      form.traceKey = _traceKey ;
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
    
    showModalWidget(id);
  }
  
}