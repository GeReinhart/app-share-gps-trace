

typedef void LaunchAction(Parameter params);

class Parameter{
  String key ;
  String value;
  
  Parameter(this.key,this.value) ;
}

class Parameters{
  List<Parameter> parameters = new List<Parameter>() ;
  String pageName;
  
  
  add(String key, String value){
    parameters.add( new Parameter(key,value) ) ;
  }
  
  static Parameters  buildFromAnchor(String anchor){
    Parameters pageParameters = new Parameters();
    
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

class ActionDescriptor{
  
  String name;
  String description;
  String windowTarget;
  String nextPage;
  LaunchAction launchAction;
  
}
