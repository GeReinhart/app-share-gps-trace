import "dart:html";
import '../spaces.dart';
import 'page.dart';

class ErrorPage extends Page {
  
  ErrorPage(PageContext context): super("error",context,30,70,false);

  void showPage( PageParameters pageParameters) {
    organizeSpaces();
  }
}


void main() {
  ErrorPage page = new ErrorPage(new PageContext() );
}