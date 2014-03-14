import 'page.dart';
import '../spaces.dart';
import '../actions.dart';

class DisclaimerPage extends Page {
  
  DisclaimerPage(PageContext context): super("disclaimer",context,25,75,false){
    description = "Mentions légales et conditions d'utilisation" ;
    layout.centerMoved.listen((_){
      updateNWPostion("#${name}NW");
    });
  }
  
  bool canBeLaunched(String login, bool isAdmin ) => true;
  
  bool canBeLaunchedFromMainMenu()=> false;
  
  void showPage( Parameters pageParameters) {
    super.showPage(pageParameters);
    header.title = description ;
    organizeSpaces();
    getAndShowElement("/f_legal_disclaimer", "#${name}NW");
    getAndShowElement("/f_legal_terms", "#${name}NE");
  }
}
