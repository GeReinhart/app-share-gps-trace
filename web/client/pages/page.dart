
import "dart:html";
import '../spaces.dart';
import "../widgets/sharedWidgets.dart" ;
import "../widgets/login.dart" ;
import "../widgets/loading.dart" ;
import "../widgets/header.dart" ;
import "../widgets/register.dart" ;
import "../widgets/logout.dart" ;
import "../widgets/persistentMenu.dart" ;
import "../events.dart" ;
import "../actions.dart" ;
import "../controllers.dart" ;
import "../models.dart" ;

typedef void FragmentLoadedCallBack();

class PageContext {
  
  
  UserClientController userClientController ;
  PagesController _pagesController;
  SpacesLayout layout ;
  SharedWidgets sharedWidgets;
  LoginWidget loginModal ;
  RegisterWidget registerModal ;
  HeaderWidget headerWidget ;
  LogoutWidget logoutWidget ;
  LoadingWidget loadingNW ;
  LoadingWidget loadingNE ;
  LoadingWidget loadingSW ;
  LoadingWidget loadingSE ;
  
  
  PageContext (){
    loadingNW = new LoadingWidget("loadingNW");
    loadingNE = new LoadingWidget("loadingNE");
    loadingSW = new LoadingWidget("loadingSW");
    loadingSE = new LoadingWidget("loadingSE");
    
    sharedWidgets = new SharedWidgets("sharedWidgets");
    loginModal = new LoginWidget("loginModal");
    registerModal = new RegisterWidget("registerModal");
    logoutWidget = new LogoutWidget("logout" );
    
    userClientController = new UserClientController(loginModal,registerModal,logoutWidget);
    
    headerWidget = new HeaderWidget("header") ;
   
    
    layout = new SpacesLayout(userClientController, 180, 50, 50,40);
  
    loginModal.loadingShower = layout ;
    registerModal.loadingShower = layout;
    logoutWidget.loadingShower = layout;
    userClientController.loadingShower = layout;
    
    loginModal.setLoginLogoutEventCallBack( userClientController.loginLogoutEvent ) ;
    registerModal.setLoginLogoutEventCallBack( userClientController.loginLogoutEvent ) ;
    logoutWidget.setLoginLogoutEventCallBack( userClientController.loginLogoutEvent) ;
  }
  
  
  void set pagesController(PagesController pagesController){
    headerWidget.initEvents(userClientController, pagesController) ;
    _pagesController = pagesController ;
    pagesController.userClientController = userClientController ;
  }
  
  PagesController get pagesController => _pagesController ;
}



abstract class Page{
  
  
  String _name ;
  String description ;
  int _centerRightPercentPosition ;
  int _centerTopPercentPosition ;
  bool _showWestSpace;
  Set<String> receivedFragments = new Set<String>();
  PageContext context ;
  
  Page( this._name, this.context, this._centerRightPercentPosition, this._centerTopPercentPosition,this._showWestSpace ){
    _init();
    initPage();
  }

  void _init(){ 

    context.loginModal.setLoginLogoutEventCallBack( this.loginLogoutEvent ) ;
    context.registerModal.setLoginLogoutEventCallBack( this.loginLogoutEvent ) ;
    context.logoutWidget.setLoginLogoutEventCallBack( this.loginLogoutEvent ) ;
    
    
    querySelectorAll(".btn-login").onClick.listen((e) {
      context.userClientController.callLogin();
    });
    querySelectorAll(".btn-register").onClick.listen((e) {
      context.userClientController.callRegister();
    });
  }
  
  void organizeSpaces(){
    layout.organizeSpaces(_centerRightPercentPosition,_centerTopPercentPosition,showWestSpace:_showWestSpace );
  }
  
