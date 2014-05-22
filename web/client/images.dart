

class ImageUrlProvider{
  
  List<String> _colors = ["24ab18","222da8","c71e1e","ff8922","a425b8"] ;
  Map<String,String> _lightColors= {"#24ab18":"#9BE895",
                     "#222da8":"#B2B7ED",
                     "#c71e1e":"#E0B6B6",
                     "#ff8922":"#FFDCBD",
                     "#a425b8":"#DBB6E0"} ;

  Map<String,String> _imagesBySubject = {
                       "trek":"hiking.png",
                       "running":"jogging.png",
                       "bike":"cycling.png",
                       "mountainbike":"mountainbiking-3.png",
                       "skitouring":"nordicski.png",
                       "snowshoe":"snowshoeing.png",

                       "start":"parking.png",
                       "end":"stop.png",
                       "water":"drinkingwater.png",
                       "step":"flag-export.png",
                       "camp":"tents.png",
                       "refuge":"home-2.png"
                      } ;
  
  String buildUrlForWatchPoint(String watchPointType){
    String image = _imagesBySubject[watchPointType];
    if (image == null){
      image = _imagesBySubject["step"];
    }
    return buildUrl(  image, "24ab18" , 1  ) ;
    
  }
  
  String buildUrl( String activityImage, String color , int type  ){
    return "/assets/img/icon/${color}/${type}/${activityImage}" ;
  }
  
  
}