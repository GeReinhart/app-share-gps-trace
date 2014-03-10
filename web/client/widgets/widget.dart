
import "dart:html";
import "loading.dart" ;

class Widget{
  
  String _id ;
  LoadingShower _loadingShower ;

  int top;
  int right;
  int width;
  int height;
  
  Widget(this._id);
  
  String get id => _id;
  
  void updatePosition(int top, int right, int width, int height){
    this.top= top;
    this.right = right;
    this.width = width;
    this.height = height;
    
    querySelectorAll("#${id}").forEach((e){
      Element element = e as Element ;
      element.style.height = "${height}px" ;
      element.style.width = "${width}px" ;
      element.style.top = "${top}px" ;
      element.style.right = "${right}px" ;
    });
    
  }
  
  void startLoading(){
    if (_loadingShower != null){
      _loadingShower.startLoading();
    }
  }

  void stopLoading(){
    if (_loadingShower != null){
      _loadingShower.stopLoading();
    }
  }
  
  void showBySelector(String selector, {String hiddenClass:"gx-hidden"}){
    querySelectorAll(selector).forEach((e){
      Element element = e as Element ;
      e.classes.remove(hiddenClass) ;
    });
  }
  
  void hideBySelector(String selector, {String hiddenClass:"gx-hidden"}){
    querySelectorAll(selector).forEach((e){
      Element element = e as Element ;
      e.classes.add(hiddenClass) ;
    });
  }  

  
  Element get widgetElement => querySelector("#${id}") ;
  
  
  void set loadingShower (LoadingShower loadingShower){
    this._loadingShower = loadingShower;
  }
  
  NodeValidatorBuilder buildNodeValidatorBuilderForSafeHtml(){
    final NodeValidatorBuilder _htmlValidator=new NodeValidatorBuilder.common()
    ..allowElement('form', attributes: ['role','accept-charset'])
    ..allowElement('table', attributes: ['style'])
    ..allowElement('span', attributes: ['style'])
    ..allowElement('a', attributes: ['href','rel'])
    ..allowElement('img', attributes: ['src','style'])
    ..allowElement('div', attributes: ['style'])
    ..allowElement('input', attributes: ['style'])
    ..allowElement('textarea', attributes: ['style'])
    ..allowElement('th', attributes: ['width'])
    ..allowElement('script')
    ..allowElement('td', attributes: ['style']);
    return _htmlValidator;
  }
  
}
