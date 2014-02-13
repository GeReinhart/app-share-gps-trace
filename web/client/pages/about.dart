import 'page.dart';
import '../spaces.dart';

class AboutPage extends Page {

  AboutPage(PageContext context): super("about",context,50,50,false);
  
  void showPage() {
    organizeSpaces();
    getAndShowElement("/f_about_application", "#${name}NW");
    getAndShowElement("/f_about_dev", "#${name}NE");
    getAndShowElement("/f_about_feedbacks", "#${name}SW");
    getAndShowElement("/f_about_author", "#${name}SE");
  }
}


