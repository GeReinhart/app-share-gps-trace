import "dart:html";
import 'dart:async';
import "dart:convert";
import 'page.dart';
import '../actions.dart';

class TraceFormPage extends Page {
  
  TraceFormPage(PageContext context): super("trace_form",context,20,80,false){
    description = "Ajout d'une trace gpx" ;
    layout.centerMoved.listen((_){
      updateNWPostion("#${name}NW");
    });
    

  }
  
  
  bool canBeLaunched(String login, bool isAdmin ) => login!= null;
  
  bool canBeLaunchedFromMainMenu()=> true;
  
  void showPage( Parameters pageParameters) {
    super.showPage(pageParameters);
    header.title = description ;
    organizeSpaces();
    getAndShowElement("/f_trace_add_form","#${name}NW");
    
  }
  
 
  
}

