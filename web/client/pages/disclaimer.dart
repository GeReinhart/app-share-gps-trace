import 'page.dart';

class DisclaimerPage extends Page {
  
  DisclaimerPage(): super("disclaimer",180,25,75);
  
  void showPage() {
    layout.moveCenterInitialPosition();
    loadingNW.startLoading();
    showBySelector("#${name}NW");
    loadingNW.stopLoading();
  }
}


