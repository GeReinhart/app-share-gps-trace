import "dart:html";
import 'dart:async';

import "widget.dart" ;
import "modal.dart" ;
import "../events.dart" ;

class ConfirmWidget extends Widget with ModalWidget, OKCancelEventProducer {
  
  StreamController _eventStream ;

  
  ConfirmWidget(String id,  OkCancelCallBack callBack  ): super(id){
    initModalWidget(id);
    initOKCancelEventProducer();
    _initConfirmWidget(callBack);
  }
  
  void _initConfirmWidget(OkCancelCallBack callBack){
    setOKCancelEventCallBack(callBack);
    querySelector("#${this.id}-btn-ok").onClick.listen((e) {
      hideModalWidget(id);
      sendOKEvent();
    });
    querySelector("#${this.id}-btn-cancel").onClick.listen((e) {
      hideModalWidget(id);
      sendCancelEvent();
    });
  }
  
  void showConfirmModal(){
    showModalWidget(id);
  }
  
  void set confirmTitle (String title){
    querySelector("#${this.id}-title").setInnerHtml(title) ;
  }

  void set confirmText (String text){
    querySelector("#${this.id}-text").setInnerHtml(text) ;
  }
}