
import 'page.dart';
import '../spaces.dart';
import '../actions.dart';

class AboutPage extends Page {

  AboutPage(PageContext context): super("about",context,50,50,false){
    description = "A propos" ;
    layout.centerMoved.listen((_){
      updateNEPostion("#${name}NE");
      updateNWPostion("#${name}NW");
      updateSEPostion("#${name}SE");
      updateSWPostion("#${name}SW");
    });
  
  }
  
  bool canBeLaunched(String login, bool isAdmin ) => true;
  
  bool canBeLaunchedFromMainMenu()=> false;

  void showPage( Parameters pageParameters) {
    super.showPage(pageParameters);
    header.title = description ;
    organizeSpaces();
    getAndShowElement("/f_about_application", "#${name}NW");
    getAndShowElement("/f_about_dev", "#${name}NE");
    getAndShowElement("/f_about_feedbacks", "#${name}SW");
    getAndShowElement("/f_about_author", "#${name}SE");
  }
}


