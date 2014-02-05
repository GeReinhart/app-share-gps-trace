import "dart:html";
import '../spaces.dart';
import 'page.dart';
import '../widgets/login.dart' ;
import '../widgets/persistentMenu.dart' ;
import '../events.dart' ;
import '../controllers.dart' ;



class SandBoxPage extends Page {
  
  SandBoxPage(): super(180,30,35){
    querySelectorAll(".btn-action").onClick.listen((e) {
      showLoginModal();
    });
  }
  
}

void main() {
  SandBoxPage page = new SandBoxPage();
}

