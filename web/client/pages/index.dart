import "dart:html";
import '../spaces.dart';
import 'page.dart';
import 'disclaimer.dart';
import 'about.dart';
import 'traceForm.dart';
import 'traceSearch.dart';
import "../widgets/sharedWidgets.dart" ;
import "../widgets/login.dart" ;
import "../widgets/loading.dart" ;
import '../widgets/persistentMenu.dart' ;
import "../widgets/register.dart" ;
import "../widgets/logout.dart" ;
import '../events.dart' ;
import '../controllers.dart' ;


class IndexPage extends Page {
  
  IndexPage(PageContext context): super("index",context,50,50,false){
   initPage();
  }
  
  void initPage() {
    
    querySelectorAll(".btn-add").onClick.listen((e) {
      window.location.href = "/#trace_form";
    });
    querySelectorAll(".btn-search").onClick.listen((e) {
      window.location.href = "/#trace_search";
    });    
  }
  
  void showPage() {
    organizeSpaces();
    showBySelector( "#trace_searchNE");
    getAndShowElement("/f_index_text", "#${name}NW");
    showBySelector( "#${name}SW");
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
  PageContext pageContext = new PageContext();
  List<Page> pages = new List<Page>();
  pages.add(new IndexPage(pageContext));
  pages.add(new DisclaimerPage(pageContext));  
  pages.add(new AboutPage(pageContext));
  pages.add(new TraceFormPage(pageContext));
  pages.add(new TraceSearchPage(pageContext));
  PagesController pagesController = new PagesController(pages);
}

