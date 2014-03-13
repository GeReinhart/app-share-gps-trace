import "dart:html";
import "widget.dart" ;
import "../events.dart" ;
import "../controllers.dart" ;
import "../actions.dart" ;


class MenuWidget extends Widget{
  
  
  MenuWidget(String id): super(id){
    widgetElement.onClick.listen((e){
        this.toggleMenu();
    });  
  }
  
  
  void _showMenu(String menuSelector){
    Element menu =querySelector(menuSelector);
    menu.classes.remove("open");
  }
  
  void _hideMenu(String menuSelector){
    Element menu =querySelector(menuSelector);
    menu.classes.add("open");
  }
  
  void toggleMenu(){
    if ( widgetElement.classes.contains("open") ){
      _showMenu("#${id}") ;
    }else{
      _hideMenu("#${id}") ;
    }
  }
  
  void resetMenu(List<ActionDescriptor> mainApplicationMenu, List<ActionDescriptor> currentPageMenu) {
    
    Element menu = querySelector("#${id} ul");
    menu.children.clear();
    
    if (  mainApplicationMenu!= null){
      mainApplicationMenu.forEach((action){
        menu.append(_buildItemMenu(action)) ;
      });
    }
    if (  currentPageMenu != null && currentPageMenu.isNotEmpty){
      menu.append(_buildDivider()) ;
      currentPageMenu.forEach((action){
        menu.append(_buildItemMenu(action)) ;
      });
    }
  }

  LIElement _buildDivider() {
    LIElement divider = new LIElement();
    divider.attributes["role"] = "presentation" ;
    divider.classes.add("divider") ;
    return divider;
  }

  LIElement _buildHeader(String header) {
    LIElement headerElement = new LIElement();
    headerElement.attributes["role"] = "presentation" ;
    headerElement.classes.add("dropdown-header") ;
    headerElement.appendText(header);
    return headerElement;
  }
  
  LIElement _buildItemMenu(ActionDescriptor action) {
    LIElement li = new LIElement();
    li.classes.add("gx-as-link");
    AnchorElement link = new AnchorElement();
    link.attributes["role"] = "menuitem";
    link.attributes["tabindex"] = "-1";
    link.appendText(action.description) ;

    if (action.windowTarget != null){
      link.target = action.windowTarget ;
    }
    if (action.nextPage != null){
      link.href = action.nextPage ;
    }
    if(action.launchAction != null){
      link.onClick.listen((event){
        action.launchAction(null);
      });
    }
    li.append(link);
    return li;
  }
}

/*
<div id="menu-when-anonymous" class="space-menu open" style="position: relative; top: 40px; z-index: 102;"> 
<ul role="menu" class="dropdown-menu">
<li role="presentation" class="dropdown-header">Traces gps</li>
<li role="presentation"><a href="/#trace_search" tabindex="-1" role="menuitem">Rechercher</a></li>
<li class="divider" role="presentation"></li>
<li role="presentation" class="dropdown-header">Compte</li>
<li role="presentation"><a id="menu-login" class="gx-as-link" tabindex="-1" role="menuitem">Se connecter</a></li>
<li role="presentation"><a id="menu-register" class="gx-as-link" tabindex="-1" role="menuitem">S'enregistrer</a></li>
</ul>
</div>



<div id="menu" style="position: relative; top: 40px;" class="open">
      <ul role="menu" class="dropdown-menu"><li role="presentation" class="dropdown-header">Actions</li><li class="gx-as-link"><a role="menuitem" tabindex="-1">Rechercher une trace gps</a></li><li role="presentation" class="divider"></li><li role="presentation" class="dropdown-header">Page courante</li><li class="gx-as-link"><a role="menuitem" tabindex="-1">Téléchargement du fichier gpx</a></li></ul>
</div>
*/