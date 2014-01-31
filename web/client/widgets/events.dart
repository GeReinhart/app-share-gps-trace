
import 'dart:async';

typedef void OkCancelCallBack(OKCancelEvent event);

class OKCancelEvent{
  bool _ok ;
  
  OKCancelEvent(this._ok);
  
  bool get ok => _ok;
  bool get cancel => !_ok;
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