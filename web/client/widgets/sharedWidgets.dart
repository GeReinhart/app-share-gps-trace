
import "dart:html";

import "widget.dart" ;

class SharedWidgets extends Widget {

  SharedWidgets(String id ) : super(id){
    querySelector("#${id}").classes.remove("gx-hidden") ;
  }
  
}
