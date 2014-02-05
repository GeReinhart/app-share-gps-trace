

import "loading.dart" ;

class Widget{
  
  String _id ;
  LoadingShower _loadingShower ;

  Widget(this._id);
  
  Widget.withLoading(this._id, LoadingShower loadingShower){
    _loadingShower = loadingShower;
  }
  
  String get id => _id;
  
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
  
}
