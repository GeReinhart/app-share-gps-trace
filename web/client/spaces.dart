import 'dart:html';
import 'dart:async';
import 'package:bootjack/bootjack.dart';

import "controllers.dart" ;
import "widgets/persistentMenu.dart" ;
import "widgets/menu.dart" ;
import "widgets/loading.dart" ;
import "widgets/center.dart" ;


class SpacesLayout implements LoadingShower  {
  
  String spaces = ".spaces" ;
  String spaceElements  = ".space"  ;
  String spaceW  = ".space-west";
  String spaceNW  = ".space-north-west";
  String spaceNE  = ".space-north-east";
  String spaceSW  = ".space-south-west";
  String spaceSE  = ".space-south-east" ;
  String spaceCenter = ".space-center"  ;

  String spacePersitentMenu = ".space-persitent-menu";
  String spaceLoading = ".space-loading";
  
  CenterPostion _centerPosition ;
  
  int headerHeight;

  bool _showWestSpace = false;
  
  UserClientController _userClientController ;
  SpacesPositions postions ;
  PersistentMenuWidget _persistentMenuWidget ;
  CenterWidget _centerWidget ;
  
  MouseEvent _startMovingCenterPosition ;
  var _movingCenter = false;
  
  StreamController centerMovedController = new StreamController.broadcast();

  
  SpacesLayout(this._userClientController,  int centerSize, int centerRightPercentPosition,  int centerTopPercentPosition, this.headerHeight){
    _init( centerSize,  centerRightPercentPosition,  centerTopPercentPosition);
  }

  
  Stream get centerMoved => centerMovedController.stream;
  
  void _init(int centerSize, int centerRightPercentPosition, int centerTopPercentPosition){
    _persistentMenuWidget = new PersistentMenuWidget("persistentMenu") ;
    _centerWidget = new CenterWidget("spaceCenter",centerSize,  centerRightPercentPosition,  centerTopPercentPosition ) ;
    _centerWidget.setCenterChangeEventCallBack(_centerChangePostionEventCallBack);
    _centerPosition = _centerWidget.centerPostion ;
    
    Dropdown.use();
    
    _organizeSpaces();
    listenLoading();
    
    window.onLoad.listen(updateSpaces);
    window.onResize.listen(updateSpaces);

    window.onPageShow.listen((mouseEvent) {
      new Timer(new Duration(seconds: 1),_onPageShow);
    });

  }
  
  
  void _centerChangePostionEventCallBack(CenterPostion centerPosition){
    _centerPosition = centerPosition;
    _organizeSpaces();
    loadingInTheCenter();
  }
  
  void _onPageShow(){
    showSpaces();
    loadingInTheCenter();
  }
  
 

  
  void organizeSpaces(int centerRightPercentPosition, int centerTopPercentPosition, {bool showWestSpace:false}){
    _centerWidget.moveCenter(centerRightPercentPosition, centerTopPercentPosition) ;
    _centerPosition = _centerWidget.centerPostion;
    _showWestSpace = showWestSpace;
    _organizeSpaces();
    loadingInTheCenter();
  }
  
 
  void updateSpaces(Event event){
    _organizeSpaces();
    loadingInTheCenter();
  }
  
  void _organizeSpaces(){

    postions = new SpacesPositions();
    postions.spaceW_Right = _centerPosition.centerRight+1 ;
    postions.spaceW_Top = headerHeight.toDouble() ;
    postions.spaceW_Width = window.innerWidth - _centerPosition.centerRight-1 ;
    postions.spaceW_Height = window.innerHeight.toDouble() - headerHeight.toDouble();

    querySelector(spaceW) 
    ..style.position = 'absolute'
    ..style.zIndex = _showWestSpace?"100":"90" 
    ..style.right  = (postions.spaceW_Right).toString() + "px" 
    ..style.top    = (postions.spaceW_Top).toString() + "px" 
    ..style.width  = (postions.spaceW_Width).toString() + "px"
    ..style.height = (postions.spaceW_Height).toString() + "px" ;
    
    postions.spaceNW_Right = _centerPosition.centerRight+1 ;
    postions.spaceNW_Top = headerHeight.toDouble() ;
    postions.spaceNW_Width = window.innerWidth - _centerPosition.centerRight-1 ;
    postions.spaceNW_Height = _centerPosition.centerTop - headerHeight.toDouble() ;

    querySelector(spaceNW) 
    ..style.position = 'absolute'
    ..style.zIndex = _showWestSpace?"90":"100"
    ..style.right  = (postions.spaceNW_Right).toString() + "px" 
    ..style.top    = (postions.spaceNW_Top).toString() + "px" 
    ..style.width  = (postions.spaceNW_Width).toString() + "px"
    ..style.height = (postions.spaceNW_Height).toString() + "px" ;

    postions.spaceNE_Right = 0.0 ;
    postions.spaceNE_Top = headerHeight.toDouble() ;
    postions.spaceNE_Width = _centerPosition.centerRight ;
    postions.spaceNE_Height = _centerPosition.centerTop - headerHeight.toDouble() ;    
    
    querySelector(spaceNE)
    ..style.position = 'absolute'
    ..style.right  = (postions.spaceNE_Right).toString() + "px" 
    ..style.top    = (postions.spaceNE_Top).toString() + "px" 
    ..style.width  = (postions.spaceNE_Width).toString() + "px"
    ..style.height = (postions.spaceNE_Height).toString() + "px" ;

    postions.spaceSW_Right = _centerPosition.centerRight+1 ;
    postions.spaceSW_Top = _centerPosition.centerTop+1 ;
    postions.spaceSW_Width = window.innerWidth - _centerPosition.centerRight-1 ;
    postions.spaceSW_Height = window.innerHeight - _centerPosition.centerTop-1  ;       
    
    querySelector(spaceSW)
    ..style.position = 'absolute'
    ..style.zIndex = _showWestSpace?"90":"100"
    ..style.right  = (postions.spaceSW_Right).toString() + "px" 
    ..style.top    = (postions.spaceSW_Top).toString() + "px" 
    ..style.width  = (postions.spaceSW_Width).toString() + "px"
    ..style.height = (postions.spaceSW_Height).toString() + "px" ;  
    
    postions.spaceSE_Right = 0.0 ;
    postions.spaceSE_Top = _centerPosition.centerTop+1 ;
    postions.spaceSE_Width = _centerPosition.centerRight ;
    postions.spaceSE_Height = window.innerHeight - _centerPosition.centerTop-1  ;    
    
    querySelector(spaceSE)
    ..style.position = 'absolute'
    ..style.right  = (postions.spaceSE_Right).toString() + "px" 
    ..style.top    = (postions.spaceSE_Top).toString() + "px" 
    ..style.width  = (postions.spaceSE_Width).toString() + "px"
    ..style.height = (postions.spaceSE_Height).toString() + "px" ;   
    
    var menuItemsNumber = 6;
    
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
    ..style.right = (_centerPosition.centerRight  - _centerPosition.centerSize /2 +2   ).toString() + "px"
    ..style.top = (_centerPosition.centerTop    - _centerPosition.centerSize /2      ).toString()+ "px"
    ..style.width = _centerPosition.centerSize.toString()+ "px"
    ..style.height = _centerPosition.centerSize.toString()+ "px" ;
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
