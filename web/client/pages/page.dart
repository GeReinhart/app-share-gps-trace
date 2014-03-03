
import "dart:html";
import '../spaces.dart';
import "../widgets/sharedWidgets.dart" ;
import "../widgets/login.dart" ;
import "../widgets/loading.dart" ;
import "../widgets/register.dart" ;
import "../widgets/logout.dart" ;
import "../widgets/persistentMenu.dart" ;
import "../events.dart" ;
import "../controllers.dart" ;


class PageContext {
  
  UserClientController userClientController ;
  SpacesLayout layout ;
  SharedWidgets sharedWidgets;
  LoginWidget loginModal ;
  RegisterWidget registerModal ;
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
    layout = new SpacesLayout(userClientController, 180, 50, 50);
  
    loginModal.loadingShower = layout ;
    registerModal.loadingShower = layout;
    logoutWidget.loadingShower = layout;
    userClientController.loadingShower = layout;
    
    loginModal.setLoginLogoutEventCallBack( userClientController.loginLogoutEvent ) ;
    registerModal.setLoginLogoutEventCallBack( userClientController.loginLogoutEvent ) ;
    logoutWidget.setLoginLogoutEventCallBack( userClientController.loginLogoutEvent) ;
  }
  
}

class PageParameter{
  String key ;
  String value;
  
  PageParameter(this.key,this.value) ;
}

class PageParameters{
  List<PageParameter> parameters = new List<PageParameter>() ;
  String pageName;
  
  
  add(String key, String value){
    parameters.add( new PageParameter(key,value) ) ;
  }
  
  static PageParameters  buildFromAnchor(String anchor){
    PageParameters pageParameters = new PageParameters();
    
    int startParameters = anchor.indexOf("?") ;
    if (startParameters == -1){
      pageParameters.pageName = anchor ;
      return pageParameters ;
    }
    pageParameters.pageName = anchor.substring(0,startParameters ) ;
    if( anchor.length <= pageParameters.pageName.length +1 ){
      return pageParameters ;
    }
    String pageParametersAsString = anchor.substring(startParameters + 1,anchor.length  ) ;
    pageParametersAsString.split("&").forEach((s){
       List<String>  paramAndValue = s.split("=");
       if ( paramAndValue.length == 2 ){
         pageParameters.add (paramAndValue[0],paramAndValue[1] );
       }
    }) ;
    return pageParameters;
  }
  
  
}

abstract class Page{
  
  
  String _name ;
  int _centerRightPercentPosition ;
  int _centerTopPercentPosition ;
  bool _showWestSpace;
  Set<String> receivedFragments = new Set<String>();
  PageContext _context ;
  
  Page( this._name, this._context, this._centerRightPercentPosition, this._centerTopPercentPosition,this._showWestSpace ){
    _init();
  }

  void _init(){ 

    _context.loginModal.setLoginLogoutEventCallBack( this.loginLogoutEvent ) ;
    _context.registerModal.setLoginLogoutEventCallBack( this.loginLogoutEvent ) ;
    _context.logoutWidget.setLoginLogoutEventCallBack( this.loginLogoutEvent ) ;
    
    
    querySelectorAll(".btn-login").onClick.listen((e) {
      _context.userClientController.callLogin();
    });
    querySelectorAll(".btn-register").onClick.listen((e) {
      _context.userClientController.callRegister();
    });
  }
  
  void organizeSpaces(){
    layout.organizeSpaces(_centerRightPercentPosition,_centerTopPercentPosition,showWestSpace:_showWestSpace );
  }
  
  void getAndShowElement(String resourceUrl, String fragmentSelector){
    
    loadingNW.startLoading();
    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {
        String formContent = request.responseText;
        
        querySelector(fragmentSelector).setInnerHtml(formContent, validator: buildNodeValidatorBuilderForSafeHtml()) ;
        fragmentReceived(fragmentSelector);
        loadingNW.stopLoading();
        showBySelector(fragmentSelector);
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
    _context.loginModal.showLoginModal();
  }
  
  void loginLogoutEvent(LoginLogoutEvent event) {
  }

  void fragmentReceived(String fragmentSelector){
    receivedFragments.add(fragmentSelector);
  }
  
  bool canShowPage(PageParameters pageParameters){
    return pageParameters.pageName == this.name ;
  }

  
  void showPage( PageParameters pageParameters);

  void initPage(){
  }
  
  void hidePage() {
    hideBySelector("#${_name}NW");
    hideBySelector("#${_name}NE");
    hideBySelector("#${_name}SW");
    hideBySelector("#${_name}SE");
  }
  
  String        get name      => _name;
  SpacesLayout  get layout    => _context.layout; 
  LoadingWidget get loadingNW => _context.loadingNW ;
  LoadingWidget get loadingNE => _context.loadingNE ;
  LoadingWidget get loadingSW => _context.loadingSW ;
  LoadingWidget get loadingSE => _context.loadingSE ;
  
}
