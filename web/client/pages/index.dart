import "dart:html";
import '../spaces.dart';
import 'page.dart';
import '../widgets/login.dart' ;
import '../widgets/persistentMenu.dart' ;
import '../events.dart' ;
import '../controllers.dart' ;


class IndexPage extends Page {
  
  IndexPage(): super(180,30,70){

    querySelectorAll(".btn-add").onClick.listen((e) {
      window.location.href = "/trace.add";
    });
    querySelectorAll(".btn-search").onClick.listen((e) {
      window.location.href = "/trace.search";
    });
    
  }
  
  
  void loginLogoutEvent(LoginLogoutEvent event){
    super.loginLogoutEvent(event);
    if ( event.isLogin   ){
      hideBySelector("#index-btn-when-anonymous");
      showBySelector("#index-btn-when-logged");
    }else{
      showBySelector("#index-btn-when-anonymous");
      hideBySelector("#index-btn-when-logged");      
    }
  }
  
  
  
}

void main() {
  IndexPage page = new IndexPage();
}

