
import "dart:html";
import "widget.dart" ;

abstract class LoadingShower{
  void startLoading();
  void stopLoading();
}


class LoadingWidget extends Widget implements LoadingShower{
  
  LoadingWidget(String id) : super(id);

  void startLoading() {
    querySelector("#${id}").classes.remove("gx-hidden");
  }

  void stopLoading() {
    querySelector("#${id}").classes.add("gx-hidden");
  }
}
