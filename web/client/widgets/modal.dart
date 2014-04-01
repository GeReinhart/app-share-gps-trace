import 'package:bootjack/bootjack.dart';
import "dart:html";

class ModalWidget{
  
  void initModalWidget(){
    Modal.use();
    Transition.use();
  }
  
  void showModalWidget(String id){
    querySelector("#${id}").style.zIndex="10000";
    Modal.wire( querySelector("#${id}") ).show() ;
  }

  void hideModalWidget(String id){
    querySelector("#${id}").style.zIndex="0";
    Modal.wire( querySelector("#${id}") ).hide() ;
  }
  
}