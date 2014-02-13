

import "loading.dart" ;

class Widget{
  
  String _id ;
  LoadingShower _loadingShower ;

  Widget(this._id);
  
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
  
  void set loadingShower (LoadingShower loadingShower){
    this._loadingShower = loadingShower;
  }
}
