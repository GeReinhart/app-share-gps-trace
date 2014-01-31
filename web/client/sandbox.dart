import "dart:html";
import 'spaces.dart';
import "widgets/confirm.dart" ;
import "widgets/events.dart" ;

SpacesLayout layout ;
ConfirmWidget deleteConfirm ;

void main() {
  layout = new SpacesLayout(180,30,35);
  deleteConfirm = new ConfirmWidget("deleteConfirmModal", deleteTrace);
  
  querySelectorAll(".btn-action").onClick.listen((e) {
    deleteConfirm.showConfirmModal();
  });
  
}

void deleteTrace(OKCancelEvent event) {
        window.alert("deleteTrace : ${event.ok}" );
}
