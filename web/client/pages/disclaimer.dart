import 'page.dart';
import '../spaces.dart';

class DisclaimerPage extends Page {
  
  DisclaimerPage(PageContext context): super("disclaimer",context,25,75,false){
  
    layout.centerMoved.listen((_){
      updateNWPostion("#${name}NW");
    });
  }
  
  void showPage( PageParameters pageParameters) {
    organizeSpaces();
    getAndShowElement("/f_disclaimer_text", "#${name}NW");
  }
}


