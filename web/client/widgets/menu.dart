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
  
  void resetMenu(List<ActionDescriptor> firstSection, List<ActionDescriptor> secondSection) {
    
    Element menu = querySelector("#${id} ul");
    menu.children.clear();
    
    if (  firstSection!= null){
      firstSection.forEach((action){
        menu.append(_buildItemMenu(action)) ;
      });
    }
    if (  secondSection != null && secondSection.isNotEmpty){
      menu.append(_buildDivider()) ;
      secondSection.forEach((action){
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
    link.style.textIndent = "0%" ;
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

