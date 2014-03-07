import "dart:html";
import 'dart:async';

import "widget.dart" ;
import "modal.dart" ;
import "../events.dart" ;

class HeaderWidget extends Widget  {
  
  HeaderWidget(String id  ): super(id){
    _updateWidget();
    window.onResize.listen((_)=>_updateWidget());
  }
  
  void _updateWidget(){
    updatePosition(0, 0, window.innerWidth, 40) ;
    widgetElement.style..zIndex = "200"
                       ..position = "absolute"
                       ..textAlign = "center"
                       ..backgroundColor = "#C2E0FF" ;
    
    querySelector("#${id}-title").style..zIndex = "200"
        ..top = "0px"
        ..margin = "0px"
        ..padding = "0px"
        .. width = "100%"
        ..position = "absolute"
        ..textAlign = "center" ;
  }
  
  void set title(String value) {
    querySelector("#${id}-title").innerHtml= value;
  }
  
  
}