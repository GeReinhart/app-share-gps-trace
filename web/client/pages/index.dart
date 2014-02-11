import "dart:html";
import '../spaces.dart';
import 'page.dart';
import 'disclaimer.dart';
import 'about.dart';
import '../widgets/login.dart' ;
import '../widgets/persistentMenu.dart' ;
import '../events.dart' ;
import '../controllers.dart' ;


class IndexPage extends Page {
  
  IndexPage(): super("index",180,30,70){

    querySelectorAll(".btn-add").onClick.listen((e) {
      window.location.href = "/trace.add";
    });
    querySelectorAll(".btn-search").onClick.listen((e) {
      window.location.href = "/trace.search";
    });
    
  }
  
  void showPage() {
    layout.moveCenterInitialPosition();
    loadingNW.startLoading();
    showBySelector("#${name}NW");
    loadingNW.stopLoading();

    loadingSW.startLoading();
    showBySelector("#${name}SW");
    loadingSW.stopLoading();
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
  List<Page> pages = new List<Page>();
  pages.add(new IndexPage());
  pages.add(new DisclaimerPage());  
  pages.add(new AboutPage());
  PagesController pagesController = new PagesController(pages);
}

