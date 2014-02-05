import "dart:html";
import "widget.dart" ;
import "../events.dart" ;
import "../controllers.dart" ;

class MenuWidget extends Widget{
  
  UserClientController _userClientController ;
  
  MenuWidget(String id, UserClientController userClientController  ): super(id){
    this._userClientController = userClientController;
    
    querySelectorAll("#${this.id}-login").forEach((e){
      e.onClick.listen((e) {
        _userClientController.callLogin();
      });
    });
    querySelectorAll("#${this.id}-logout").forEach((e){
      e.onClick.listen((e) {
        _userClientController.callLogout();
      });
    });    
    querySelectorAll("#${this.id}-register").forEach((e){
      e.onClick.listen((e) {
        _userClientController.callRegister();
      });
    });    
    
    _userClientController.setLoginLogoutEventCallBack( this.loginLogoutEvent);
  }
  
  void loginLogoutEvent(LoginLogoutEvent event){
    if ( event.isLogin){
      _initMenu(event.login, event.isAdmin);
    }else{
      _initMenu();
    }
  }
  
  void _initMenu([String login = null,bool admin= false ]){
    String anonymousMenuSelector = "#${this.id}-when-anonymous" ;
    String userMenuSelector = "#${this.id}-when-user" ;
    String adminMenuSelector = "#${this.id}-when-admin" ;
    if( login == null){
      _showMenu(anonymousMenuSelector);
      _hideMenu(userMenuSelector);
      _hideMenu(adminMenuSelector);
      return ;
    }
    querySelectorAll(".${this.id}-account").forEach((e) {   
        e.text = "${login}";
    }) ;
    
    if( admin){
      _hideMenu(anonymousMenuSelector);
      _hideMenu(userMenuSelector);
      _showMenu(adminMenuSelector);
      return ;
    }
    
     _hideMenu(anonymousMenuSelector);
     _showMenu(userMenuSelector);
     _hideMenu(adminMenuSelector);
  }
  
  void _showMenu(String menuSelector){
    Element menu =querySelector(menuSelector);
    menu.classes.remove("gx-hidden");
  }
  
  void _hideMenu(String menuSelector){
    Element menu =querySelector(menuSelector);
    menu.classes.add("gx-hidden");
  }
  
}