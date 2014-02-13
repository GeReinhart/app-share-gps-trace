
import 'page.dart';

class TraceFormPage extends Page {
  
  TraceFormPage(PageContext context): super("trace_form",context,20,80,false);
  
  void showPage() {
    organizeSpaces();
    getAndShowElement("/f_trace_add_form","#${name}NW");
  }
  
}

