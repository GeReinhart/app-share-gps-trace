import 'dart:html';
import 'dart:async';
import 'package:bootjack/bootjack.dart';
import "events.dart";
import "controllers.dart" ;
import "widgets/persistentMenu.dart" ;
import "widgets/menu.dart" ;
import "widgets/loading.dart" ;


class SpacesLayout implements LoadingShower  {
  
  String spaces = ".spaces" ;
  String spaceElements  = ".space"  ;
  String spaceW  = ".space-west";
  String spaceNW  = ".space-north-west";
  String spaceNE  = ".space-north-east";
  String spaceSW  = ".space-south-west";
  String spaceSE  = ".space-south-east" ;
  String spaceCenter = ".space-center"  ;
  String spaceMenu = ".space-menu";
  String spaceContextualMenu = ".space-contextual-menu";
  String spacePersitentMenu = ".space-persitent-menu";
  String spaceLoading = ".space-loading";
  
  int centerRightPercentPosition ;
  int centerTopPercentPosition;
  int centerSize ;

  double centerRight ;
  double centerTop ;
  
  bool _showWestSpace = false;
  
  UserClientController _userClientController ;
  SpacesPositions postions ;
  PersistentMenuWidget _persistentMenuWidget ;
  MenuWidget _menuWidget;
  
  MouseEvent _startMovingCenterPosition ;
  var _movingCenter = false;
  
  StreamController centerMovedController = new StreamController.broadcast();

  
  SpacesLayout(this._userClientController,  this.centerSize, this.centerRightPercentPosition,  this.centerTopPercentPosition){
    _init();
  }

  
  Stream get centerMoved => centerMovedController.stream;
  
  void _init(){
    _persistentMenuWidget = new PersistentMenuWidget("persistentMenu",_userClientController) ;
    _menuWidget = new MenuWidget("menu",_userClientController) ;
    _userClientController.setLoginLogoutEventCallBack( _persistentMenuWidget.loginLogoutEvent) ;
    _userClientController.setLoginLogoutEventCallBack( _menuWidget.loginLogoutEvent) ;
    
    centerRight = (window.innerWidth * centerRightPercentPosition / 100).toDouble() ;
    centerTop = (window.innerHeight * centerTopPercentPosition / 100).toDouble() ;
    
    Dropdown.use();
    
    _organizeSpaces();
    listenLoading();
    
    window.onLoad.listen(updateSpaces);
    window.onResize.listen(updateSpaces);

    querySelector(spaceCenter).onMouseDown.listen((mouseEvent) {
      _startMovingCenterPosition = mouseEvent ;
      _movingCenter = true ;
      toggleMenu();
      querySelector(spaceCenter + " img").attributes["src"] = "/assets/img/compass_275_red.png";
    });

    querySelectorAll(spaceMenu).onClick.listen((mouseEvent) {
      toggleMenu();
    });
    querySelectorAll(spaceContextualMenu).onClick.listen((mouseEvent) {
      toggleMenu();
    });
    
    querySelector(spaceCenter).onMouseLeave.listen((mouseEvent) {
      if (_movingCenter){
        _movingCenter = false;
        _moveCenter( _startMovingCenterPosition.client, mouseEvent.client);
      }
    });

    querySelector(spaceCenter).onMouseUp.listen((mouseEvent) {
      if (_movingCenter){
        _movingCenter = false;
        _moveCenter( _startMovingCenterPosition.client, mouseEvent.client);
      }
    });

    window.onMouseOver.listen((mouseEvent) {
      if (_movingCenter){
        _movingCenter = false;
        _moveCenter( _startMovingCenterPosition.client, mouseEvent.client);
      }
    });
    
    window.onMouseUp.listen((mouseEvent) {
      if (_movingCenter){
        _movingCenter = false;
        _moveCenter( _startMovingCenterPosition.client, mouseEvent.client);
      }
    });

    window.onPageShow.listen((mouseEvent) {
      new Timer(new Duration(seconds: 1),_onPageShow);
    });

  }
  
