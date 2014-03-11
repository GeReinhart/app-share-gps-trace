import "dart:html";
import 'dart:async';

import "widget.dart" ;
import "menu.dart" ;
import "modal.dart" ;
import "../events.dart" ;
import "../controllers.dart" ;

class HeaderWidget extends Widget  {
  
  static int HEIGHT = 40; 
  
  String spaceMenu = ".space-menu";
  String spaceContextualMenu = ".space-contextual-menu";
  
  UserClientController _userClientController ;
  MenuWidget _menuWidget;
  
  HeaderWidget(String id, UserClientController userClientController  ): super(id){
    this._userClientController = userClientController;
    _menuWidget = new MenuWidget("menu",_userClientController) ;
    _updateWidget();
    _initEvents();
  }
  
  void _initEvents(){
    
    _userClientController.setLoginLogoutEventCallBack( _menuWidget.loginLogoutEvent) ;
    
    _userClientController.setLoginLogoutEventCallBack(this.loginLogoutEvent) ;
    querySelectorAll("#${id}-login").forEach((e){
      e.onClick.listen((e) {
        _userClientController.callLogin();
      });
    });
    querySelectorAll("#${id}-logout").forEach((e){
      e.onClick.listen((e) {
        _userClientController.callLogout();
      });
    });    
    querySelectorAll("#${id}-register").forEach((e){
      e.onClick.listen((e) {
        _userClientController.callRegister();
      });
    });
    querySelectorAll("#${id}-menu").forEach((e){
      e.onClick.listen((e) {
        toggleMenu();
      });
    });
    querySelectorAll(spaceMenu).forEach((e){
      e.onClick.listen((e) {
        toggleMenu();
      });
    });    
    querySelectorAll(spaceContextualMenu).forEach((e){
      e.onClick.listen((e) {
        toggleMenu();
      });
    });     
    window.onResize.listen((_)=>_updateWidget());
  }
  
  void _updateWidget(){
    updatePosition(0, 0, window.innerWidth, HEIGHT) ;
    widgetElement.style..zIndex = "200"
                       ..position = "absolute"
                       ..textAlign = "center"
                       ..borderBottomStyle = "solid"
                       ..borderBottomWidth = "1px"
                       ..borderBottomColor = "black"
                       ..backgroundColor = "white" ;
    
    querySelector("#${id}-title").style..zIndex = "200"
        ..top = "0px"
        ..margin = "0px"
        ..padding = "0px"
        ..width = "100%"
        ..position = "absolute"
        ..textAlign = "center" ;
    
    querySelector("#${id}-right").style..zIndex = "202"
        ..top = "0px"
        ..right = "0px"
        ..margin = "0px"
        ..paddingRight = "10px"
        ..paddingBottom = "0px"
        ..paddingTop = "0px"
        ..height = "${HEIGHT}px"
        ..lineHeight = "${HEIGHT}px"
        ..textAlign = "right" 
        ..verticalAlign = "middle"
        ..position = "absolute" ;
        
    querySelectorAll("#${id}-right span").forEach((e){
      Element element = e as Element ;
      element.style..position= "relative" 
                   ..top= "0px" ;
    }) ;  
    querySelectorAll("#${id}-right span a img").forEach((e){
      Element element = e as Element ;
      element.style..height = "${HEIGHT * 0.7}px" 
                   ..position = "relative" ;
    }) ;             
    querySelector("#${id}-close a img").style..height = "${HEIGHT * 0.5}px"  ;
    
    querySelector("#${id}-left").style..zIndex = "201"
        ..top = "0px"
        ..margin = "0px"
        ..paddingLeft = "10px"
        ..paddingBottom = "0px"
        ..paddingTop = "0px"
        ..height = "${HEIGHT}px"
        ..lineHeight = "${HEIGHT}px"
        ..textAlign = "left" 
        ..verticalAlign = "middle"
        ..position = "relative" ;
        
   querySelectorAll("#${id}-left span").forEach((e){
          Element element = e as Element ;
          element.style..position= "relative" 
              ..top= "0px" ;
   }) ; 
   
   querySelectorAll("#${id}-left span a img").forEach((e){
          Element element = e as Element ;
          element.style..height = "${HEIGHT * 0.7}px" 
          ..position = "relative" ;
   }) ;                                         
            
   querySelectorAll(spaceMenu).forEach((e){
     Element element = e as Element ;
     element.style..position= "relative" 
         ..top= "${HEIGHT}px"  ;
   }) ;
   querySelectorAll(spaceContextualMenu).forEach((e){
     Element element = e as Element ;
     element.style..position= "relative" 
         ..top= "${HEIGHT + 200}px"  ;
   }) ;
  }
  
  void set title(String value) {
    querySelector("#${id}-title").innerHtml= value;
  }
  
  void anonymeUser(){
    _changeWidget();
  }

  void loginLogoutEvent(LoginLogoutEvent event){
    if ( event.isLogin){
      _changeWidget(event.login, event.isAdmin);
    }else{
      _changeWidget();
    }
  }
  
  void userLoggedAs(String login, bool admin){
    _changeWidget(login,admin);
  }
  
  void _changeWidget([String login = null,bool admin= false ]){
    
    if ( login == null){
      showBySelector("#${id}-login" );
      hideBySelector("#${id}-logout" );
      showBySelector("#${id}-register" );
      hideBySelector("#${id}-user" );
      hideBySelector("#${id}-admin" );
    }else{
      hideBySelector("#${id}-login" );
      showBySelector("#${id}-logout" );
      hideBySelector("#${id}-register" );
      if (admin){
        hideBySelector("#${id}-user" );
        showBySelector("#${id}-admin" ); 
        querySelector("#${id}-admin a").title = "Admin ${login} (en construction)"  ;
      }else{
        showBySelector("#${id}-user" );
        hideBySelector("#${id}-admin" );        
        querySelector("#${id}-user a").title = "Utilisateur ${login} (en construction)"  ;
      }
    }
  }
  
  void toggleMenu(){
    _toggleMenuBySelector(spaceMenu);
    _toggleMenuBySelector(spaceContextualMenu);
  }
  
  void _toggleMenuBySelector(selector){
    var menu = querySelectorAll(selector);
    if ( menu.style.zIndex != "102" ){
      menu.style.zIndex = "102" ;
      menu.classes.add("open");
    }else{
      menu.style.zIndex = "99" ;
      menu.classes.remove("open");
    }
  }
}