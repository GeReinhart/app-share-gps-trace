import "dart:html";
import 'dart:async';

import "widget.dart" ;
import "commentEditor.dart" ;
import "menu.dart" ;
import "../pages/page.dart" ;
import "modal.dart" ;
import "../actions.dart" ;
import "../events.dart" ;
import "../controllers.dart" ;
import "../models.dart" ;

class HeaderWidget extends Widget  {
  
  static int HEIGHT = 40; 
  
  String spaceMenu = ".space-menu";
  
  MenuWidget _menuWidget;
  MenuWidget _pageLinksWidget;
  AvailablePages _availablePages ;
  
  PageChangeEvent _lastPageChangeEvent;
  StreamController<PageChangeEvent> _pageChangeEventStream ;
  
  
  HeaderWidget(String id): super(id){
    _menuWidget = new MenuWidget("menu") ;
    _pageLinksWidget = new MenuWidget("pageLinks") ;
    _availablePages = new AvailablePages();
    _pageChangeEventStream = new StreamController<PageChangeEvent>.broadcast( sync: true);
    _updateWidget();
  }
  
  void initEvents(UserClientController userClientController, PagesController pagesController){
    
    pagesController.setUserActionsChangeEventCallBack(this.userActionsChangeEvent);
    pagesController.setPageChangeEventCallBack(this.pageChangeEvent);
    userClientController.setLoginLogoutEventCallBack(this.loginLogoutEvent) ;
    querySelectorAll("#${id}-login").forEach((e){
      e.onClick.listen((e) {
        userClientController.callLogin();
      });
    });
    querySelectorAll("#${id}-logout").forEach((e){
      e.onClick.listen((e) {
        userClientController.callLogout();
      });
    });    
    querySelectorAll("#${id}-register").forEach((e){
      e.onClick.listen((e) {
        userClientController.callRegister();
      });
    });
    querySelectorAll("#${id}-menu").forEach((e){
      e.onClick.listen((e) {
        _menuWidget.toggleMenu();
      });
    });
    querySelectorAll("#${id}-pages").forEach((e){
      e.onClick.listen((e) {
        _pageLinksWidget.toggleMenu();
      });
    });
    querySelectorAll("#${id}-search").forEach((e){
      e.onClick.listen((e) {
        window.location.href = "/#trace_search" ;
      });
    });
    querySelectorAll("#${id}-close").forEach((e){
      e.onClick.listen((e) {
        if (_lastPageChangeEvent != null){
          _availablePages.removePageLink( _lastPageChangeEvent.url ); 
          _lastPageChangeEvent.toBeRemoved = true;
          _lastPageChangeEvent.displayed = false;
          _pageChangeEventStream.add(  _lastPageChangeEvent );
        }
      });
    });
    querySelectorAll("#${id}-previous").forEach((e){
      e.onClick.listen((e) {
        if (_lastPageChangeEvent != null){
          _lastPageChangeEvent.toGoPrevious = true;
          _lastPageChangeEvent.toGoNext = false;
          _lastPageChangeEvent.displayed = false;
          _pageChangeEventStream.add(  _lastPageChangeEvent );
        }
      });
    });    
    querySelectorAll("#${id}-next").forEach((e){
      e.onClick.listen((e) {
        if (_lastPageChangeEvent != null){
          _lastPageChangeEvent.toGoPrevious = false;
          _lastPageChangeEvent.toGoNext = true;
          _lastPageChangeEvent.displayed = false;
          _pageChangeEventStream.add(  _lastPageChangeEvent );
        }
      });
    });    
    
    window.onResize.listen((_)=>_updateWidget());
  }
  
  
  void initFeedBacks(CommentEditorWidget commentEditor){
    querySelectorAll("#${id}-feedback").forEach((e){
      e.onClick.listen((e) {
        commentEditor.showCommentEditorModal("feedback", "feedback", header:"Retour utilisateur", placeHolder:"Retour utilisateur (sera visible à la page À Propos, merci du retour)");
      });
    });
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
            
   querySelector("#${_menuWidget.id}").style..position= "absolute" 
                ..left= "3px" 
                ..top= "${HEIGHT}px"  ;

   querySelector("#${_pageLinksWidget.id}").style..position= "absolute"
                ..right= "500px" 
                ..top= "${HEIGHT}px"  ;
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
      hideBySelector("#${id}-feedback" );
    }else{
      hideBySelector("#${id}-login" );
      showBySelector("#${id}-logout" );
      hideBySelector("#${id}-register" );
      showBySelector("#${id}-feedback" );
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
  

  
  void userActionsChangeEvent(UserActionsChangeEvent event) {
      _menuWidget.resetMenu(event.mainApplicationMenu,event.currentPageMenu) ;
  }

  void setPageChangeEventCallBack( PageChangeCallBack callBack  ){
    _pageChangeEventStream.stream.listen((event) => callBack(event));
  }
  

  
  void pageChangeEvent(PageChangeEvent event){

    _lastPageChangeEvent = event;
    if (event.displayed){
      if(event.shouldBeInPageList){
        showBySelector("#${id}-close");
      }else{
        hideBySelector("#${id}-close");
      }
    }
    if (event.shouldBeInPageList){
      if (event.displayed){
       _availablePages.addPageLink( new PageLink(event.title,event.url) ); 
      }
      if (event.removed){
       _availablePages.removePageLink( event.url ); 
      }
      _pageLinksWidget.resetMenu(_availablePages.actions, null);
      
    }
  }
  
}


class PageLink{
  String title;
  String url;
  
  PageLink(this.title, this.url);
  
  ActionDescriptor get action {
    ActionDescriptor action = new ActionDescriptor();
    String displayedTitle = title ;
    if(title.length > 45){
      displayedTitle = title.substring(0,44) + "..." ;
    }
    
    action.name = title;
    action.description = displayedTitle;
    action.launchAction = (params) => window.location.href = url; 
    return action; 
  }
}


class AvailablePages {
  List<PageLink> _pageLinks = new  List<PageLink>();
  
  void addPageLink(PageLink pageLink){
    if ( !  _pageLinks.any( (pageLinkLoop)=> pageLinkLoop.url == pageLink.url) ) {
      _pageLinks.add(pageLink);
    }
  }
  
  void removePageLink(String url){
    _pageLinks.removeWhere((pageLinkLoop)=> pageLinkLoop.url == url) ;
  }
  
  List<ActionDescriptor> get actions{
    List<ActionDescriptor> actions = new List<ActionDescriptor>();
    _pageLinks.forEach((pageLink)=> actions.add(pageLink.action) ) ;
    return actions;
  }
    
}