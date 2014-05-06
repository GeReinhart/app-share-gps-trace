

typedef void LaunchAction(Parameter params);

class Parameter{
  String key ;
  String value;
  
  Parameter(this.key,this.value) ;
}

class Parameters{
  List<Parameter> parameters = new List<Parameter>() ;
  String pageName;
  String anchor ;
  
  
  add(String key, String value){
    parameters.add( new Parameter(key,value) ) ;
  }
  
  bool equals(Parameters other){
    return other.anchor == anchor && other.pageName == pageName ;
  }
  
  static Parameters  buildFromAnchor(String anchor){
    Parameters pageParameters = new Parameters();
    
    pageParameters.anchor = anchor;
    int startParameters = anchor.indexOf("?") ;
    if (startParameters == -1){
      pageParameters.pageName = anchor ;
      return pageParameters ;
    }
    pageParameters.pageName = anchor.substring(0,startParameters ) ;
    if( anchor.length <= pageParameters.pageName.length +1 ){
      return pageParameters ;
    }
    String pageParametersAsString = anchor.substring(startParameters + 1,anchor.length  ) ;
    pageParametersAsString.split("&").forEach((s){
       List<String>  paramAndValue = s.split("=");
       if ( paramAndValue.length == 2 ){
         pageParameters.add (paramAndValue[0],paramAndValue[1] );
       }
    }) ;
    return pageParameters;
  }
  
  
  
}

class ActionImages{
  
  String _image;
  String _imageOver;
  
  ActionImages(String image,{  String imageOver:null  }){
    this._image = image;
    this._imageOver = imageOver == null ? image : imageOver  ;
  }
  
  String get image => _image;
  String get imageOver => _imageOver;
}


class ActionDescriptor{
  
  ActionImages images;
  String name;
  String description;
  String windowTarget;
  String nextPage;
  LaunchAction launchAction;
  
}
