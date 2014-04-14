
import 'dart:html';
import 'dart:async';

import "actions.dart" ;
import "events.dart" ;
import "models.dart";
import "authentication.dart" ;
import "pages/page.dart";
import "widgets/loading.dart";
import "widgets/login.dart";
import "widgets/register.dart";
import "widgets/logout.dart";

typedef void UserActionsChangeCallBack(UserActionsChangeEvent event);
typedef void TraceChangeCallBack(TraceChangeEvent event);


class ClientController{
  
}


class UserActionsChangeEvent{
  List<ActionDescriptor> mainApplicationMenu= new List<ActionDescriptor>();
  List<ActionDescriptor> currentPageMenu= new List<ActionDescriptor>();
}

class TraceChangeEvent{
  String key ;
}


class PagesController extends ClientController{
  
  static const PAGE_CHANGE_CHECK_TIMEOUT = const Duration(milliseconds: 300);
  
  Page _currentPage = null ;
  List<Page> _pages = new List<Page>();
  StreamController<UserActionsChangeEvent> _userActionsChangeEventStream ;
  StreamController<TraceChangeEvent> _traceChangeEventStream ;
  UserClientController userClientController;
  
  PagesController(){
    _userActionsChangeEventStream = new StreamController<UserActionsChangeEvent>.broadcast( sync: true);
    _traceChangeEventStream = new StreamController<TraceChangeEvent>.broadcast( sync: true);

   
    
    new Timer(PAGE_CHANGE_CHECK_TIMEOUT, _mayChangePage);
  }
  
  void init(List<Page> pages){
    _pages = pages ;
    
  }
  
  void setUserActionsChangeEventCallBack( UserActionsChangeCallBack callBack  ){
    _userActionsChangeEventStream.stream.listen((event) => callBack(event));
  }
  
  void setTraceChangeEventCallBack( TraceChangeCallBack callBack  ){
    _traceChangeEventStream.stream.listen((event) => callBack(event));
  }
  
  void _sendUserActionsChangeEvent(String login, bool isAdmin, Page page){
    UserActionsChangeEvent userActionsChangeEvent = new UserActionsChangeEvent();
    userActionsChangeEvent.currentPageMenu = page.getActionsFor(login, isAdmin);
    userActionsChangeEvent.mainApplicationMenu = this.getActionsFor(login, isAdmin);
    _userActionsChangeEventStream.add(  userActionsChangeEvent  );
  }
  
  void _sendTraceChangeEvent(String key){
    TraceChangeEvent traceChangeEvent = new TraceChangeEvent();
    traceChangeEvent.key = key;
    _traceChangeEventStream.add(  traceChangeEvent  );
  }
  
  void fireTraceChangeEvent(String key){
    _sendTraceChangeEvent( key);
  }
  
  void loginLogoutEvent(LoginLogoutEvent event){
    if (_currentPage != null){
      _sendUserActionsChangeEvent(event.login, event.isAdmin, _currentPage) ;
    }
  }
  
  void _mayChangePage(){
   
   Page targetPage = null ;
   Page defaultPage = _pages.first; 
   if ( !window.location.href.contains("#") ){
     targetPage = defaultPage;
   }
   
   String anchor =  window.location.href.substring(window.location.href.indexOf("#")+1) ;
   Parameters pageParameters = Parameters.buildFromAnchor(anchor);
   
   
   targetPage = _pages.firstWhere(  (page) => page.canShowPage(pageParameters), 
                                     orElse: () => defaultPage );
   
   
   if (targetPage == _currentPage){
     new Timer(PAGE_CHANGE_CHECK_TIMEOUT, _mayChangePage);
     return ;
   }  
   _showPage( targetPage,  pageParameters);
   User user = userClientController.connectedUser;
   if (  user !=null ){
     _sendUserActionsChangeEvent(user.login,user.admin, targetPage) ;
   }else{
     _sendUserActionsChangeEvent(null,false, targetPage) ;
   }
   new Timer(PAGE_CHANGE_CHECK_TIMEOUT, _mayChangePage);
  }
  
  void _showPage(Page targetPage, Parameters pageParameters){
    if( _currentPage != null  ){
      _currentPage.hidePage(); 
   }
   _currentPage = targetPage ;
   _currentPage.showPage(pageParameters); 
  }
  
  
  List<ActionDescriptor> getActionsFor(String login, bool isAdmin){
    List<ActionDescriptor> actions = new List<ActionDescriptor>();
    
    _pages.forEach((page){
      if (page.canBeLaunchedFromMainMenu() && page.canBeLaunched(login, isAdmin)){
        ActionDescriptor action = new ActionDescriptor();
        action.name = page.name;
        action.description = page.description;
        action.launchAction = (params) => window.location.href = "/#${page.name}"; 
        actions.add(action);
      }
    });
    return actions;
  }
  
}

class UserClientController extends ClientController with LoginLogoutEventProducer{
  
  Authentication _authentication ;
  StreamController _loginLogoutEventStream ;
  User _connectedUser = null ;
  
  LoginWidget _loginModal ;
  RegisterWidget _registerModal ;
  LogoutWidget _logoutWidget ;
  LoadingShower _loadingShower ; 
  
  UserClientController(this._loginModal, this._registerModal, this._logoutWidget){
    _init();
  }
  
  void loginLogoutEvent(LoginLogoutEvent event){
    if(event.isLogin){
      _authentication.storeAuthentication(event.login, event.isAdmin, event.encryptedPassword) ;
      userLoggedAs(event.login, event.isAdmin,event.encryptedPassword) ;
    }else{
      _authentication.resetAuthentication();      
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
  
  void userLoggedAs(String login, bool admin, String encryptedPassword){
    _connectedUser = new User.withFields(login, admin) ;
    sendLoginEvent(login, admin,encryptedPassword);
  }
  
  
  void _init(){
    _authentication = new Authentication();
    _authentication.setLoginLogoutEventCallBack(loginLogoutEvent);
    _authentication.authenticate();
    initLoginLogoutEventProducer();
  }
  

  
  void set loadingShower(LoadingShower loadingShower){
    this._loadingShower = loadingShower;
  }
  
  bool get hasConnectedUser => _connectedUser != null ;
  bool get hasAdminConnectedUser => _connectedUser != null && _connectedUser.admin ;
  User get connectedUser => _connectedUser ;
  
}