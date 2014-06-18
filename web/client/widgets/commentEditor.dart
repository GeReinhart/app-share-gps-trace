import "dart:html";
import 'dart:async';
import "dart:convert";

import "widget.dart" ;
import "modal.dart" ;
import "loading.dart" ;
import "../events.dart" ;
import "../spaces.dart";
import "../forms.dart";


typedef void CommentEditorEventCallBack(CommentEditorEvent event);

class CommentEditorEvent{
  bool isCancel ;
  bool _isUpdated ;
  CommentForm _form;
  
  CommentEditorEvent(this._isUpdated, this.isCancel, this._form);
  
  CommentForm get form => _form;
  bool get isCreated => _isUpdated ;
  bool get isDeleted => !_isUpdated ;
}



class CommentEditorWidget extends Widget with ModalWidget {
  
  StreamController<CommentEditorEvent> _commentEditorEventStream ;
  
  String _targetKey;
  String _targetType;
  num _latitude;
  num _longitude;
  
  
  CommentEditorWidget(String id): super(id){
    initModalWidget(id);
    initCommentEditorEventProducer();
    _initRegisterWidget();
  }
  
  
  void initCommentEditorEventProducer(){
    _commentEditorEventStream = new StreamController<CommentEditorEvent>.broadcast( sync: true);
  }
  
  void setCommentEditorEventCallBack( CommentEditorEventCallBack callBack  ){
    _commentEditorEventStream.stream.listen((event) => callBack(event));
  }
  
  void sendCommentEditorEvent(  bool isUpdated , bool isCancel , CommentForm form){
    _commentEditorEventStream.add(  new CommentEditorEvent(isUpdated,isCancel,form)  );
  }
  
  void _initRegisterWidget(){
    querySelector("#${this.id}-btn-submit").onClick.listen((e) {
      _callSaveOrUpdateComment();
    });
    querySelector("#${this.id}-btn-cancel").onClick.listen((e) {
      hideModalWidget(id);
      sendCommentEditorEvent(true,true, null);
    });
  }

  void _callSaveOrUpdateComment(){
      
      startLoading();
      HttpRequest request = new HttpRequest();
      
      request.onReadyStateChange.listen((_) {
        
        if (request.readyState == HttpRequest.DONE ) {

          CommentForm form = new CommentForm.fromJson(JSON.decode(request.responseText));
          var message = querySelector("#${this.id}-error-message");
          stopLoading();
          if (form.isSuccess){
            message.text = "" ;
            hideModalWidget(id);
            sendCommentEditorEvent(true,false, form);
          }else {
            message.text = "Erreur lors de l'enregistrement" ;
            switch (form.error) {
              case COMMENT_CONTENT_ERROR_MIN_LENGTH:
                message.text = "Le commentaire doit avoir plus de contenu" ;
                break;
            }
          }
        }
      });

      request.open("POST",  "/j_comment_create_or_update", async: true);
      
      String content= (querySelector("#${this.id}-content") as TextAreaElement).value ;
      
      CommentForm form = new CommentForm.trace(_targetKey, content);
      request.send(JSON.encode(form.toJson()));      
  }
  

  void showCommentEditorModal(  String targetKey, String _targetType, {String content:""}){
    _targetKey = targetKey ;
    _targetType = _targetType ;
    
    querySelector("#${this.id}-content").text = content ;
    querySelector("#${this.id}-btn-submit").text =  content== null ?  "Ajouter" : "Modifier" ;
    hideBySelector("#${this.id}-btn-delete") ;
    
    showModalWidget(id);
  }
  
  
  
}