
import "dart:html";
import "dart:convert";


import 'page.dart';
import "../controllers.dart" ;

import "../spaces.dart";
import "../forms.dart";
import "../widgets/confirm.dart" ;
import "../widgets/profile.dart" ;
import "../widgets/commentEditor.dart" ;
import "../events.dart" ;
import '../actions.dart';

class AboutPage extends Page {

  LoginLogoutEvent _lastLoginLogout;
  CommentEditorWidget _commentEditor;
  
  AboutPage(PageContext context): super("about",context,50,50,false){
    description = "A propos" ;
    layout.centerMoved.listen((_){
      updateNEPostion("#${name}NE");
      updateNWPostion("#${name}NW");
      updateSEPostion("#${name}SE");
      updateSWPostion("#${name}SW");
    });
    _commentEditor = new CommentEditorWidget("feedbackEditor") ;

  }
  
  bool canBeLaunched(String login, bool isAdmin ) => true;
  
  bool canBeLaunchedFromMainMenu()=> false;

  void showPage( Parameters pageParameters) {
    super.showPage(pageParameters);
    header.title = description ;
    organizeSpaces();
    getAndShowElement("/f_about_application", "#${name}NW");
    getAndShowElement("/f_about_dev", "#${name}NE");
    getAndShowElement("/f_about_author", "#${name}SE");
    
    showBySelector( "#${name}SW");
    _initFeedbacks();
    
    sendPageChangeEvent(description, "#${name}" ) ;
  }
  
  void loginLogoutEvent(LoginLogoutEvent event) {
    _lastLoginLogout = event;
    if (event.isLogin){
      showBySelector("#feedbacks-add-comment-btn");
    }
    if(event.isLogout){
      hideBySelector("#feedbacks-add-comment-btn");
    }
  }
   
   void _feedbackEditorEventCallBack(CommentEditorEvent event) {
     if (! event.isCancel ){
        _updateFeedbacks();      
     }
   }
   
   void _initFeedbacks(){
     querySelectorAll("#feedbacks-add-comment-btn").onClick.listen((e){
          showFeedBackEditor() ;
     });
     _commentEditor.setCommentEditorEventCallBack(_feedbackEditorEventCallBack);
     
     loginLogoutEvent(_lastLoginLogout);
     _updateFeedbacks();
   }
   
   void showFeedBackEditor({String commentId: null, String content:null}){
     _commentEditor.showCommentEditorModal("feedback", "feedback",
                                      header:"Retour utilisateur de la-boussole",
                                      placeHolder: "Retour utilisateur",
                                      commentId: commentId, content:content) ;

   }
   
   void _updateFeedbacks() {
   
     HttpRequest request = new HttpRequest();
        
        request.onReadyStateChange.listen((_) {
          
          if (request.readyState == HttpRequest.DONE ) {

            CommentsForm form = new CommentsForm.fromJson(JSON.decode(request.responseText));
            Element commentsElement = querySelector("#feedbacks-comments");
            Element commentElementTemplate = commentsElement.children.first;
            List oldComments = new List();  
            oldComments.addAll(commentsElement.children);
            oldComments.forEach((element){
              if ( element!=commentElementTemplate ){
                element.remove();
              }
            });
            
            form.comments.forEach((comment){
              Element commentElementCurrentRow = commentElementTemplate.clone(true) ;
              commentElementCurrentRow.classes.remove("gx-hidden");
              commentElementCurrentRow.querySelector(".feedbacks-comment-creator").text = comment.creator ;
              commentElementCurrentRow.querySelector(".feedbacks-comment-date").text = comment.lastUpdateDate ;
              commentElementCurrentRow.querySelector(".feedbacks-comment-content").text = comment.content ;
              Element updateElement = commentElementCurrentRow.querySelector(".feedbacks-comment-update");
              if ( _lastLoginLogout!= null && _lastLoginLogout.isLogin &&
                    (_lastLoginLogout.login == comment.creator || _lastLoginLogout.isAdmin)){
                updateElement.onClick.listen((e){
                    showFeedBackEditor(commentId: comment.id, content:comment.content) ;
                });
              }else{
                updateElement.remove();
              }

              commentsElement.nodes.add(commentElementCurrentRow);
            });
            
          }
        });
        request.open("POST",  "/j_comment_select", async: true);
        CommentsForm form = new CommentsForm.empty();
        form.targetKey= "feedback";
        form.targetType= "feedback";
        request.send(JSON.encode(form.toJson()));  
   }
   
   CommentEditorWidget get feedbackEditor => _commentEditor;
}


