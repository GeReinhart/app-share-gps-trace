import 'package:bootjack/bootjack.dart';
import "dart:html";

class ModalWidget{
  
  void initModalWidget(String id){
    Modal.use();
    Transition.use();
    hideModalWidget(id) ;
  }
  
  void showModalWidget(String id){
    querySelector("#${id}").style.zIndex="10000";
    querySelector("#${id}").style.top="100px";
    Modal.wire( querySelector("#${id}") ).show() ;
  }

  void hideModalWidget(String id){
    querySelector("#${id}").style.zIndex="0";
    querySelector("#${id}").style.top="5000px";
    Modal.wire( querySelector("#${id}") ).hide() ;
  }
  
}