  void getAndShowElement(String resourceUrl, String fragmentSelector, {FragmentLoadedCallBack callback : null, bool show:true }){
    
    loadingNW.startLoading();
    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {
        String formContent = request.responseText;
        
        querySelector(fragmentSelector).setInnerHtml(formContent, validator: buildNodeValidatorBuilderForSafeHtml()) ;
        fragmentReceived(fragmentSelector);
        if(callback != null){
          callback();
        }
        loadingNW.stopLoading();
        if(show){
          showBySelector(fragmentSelector);
        }
      }
    });
    request.open("GET",  resourceUrl, async: true);
    request.send();      
  }
  
  void showBySelector(String selector, {String hiddenClass:"gx-hidden"}){
    querySelectorAll(selector).forEach((e){
      Element element = e as Element ;
      e.classes.remove(hiddenClass) ;
    });
  }
  
  void hideBySelector(String selector, {String hiddenClass:"gx-hidden"}){
    querySelectorAll(selector).forEach((e){
      Element element = e as Element ;
      e.classes.add(hiddenClass) ;
    });
  }  

  void updateNEPostion(String selector){
    querySelectorAll(selector).forEach((e){
      Element element = e as Element ;
      element.style.height = "${layout.postions.spaceNE_Height}px" ;
      element.style.width = "${layout.postions.spaceNE_Width}px" ;
      element.style.top = "${layout.postions.spaceNE_Top}px" ;
      element.style.right = "${layout.postions.spaceNE_Right}px" ;
    });
  }
  
  void updateSEPostion(String selector){
    querySelectorAll(selector).forEach((e){
      Element element = e as Element ;
      element.style.height = "${layout.postions.spaceSE_Height}px" ;
      element.style.width = "${layout.postions.spaceSE_Width}px" ;
      element.style.top = "${layout.postions.spaceSE_Top}px" ;
      element.style.right = "${layout.postions.spaceSE_Right}px" ;
    });
  }
  
  void updateSWPostion(String selector){
    querySelectorAll(selector).forEach((e){
      Element element = e as Element ;
      element.style.height = "${layout.postions.spaceSW_Height}px" ;
      element.style.width = "${layout.postions.spaceSW_Width}px" ;
      element.style.top = "${layout.postions.spaceSW_Top}px" ;
      element.style.right = "${layout.postions.spaceSW_Right}px" ;
    });
  } 
  
  void updateNWPostion(String selector){
    querySelectorAll(selector).forEach((e){
      Element element = e as Element ;
      element.style.height = "${layout.postions.spaceNW_Height}px" ;
      element.style.width = "${layout.postions.spaceNW_Width}px" ;
      element.style.top = "${layout.postions.spaceNW_Top}px" ;
      element.style.right = "${layout.postions.spaceNW_Right}px" ;
    });
  }   
  
  NodeValidatorBuilder buildNodeValidatorBuilderForSafeHtml(){
    final NodeValidatorBuilder _htmlValidator=new NodeValidatorBuilder.common()
    ..allowElement('form', attributes: ['role','accept-charset'])
    ..allowElement('table', attributes: ['style'])
    ..allowElement('span', attributes: ['style'])
    ..allowElement('a', attributes: ['href','rel'])
    ..allowElement('img', attributes: ['src','style'])
    ..allowElement('div', attributes: ['style'])
    ..allowElement('input', attributes: ['style'])
    ..allowElement('textarea', attributes: ['style'])
    ..allowElement('th', attributes: ['width'])
    ..allowElement('script')
    ..allowElement('td', attributes: ['style']);
    return _htmlValidator;
  }
  
  void showLoginModal(){
    context.loginModal.showLoginModal();
  }
  
  void loginLogoutEvent(LoginLogoutEvent event) {
  }

  void fragmentReceived(String fragmentSelector){
    receivedFragments.add(fragmentSelector);
  }
  
  bool canShowPage(Parameters pageParameters){
    return pageParameters.pageName == this.name ;
  }

  
  void showPage(Parameters pageParameters){
  }
  
 
  bool canBeLaunched(String login, bool isAdmin );
  
  bool canBeLaunchedFromMainMenu();
  
  List<ActionDescriptor> getActionsFor(String login, bool isAdmin){
    return null;
  }

  void initPage(){
    layout.centerMoved.listen((_){
      updateNWPostion("#${name}NW");
      updateSWPostion("#${name}SW");
      updateNEPostion("#${name}NE");
      updateSEPostion("#${name}SE");
    });
    
  }
  
  void hidePage() {
    hideBySelector("#${_name}NW");
    hideBySelector("#${_name}NE");
    hideBySelector("#${_name}SW");
    hideBySelector("#${_name}SE");
  }
  
  String        get name      => _name;
  HeaderWidget  get header    => context.headerWidget; 
  SpacesLayout  get layout    => context.layout; 
  LoadingWidget get loadingNW => context.loadingNW ;
  LoadingWidget get loadingNE => context.loadingNE ;
  LoadingWidget get loadingSW => context.loadingSW ;
  LoadingWidget get loadingSE => context.loadingSE ;
  
}
