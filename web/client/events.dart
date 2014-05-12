
import 'dart:async';
import "pages/page.dart";
import "actions.dart";

typedef void OkCancelCallBack(OKCancelEvent event);
typedef void LoginLogoutCallBack(LoginLogoutEvent event);
typedef void PageChangeCallBack(PageChangeEvent event);


class PageChangeEvent{
  Page page ;
  Parameters pageParameters ;
  bool displayed = true ;
  bool removed = false ;
  bool toBeRemoved = false ;
  bool shouldBeInPageList = false ;
  String url ;
  String title ;
  PageChangeEvent(this.page, this.pageParameters, this.title, this.url, this.shouldBeInPageList);
  
  PageChangeEvent.remove(this.page,this.url){
    displayed = false;
    removed = false ;
    toBeRemoved = true ;
  }
  
  PageChangeEvent.hasBeenRemoved(this.page,this.url){
    displayed = false;
    removed = true ;
    toBeRemoved = false ;
  }
}

class OKCancelEvent{
  bool _ok ;
  
  OKCancelEvent(this._ok);
  
  bool get ok => _ok;
  bool get cancel => !_ok;
}


class LoginLogoutEvent{
  
  String _login;
  String _encryptedPassword;
  bool _admin  = false;
  bool _logout = false;
  
  LoginLogoutEvent.justLoginAs(String login, bool admin , String encryptedPassword){
    this._login = login;
    this._encryptedPassword = encryptedPassword ;
    this._admin = admin;
  }
  
  LoginLogoutEvent.justLogout(){
    _logout = true;
  }
  
  String get login => _login ;
  String get encryptedPassword => _encryptedPassword ;
  bool get isAdmin => _admin ;
  bool get isLogin => !_logout ;
  bool get isLogout => _logout ;
}

class OKCancelEventProducer{
  StreamController _eventStream ;
  
  void initOKCancelEventProducer(){
    _eventStream = new StreamController.broadcast( sync: true);
  }
  
  void setOKCancelEventCallBack( OkCancelCallBack callBack  ){
    _eventStream.stream.listen((event) => callBack(event));
  }
  
  void sendOKEvent(){
    _send(true);
  }

  void sendCancelEvent(){
    _send(false);
  }
  
  void _send( bool ok){
    _eventStream.add(  new OKCancelEvent(ok)  );
  }
  
}

class LoginLogoutEventProducer{
  StreamController _loginLogoutEventStream ;
  
  void initLoginLogoutEventProducer(){
    _loginLogoutEventStream = new StreamController.broadcast( sync: true);
  }
  
  void setLoginLogoutEventCallBack( LoginLogoutCallBack callBack  ){
    _loginLogoutEventStream.stream.listen((event) => callBack(event));
  }
  
  void sendLoginEvent(String login, bool admin, String encryptedPassword){
    _loginLogoutEventStream.add(  new LoginLogoutEvent.justLoginAs(login,admin, encryptedPassword)  );
  }

  void sendLogoutEvent(){
    _loginLogoutEventStream.add(  new LoginLogoutEvent.justLogout()  );
  }
}

