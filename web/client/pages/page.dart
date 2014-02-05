
import "dart:html";
import '../spaces.dart';
import "../widgets/login.dart" ;
import "../widgets/loading.dart" ;
import "../widgets/register.dart" ;
import "../widgets/logout.dart" ;
import "../widgets/persistentMenu.dart" ;
import "../events.dart" ;
import "../controllers.dart" ;


abstract class Page{
  
  UserClientController _userClientController ;
  
  SpacesLayout _layout ;
  LoginWidget _loginModal ;
  RegisterWidget _registerModal ;
  LogoutWidget _logoutWidget ;
  
  Page(  int centerSize, int centerRightPercentPosition,  int centerTopPercentPosition){
    _init();
    _layout = new SpacesLayout(_userClientController, centerSize, centerRightPercentPosition, centerTopPercentPosition);
    _userClientController.loadingShower = _layout ;
  }

  Page.withWestSpace(int centerSize, int centerRightPercentPosition,  int centerTopPercentPosition){
    _init();
    _layout = new SpacesLayout.withWestSpace(_userClientController, centerSize, centerRightPercentPosition, centerTopPercentPosition) ;
    _userClientController.loadingShower = _layout ;
  }

  void _init(){ 
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

  SpacesLayout get layout => _layout; 
}
