import 'page.dart';

class AboutPage extends Page {
  
  AboutPage(): super("about",180,50,50);
  
  void showPage() {
    layout.moveCenterInitialPosition();
    loadingNW.startLoading();
    showBySelector("#${name}NW");
    loadingNW.stopLoading();

    loadingNE.startLoading();
    showBySelector("#${name}NE");
    loadingNE.stopLoading();

    loadingSW.startLoading();
    showBySelector("#${name}SW");
    loadingSW.stopLoading();

    loadingSE.startLoading();
    showBySelector("#${name}SE");
    loadingSE.stopLoading();

  }
}


