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
  bool _isCreated ;
  WatchPointForm _form;
  
  WatchPointEditorEvent(this._isCreated, this._form);
  
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
  
  void sendWatchPointEditorEvent(  bool isCreated , WatchPointForm form){
    _watchPointEditorEventStream.add(  new WatchPointEditorEvent(isCreated,form)  );
  }
  
  void _initRegisterWidget(){
    querySelector("#${this.id}-btn-submit").onClick.listen((e) {
      _callAddWatchPoint();
    });
    querySelector("#${this.id}-btn-cancel").onClick.listen((e) {
      hideModalWidget(id);
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
            sendWatchPointEditorEvent(true, form);
          }else {
 
            
          }
        }
      });

      request.open("POST",  "/j_watch_point_create", async: true);
      RegisterForm form =  new  RegisterForm( (querySelector("#${this.id}-login") as InputElement).value,
          (querySelector("#${this.id}-password") as InputElement).value,
          (querySelector("#${this.id}-password-confirm") as InputElement).value);
      request.send(JSON.encode(form.toJson()));      
  }
  
  void showWatchPointEditorModal(  String traceKey, num latitude,  num longitude){
    _traceKey = traceKey ;
    _latitude = latitude ;
    _longitude = longitude;
    
    querySelector("#${this.id}-name").text = "" ;
    querySelector("#${this.id}-description").text = "" ;
    querySelector("#${this.id}-latitude").text = latitude.toString() ;
    querySelector("#${this.id}-longitude").text = longitude.toString() ;
    
    showModalWidget(id);
  }
  
}