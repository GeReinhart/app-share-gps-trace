import 'dart:html';

void main() {
  
  window.onResize.listen(updateSpaces);
  window.onLoad.listen(updateSpaces);
  

}

void updateSpaces(Event event){
  query(".space-north-west")
  ..text = event.toString() ;
}
