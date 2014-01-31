import "dart:html";
import 'spaces.dart';

void main() {
  SpacesLayout layout = new SpacesLayout(180,30,70);
  
  querySelectorAll(".btn-login").onClick.listen((e) {
    window.location.href = "/login";
  });
  querySelectorAll(".btn-register").onClick.listen((e) {
    window.location.href = "/register";
  });
  querySelectorAll(".btn-add").onClick.listen((e) {
    window.location.href = "/trace.add";
  });
  querySelectorAll(".btn-search").onClick.listen((e) {
    window.location.href = "/trace.search";
  });
}

