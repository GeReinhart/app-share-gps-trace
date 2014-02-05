import "dart:html";
import "widget.dart" ;
import "../events.dart" ;
import "../controllers.dart" ;

class PersistentMenuWidget extends Widget{
  
  UserClientController _userClientController ;
  
  PersistentMenuWidget(String id, UserClientController userClientController  ): super(id){
    this._userClientController = userClientController;
    _userClientController.setLoginLogoutEventCallBack(this.loginLogoutEvent) ;
  }
  
  void anonymeUser(){
    _initPersitentMenu();
  }

  void loginLogoutEvent(LoginLogoutEvent event){
    if ( event.isLogin){
      _initPersitentMenu(event.login, event.isAdmin);
    }else{
      _initPersitentMenu();
    }
  }
  
  void userLoggedAs(String login, bool admin){
    _initPersitentMenu(login,admin);
  }
  
  void _initPersitentMenu([String login = null,bool admin= false ]){
    String text = admin ? "admin " : "utilisateur " ;
    text += login == null ? "anonyme" : login ;
    querySelector("#${id}-user").text =  text ;  
  }
  
  
}