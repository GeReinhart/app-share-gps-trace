import "dart:html";
import 'dart:async';

import "widget.dart" ;
import "modal.dart" ;
import "../events.dart" ;
import "../controllers.dart" ;

class HeaderWidget extends Widget  {
  
  static int HEIGHT = 40; 
  
  UserClientController _userClientController ;
  
  HeaderWidget(String id, UserClientController userClientController  ): super(id){
    this._userClientController = userClientController;
    _initEvents();
    _updateWidget();
  }
  
  void _initEvents(){
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
    
    querySelector("#${id}-right").style..zIndex = "201"
        ..top = "0px"
        ..margin = "0px"
        ..paddingRight = "10px"
        ..paddingBottom = "0px"
        ..paddingTop = "0px"
        ..height = "${HEIGHT}px"
        ..lineHeight = "${HEIGHT}px"
        ..textAlign = "right" 
        ..verticalAlign = "middle"
        ..position = "relative" ;
        
    querySelector("#${id}-user").style..height = "${HEIGHT}px"
                                          ..position = "relative" ;        

    querySelector("#${id}-login-img").style..height = "${HEIGHT * 0.7}px"
                                           ..position = "relative" ;
    querySelector("#${id}-logout-img").style..height = "${HEIGHT * 0.7}px" 
                                           ..position = "relative" ;
    querySelector("#${id}-register-img").style..height = "${HEIGHT * 0.7}px" 
                                           ..position = "relative" ;    
    querySelector("#${id}-menu-img").style..height = "${HEIGHT * 0.7}px" 
                                           ..position = "relative" ;    
  
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
    }else{
      hideBySelector("#${id}-login" );
      showBySelector("#${id}-logout" );
      hideBySelector("#${id}-register" );      
    }
    
    String text = admin ? "admin " : "" ;
    text += login == null ? "" : login ;
    querySelector("#${id}-user").text =  text ;  
  }
  
}