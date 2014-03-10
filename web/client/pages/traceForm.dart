
import 'page.dart';

class TraceFormPage extends Page {
  
  TraceFormPage(PageContext context): super("trace_form",context,20,80,false){
    layout.centerMoved.listen((_){
      updateNWPostion("#${name}NW");
    });
  }
  
  void showPage( PageParameters pageParameters) {
    header.title = "Ajout d'une trace gpx" ;
    organizeSpaces();
    getAndShowElement("/f_trace_add_form","#${name}NW");

  }
  
}

