import "dart:html";
import '../spaces.dart';
import 'page.dart';
import '../widgets/login.dart' ;
import '../widgets/persistentMenu.dart' ;
import '../events.dart' ;
import '../controllers.dart' ;

import 'disclaimer.dart' ;
import 'index.dart' ;
import 'about.dart' ;


void main() {
  List<Page> pages = new List<Page>();
  pages.add(new DisclaimerPage());  
  pages.add(new IndexPage());
  pages.add(new AboutPage());
  PagesController pagesController = new PagesController(pages);
  
}

