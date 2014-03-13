import "dart:html";
import '../spaces.dart';
import 'page.dart';
import '../actions.dart';

class ErrorPage extends Page {
  
  ErrorPage(PageContext context): super("error",context,30,70,false);
  
  bool canBeLaunched(String login, bool isAdmin ) => true;
  
  bool canBeLaunchedFromMainMenu()=> false;
  
  void showPage( Parameters pageParameters) {
    header.title = "" ;
    organizeSpaces();
  }
}


void main() {
  ErrorPage page = new ErrorPage(new PageContext() );
}