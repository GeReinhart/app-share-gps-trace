
import 'dart:html';
import 'dart:async';

import "events.dart" ;
import "models.dart";
import "pages/page.dart";
import "widgets/loading.dart";
import "widgets/login.dart";
import "widgets/register.dart";
import "widgets/logout.dart";

class ClientController{
  
}

class PagesController extends ClientController{
  
  static const PAGE_CHANGE_CHECK_TIMEOUT = const Duration(milliseconds: 300);
  
  Page _currentPage = null ;
  List<Page> _pages = new List<Page>();
  
  PagesController(this._pages){
    _init();
  }
  
  void _init(){
    new Timer(PAGE_CHANGE_CHECK_TIMEOUT, _mayChangePage);
  }
  
  void _mayChangePage(){
   
   Page targetPage = null ;
   Page defaultPage = _pages.first; 
   if ( !window.location.href.contains("#") ){
     targetPage = defaultPage;
   }
   
   String anchor =  window.location.href.substring(window.location.href.indexOf("#")+1) ;
   targetPage = _pages.firstWhere(  (page) => anchor.startsWith(page.name) ,  orElse: () => defaultPage );
   
   if (targetPage == _currentPage){
     new Timer(PAGE_CHANGE_CHECK_TIMEOUT, _mayChangePage);
     return ;
   }  
   
   if( _currentPage != null  ){
      _currentPage.hidePage(); 
   }
   _currentPage = targetPage ;
   _currentPage.showPage(); 
   new Timer(PAGE_CHANGE_CHECK_TIMEOUT, _mayChangePage);
  }
}

class UserClientController extends ClientController with LoginLogoutEventProducer{
  
  StreamController _loginLogoutEventStream ;
  User _connectedUser = null ;
  
  LoginWidget _loginModal ;
  RegisterWidget _registerModal ;
  LogoutWidget _logoutWidget ;
  LoadingShower _loadingShower ; 
  
  UserClientController(this._loginModal, this._registerModal, this._logoutWidget, this._loadingShower){
    _init();
  }
  
  void loginLogoutEvent(LoginLogoutEvent event){
    if(event.isLogin){
      userLoggedAs(event.login, event.isAdmin) ;
    }else{
      userLogout();
    }
  }

  void callLogin(){
    _loginModal.showLoginModal();
  }

  void callLogout(){
    _logoutWidget.callLogout();
  }

  void callRegister(){
    _registerModal.showRegisterModal();    
  }

  void userLogout(){
    _connectedUser = null ;
    sendLogoutEvent();
  }
  
  void userLoggedAs(String login, bool admin){
    _connectedUser = new User.withFields(login, admin) ;
    sendLoginEvent(login, admin);
  }
  
  
  void _init(){
    _initConnectedUser();
    initLoginLogoutEventProducer();
  }
  
  void _initConnectedUser() {
    
    Element userLogin = querySelector("[data-connected-user-login]") ;
    Element userAdmin = querySelector("[data-connected-user-admin]") ;
    if (userLogin != null){
      _connectedUser = new User.withFields(  userLogin.attributes["data-connected-user-login"],
                                             userLogin.attributes["data-connected-user-admin"] == "true" ) ;
    }
    
  }
  
  void set loadingShower(LoadingShower loadingShower){
    this._loadingShower = loadingShower;
  }
  
  bool get hasConnectedUser => _connectedUser != null ;
  bool get hasAdminConnectedUser => _connectedUser != null && _connectedUser.admin ;
  User get connectedUser => _connectedUser ;
  
}