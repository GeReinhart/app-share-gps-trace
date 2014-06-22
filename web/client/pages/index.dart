import "dart:html";
import '../spaces.dart';
import 'page.dart';
import 'disclaimer.dart';
import 'about.dart';
import 'traceForm.dart';
import 'traceSearch.dart';
import 'traceDetails.dart';
import "../widgets/sharedWidgets.dart" ;
import "../widgets/login.dart" ;
import "../widgets/loading.dart" ;
import '../widgets/persistentMenu.dart' ;
import "../widgets/register.dart" ;
import "../widgets/logout.dart" ;
import '../events.dart' ;
import '../controllers.dart' ;
import '../actions.dart';

class IndexPage extends Page {
  
  IndexPage(PageContext context): super("index",context,50,50,false);
  
  bool canBeLaunched(String login, bool isAdmin ) => true;
  
  bool canBeLaunchedFromMainMenu()=> false;
  
  void initPage() {
    
    layout.centerMoved.listen((_){
      updateNWPostion("#${name}NW");
    });
    
    querySelectorAll(".btn-add").onClick.listen((e) {
      window.location.href = "/#trace_form";
    });
    querySelectorAll(".btn-search").onClick.listen((e) {
      window.location.href = "/#trace_search";
    });    
  }
  
  void showPage( Parameters pageParameters) {
    super.showPage(pageParameters);
    window.location.href = "/#trace_search";
    sendPageChangeEvent(description, "#${name}" ) ;
  }
  
  void hidePage() {
    hideBySelector("#${name}NW");
    hideBySelector("#trace_searchNE");
    hideBySelector("#${name}SW");
    hideBySelector("#trace_searchSE", hiddenClass: "gx-hidden-map");
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
  PagesController pagesController = new PagesController();
  pageContext.pagesController = pagesController ;
  pageContext.userClientController.setLoginLogoutEventCallBack( pagesController.loginLogoutEvent  );
  pageContext.pagesController.setUserActionsChangeEventCallBack(pageContext.layout.center.userActionsChangeEventCallBack);
  
  
  List<Page> pages = new List<Page>();
  pages.add(new IndexPage(pageContext));
  pages.add(new DisclaimerPage(pageContext));
  AboutPage about = new AboutPage(pageContext); 
  pages.add(about);
  pages.add(new TraceSearchPage(pageContext));
  TraceDetailsPage traceDetailsPage = new TraceDetailsPage(pageContext);
  pages.add(traceDetailsPage);
  pages.add(new TraceFormPage(pageContext,traceDetailsPage));
  
  pagesController.init(pages,pageContext);
  
  pageContext.headerWidget.initFeedBacks(about.feedbackEditor);
}

