import 'package:bootjack/bootjack.dart';
import "dart:html";

class ModalWidget{
  
  void initModalWidget(){
    Modal.use();
  }
  
  void showModalWidget(String id){
    Modal.wire( querySelector("#${id}") ).show() ;
  }

  void hideModalWidget(String id){
    Modal.wire( querySelector("#${id}") ).hide() ;
  }
  
}