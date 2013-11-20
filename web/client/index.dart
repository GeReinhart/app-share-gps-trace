import "dart:html";
import 'spaces.dart';

void main() {
  SpacesLayout layout = new SpacesLayout(180,50,50);
  
  querySelector(".btn-login").onClick.listen((e) {
    window.location.href = "/login";
  });
  
  querySelector(".btn-register").onClick.listen((e) {
    window.location.href = "/register";
  });
}

