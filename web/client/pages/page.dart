
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


abstract class Page{
  
  String _name ;
  UserClientController _userClientController ;
  
  SpacesLayout _layout ;
  SharedWidgets _sharedWidgets ;
  
  LoginWidget _loginModal ;
  RegisterWidget _registerModal ;
  LogoutWidget _logoutWidget ;
  LoadingWidget _loadingNW ;
  LoadingWidget _loadingNE ;
  LoadingWidget _loadingSW ;
  LoadingWidget _loadingSE ;
  
  Page( String name,  int centerSize, int centerRightPercentPosition,  int centerTopPercentPosition){
    _name = name ;
    _init();
    _layout = new SpacesLayout(_userClientController, centerSize, centerRightPercentPosition, centerTopPercentPosition);
    _userClientController.loadingShower = _layout ;
  }

  Page.withWestSpace(String name,int centerSize, int centerRightPercentPosition,  int centerTopPercentPosition){
    _init();
    _layout = new SpacesLayout.withWestSpace(_userClientController, centerSize, centerRightPercentPosition, centerTopPercentPosition) ;
    _userClientController.loadingShower = _layout ;
  }

  void _init(){ 
     _loadingNW = new LoadingWidget("loadingNW");
     _loadingNE = new LoadingWidget("loadingNE");
     _loadingSW = new LoadingWidget("loadingSW");
     _loadingSE = new LoadingWidget("loadingSE");
    
    _sharedWidgets = new SharedWidgets("sharedWidgets");
    _loginModal = new LoginWidget("loginModal",  _layout);
    _registerModal = new RegisterWidget("registerModal",  _layout);
    _logoutWidget = new LogoutWidget("logout", _layout );
    _userClientController = new UserClientController(_loginModal,_registerModal,_logoutWidget,_layout);

    _loginModal.setLoginLogoutEventCallBack( this.loginLogoutEvent ) ;
    _registerModal.setLoginLogoutEventCallBack( this.loginLogoutEvent ) ;
    _logoutWidget.setLoginLogoutEventCallBack( this.loginLogoutEvent ) ;
    
    _loginModal.setLoginLogoutEventCallBack( _userClientController.loginLogoutEvent ) ;
    _registerModal.setLoginLogoutEventCallBack( _userClientController.loginLogoutEvent ) ;
    _logoutWidget.setLoginLogoutEventCallBack( _userClientController.loginLogoutEvent) ;
    
    querySelectorAll(".btn-login").onClick.listen((e) {
      _userClientController.callLogin();
    });
    querySelectorAll(".btn-register").onClick.listen((e) {
      _userClientController.callRegister();
    });
  }
  
  void showBySelector(String selector){
    querySelectorAll(selector).forEach((e){
      Element element = e as Element ;
      e.classes.remove("gx-hidden") ;
    });
  }
  
  void hideBySelector(String selector){
    querySelectorAll(selector).forEach((e){
      Element element = e as Element ;
      e.classes.add("gx-hidden") ;
    });
  }  

  void showLoginModal(){
    _loginModal.showLoginModal();
  }
  
  void loginLogoutEvent(LoginLogoutEvent event) {
  }

  void showPage() {
    _layout.moveCenterInitialPosition();
    showBySelector("#${_name}NW");
    showBySelector("#${_name}NE");
    showBySelector("#${_name}SW");
    showBySelector("#${_name}SE");
  }
  
  void hidePage() {
    hideBySelector("#${_name}NW");
    hideBySelector("#${_name}NE");
    hideBySelector("#${_name}SW");
    hideBySelector("#${_name}SE");
  }
  
  String get name => _name;
  SpacesLayout get layout => _layout; 
  LoadingWidget get loadingNW =>_loadingNW ;
  LoadingWidget get loadingNE =>_loadingNE ;
  LoadingWidget get loadingSW =>_loadingSW ;
  LoadingWidget get loadingSE =>_loadingSE ;
  
}