  void _onPageShow(){
    showSpaces();
    loadingInTheCenter();
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
  
  void organizeSpaces(int centerRightPercentPosition, int centerTopPercentPosition, {bool showWestSpace:false}){
    centerRight = (window.innerWidth * centerRightPercentPosition / 100).toDouble() ;
    centerTop = (window.innerHeight * centerTopPercentPosition / 100).toDouble() ;
    _showWestSpace = showWestSpace;
    _organizeSpaces();
    loadingInTheCenter();
  }
  
  void _moveCenter(Point start, Point end){
    double centerRightComputed =   -end.x + start.x  + centerRight ;
    double centerTopComputed   =  end.y - start.y  + centerTop ;  ;
    
    if (centerRightComputed < centerSize /2 ){
      centerRight = (centerSize/2).toDouble() ;
    }else{
      centerRight = centerRightComputed;
    }
    if ( centerTopComputed >  window.innerHeight - centerSize /2  ){
      centerTop = (window.innerHeight - centerSize /2).toDouble()  ;       
    }else{
      centerTop = centerTopComputed ;
    }
    _organizeSpaces();
    loadingInTheCenter();
  }
  
  void updateSpaces(Event event){
    _organizeSpaces();
    loadingInTheCenter();
  }
  
  void _organizeSpaces(){

    postions = new SpacesPositions();
    postions.spaceW_Right = centerRight+1 ;
    postions.spaceW_Top = 0.0 ;
    postions.spaceW_Width = window.innerWidth - centerRight-1 ;
    postions.spaceW_Height = window.innerHeight.toDouble();

    querySelector(spaceW) 
    ..style.position = 'absolute'
    ..style.zIndex = _showWestSpace?"100":"90" 
    ..style.right  = (postions.spaceW_Right).toString() + "px" 
    ..style.top    = (postions.spaceW_Top).toString() + "px" 
    ..style.width  = (postions.spaceW_Width).toString() + "px"
    ..style.height = (postions.spaceW_Height).toString() + "px" ;
    
    postions.spaceNW_Right = centerRight+1 ;
    postions.spaceNW_Top = 0.0 ;
    postions.spaceNW_Width = window.innerWidth - centerRight-1 ;
    postions.spaceNW_Height = centerTop ;

    querySelector(spaceNW) 
    ..style.position = 'absolute'
    ..style.zIndex = _showWestSpace?"90":"100"
    ..style.right  = (postions.spaceNW_Right).toString() + "px" 
    ..style.top    = (postions.spaceNW_Top).toString() + "px" 
    ..style.width  = (postions.spaceNW_Width).toString() + "px"
    ..style.height = (postions.spaceNW_Height).toString() + "px" ;

    postions.spaceNE_Right = 0.0 ;
    postions.spaceNE_Top = 0.0 ;
    postions.spaceNE_Width = centerRight ;
    postions.spaceNE_Height = centerTop ;    
    
    querySelector(spaceNE)
    ..style.position = 'absolute'
    ..style.right  = (postions.spaceNE_Right).toString() + "px" 
    ..style.top    = (postions.spaceNE_Top).toString() + "px" 
    ..style.width  = (postions.spaceNE_Width).toString() + "px"
    ..style.height = (postions.spaceNE_Height).toString() + "px" ;

    postions.spaceSW_Right = centerRight+1 ;
    postions.spaceSW_Top = centerTop+1 ;
    postions.spaceSW_Width = window.innerWidth - centerRight-1 ;
    postions.spaceSW_Height = window.innerHeight - centerTop-1  ;       
    
    querySelector(spaceSW)
    ..style.position = 'absolute'
    ..style.zIndex = _showWestSpace?"90":"100"
    ..style.right  = (postions.spaceSW_Right).toString() + "px" 
    ..style.top    = (postions.spaceSW_Top).toString() + "px" 
    ..style.width  = (postions.spaceSW_Width).toString() + "px"
    ..style.height = (postions.spaceSW_Height).toString() + "px" ;  
    
    postions.spaceSE_Right = 0.0 ;
    postions.spaceSE_Top = centerTop+1 ;
    postions.spaceSE_Width = centerRight ;
    postions.spaceSE_Height = window.innerHeight - centerTop-1  ;    
    
    querySelector(spaceSE)
    ..style.position = 'absolute'
    ..style.right  = (postions.spaceSE_Right).toString() + "px" 
    ..style.top    = (postions.spaceSE_Top).toString() + "px" 
    ..style.width  = (postions.spaceSE_Width).toString() + "px"
    ..style.height = (postions.spaceSE_Height).toString() + "px" ;   
    
    querySelector(spaceCenter)
    ..style.position = 'absolute'
    ..style.right = (centerRight  - centerSize /2 +2   ).toString() + "px"
    ..style.top = (centerTop    - centerSize /2      ).toString()+ "px"
    ..style.width = centerSize.toString()+ "px"
    ..style.height = centerSize.toString()+ "px" ;  
    querySelector(spaceCenter + " img").attributes["src"] = "/assets/img/compass_275.png";
    
    var menuItemsNumber = 6;
    querySelectorAll(spaceMenu).forEach( (e){
      e
      ..style.position = 'absolute'
      ..style.right = (centerRight  - centerSize /2 +2   ).toString() + "px"
      ..style.top   = centerTop < window.innerHeight/2  ? (centerTop+1  + centerSize *  ( 1                )  /6 ).toString()+ "px"
                                                        : (centerTop+1  - centerSize *  ( menuItemsNumber  )  /6 ).toString()+ "px"
      ..style.width = centerSize.toString()+ "px"
      ..style.height = "0px" ;   
    }) ;

    var contextualMenuItemsNumber = 2;
    querySelectorAll(spaceContextualMenu)
    ..style.position = 'absolute'
    ..style.right = (centerRight  - centerSize /2 +2   ).toString() + "px"
    ..style.top =  centerTop >= window.innerHeight/2  ? (centerTop+1  + centerSize *  ( 1                          )  /6 ).toString()+ "px" 
                                                     : (centerTop+1  - centerSize *  ( contextualMenuItemsNumber +2  )  /6 ).toString()+ "px"
    ..style.width = centerSize.toString()+ "px"
    ..style.height = "0px" ;  
    
    querySelector(spacePersitentMenu)
    ..style.position = 'absolute'
    ..style.zIndex = '200'
    ..style.right = (0).toString() + "px"
    ..style.top = ( window.innerHeight - 20     ).toString()+ "px"
    ..style.height = 20.toString()+ "px" ;  

    
    centerMovedController.add(postions);
  }
  
  void loadingInTheCenter() {
    querySelector(spaceLoading)
    ..style.position = 'absolute'
    ..style.right = (centerRight  - centerSize /2 +2   ).toString() + "px"
    ..style.top = (centerTop    - centerSize /2      ).toString()+ "px"
    ..style.width = centerSize.toString()+ "px"
    ..style.height = centerSize.toString()+ "px" ;
  }
  
  void showSpaces() {
    querySelector(spaces)
    ..style.visibility = 'visible' ;
  }

  void hideSpaces() {
    querySelector(spaces)
    ..style.visibility = 'hidden' ;
  }
  
  void listenLoading(){
    ElementList list = querySelectorAll(".loading-on-click");
    if (list!= null && list.isNotEmpty){
      list.onClick.listen((e) {
        startLoading();
      });
    }

  }
  
  void startLoading(){
    querySelector(spaceLoading).style.zIndex = "200" ;
  }
  
  void stopLoading(){
    querySelector(spaceLoading).style.zIndex = "10" ;
  }
  
  void _loginLogoutEvent(LoginLogoutEvent event){
    if (! event.isLogout){
      _persistentMenuWidget.userLoggedAs(event.login, event.isAdmin) ;
    }else{
      _persistentMenuWidget.anonymeUser();
    }
  }

}

class SpacesPositions{
  double centerRight ;
  double centerTop ;
  
  int windowWidth = window.innerWidth;
  int windowHeight = window.innerHeight;

  double spaceW_Right ;
  double spaceW_Top ;
  double spaceW_Width ;
  double spaceW_Height ;
  
  double spaceNW_Right ;
  double spaceNW_Top ;
  double spaceNW_Width ;
  double spaceNW_Height ;

  double spaceNE_Right ;
  double spaceNE_Top ;
  double spaceNE_Width ;
  double spaceNE_Height ;

  double spaceSW_Right ;
  double spaceSW_Top ;
  double spaceSW_Width ;
  double spaceSW_Height ;  
  
  double spaceSE_Right ;
  double spaceSE_Top ;
  double spaceSE_Width ;
  double spaceSE_Height ;
}
