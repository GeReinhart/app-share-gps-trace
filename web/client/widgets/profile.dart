import "dart:html";
import "dart:svg";
import "widget.dart" ;
import "../forms.dart";


typedef int ElevetionValue(ProfilePoint profilePoint);


class ProfileWidget extends Widget {
  
  ProfileWidget(String id) : super(id);
  
  static int SKY_HEIGHT_IN_METERS = 500 ; 

  void reset(){
    querySelector("#${id}").children.clear();
  }
  
  void show(TraceDetails tracedetails){
    
    this.reset();
    
    var svgGroup = new SvgElement.tag("g");
    
    int lowestElevetion      = getLowestPoint(tracedetails);
    int heighestElevetion    = getHeighestPoint(tracedetails);
    int skyElevetionInMeters = getSkyElevetion(tracedetails) ;

    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> skyElevetionInMeters , lowestElevetion,skyElevetionInMeters ,  "none", "#5B6DE3",0));    
    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> p.elevetionInMeters , lowestElevetion,skyElevetionInMeters ,  "none", "black",1));    
    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> p.getSnowInMeters(skyElevetionInMeters) , lowestElevetion,skyElevetionInMeters ,  "none", "white",0));    
    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> p.scatteredInMeters  , lowestElevetion,skyElevetionInMeters ,  "none", "#C2A385",0));    
    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> p.thornyInMeters , lowestElevetion,skyElevetionInMeters ,  "none", "#4C8033",0));    
    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> p.leafyInMeters , lowestElevetion,skyElevetionInMeters ,  "none", "#99FF66",0));    
    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> p.meadowInMeters , lowestElevetion,skyElevetionInMeters ,  "none", "#FFE066",0));    
    
    SvgElement svg = new SvgElement.tag('svg');
    svg.nodes.add(svgGroup);
    svg.attributes = {
       "height": "${height}",
       "width": "${width}",
       "version": "1.1"
    };
    querySelector("#${id}").nodes.add(svg);
  }
  
  SvgElement buildProfileFragment(TraceDetails tracedetails, ElevetionValue elevetionValue,
                                    int lowestElevetion, int heighestElevetion,
                                    String color, String fillColor, int strokeWidth){
    
    var line = new SvgElement.tag("path");

    String points = "M0,${height} "  ;
    for (var i = 0; i < tracedetails.profilePoints.length; i++) {
      num x = getXPosition(tracedetails, i);
      num y = getYPosition(tracedetails,  elevetionValue(tracedetails.profilePoints[i]),lowestElevetion,heighestElevetion ) ;
      points += "L${x},${y} " ;
    }
    points += "L${width},${height} Z" ;
    
    line.attributes = {
                       "d" : points,
                       "style": "fill:${fillColor};stroke:${color};stroke-width:${strokeWidth}"
    };    
    return line;
  }
  
  int getSkyElevetion(TraceDetails tracedetails){
       num numberOfMeterPerPixel = tracedetails.length / width;
       num skyElevetionInMeters  = (height * numberOfMeterPerPixel / 10) + SKY_HEIGHT_IN_METERS;
       
       if ( skyElevetionInMeters + 300 < tracedetails.upperPointElevetion) {
	   skyElevetionInMeters = tracedetails.upperPointElevetion + SKY_HEIGHT_IN_METERS ;
       }
       return skyElevetionInMeters.round();
  }

  
  int getLowestPoint(TraceDetails tracedetails){
    int lowestElevetion = tracedetails.profilePoints.first.elevetionInMeters ;
    tracedetails.profilePoints.forEach((p){
      if(p.elevetionInMeters<lowestElevetion){
        lowestElevetion = p.elevetionInMeters;
      }
    });
    return lowestElevetion;
  }
  
  int getHeighestPoint(TraceDetails tracedetails){
    int heighestElevetion = tracedetails.profilePoints.first.elevetionInMeters ;
    tracedetails.profilePoints.forEach((p){
      if(p.elevetionInMeters>heighestElevetion){
        heighestElevetion = p.elevetionInMeters;
      }
    });
    return heighestElevetion;
  }
  
  num getXPosition(TraceDetails tracedetails, int profilePointIndex){
    num numberOfPoints = tracedetails.profilePoints.length;
    num numberOfAvailablePixels = width ;
    return (profilePointIndex * numberOfAvailablePixels /numberOfPoints);
  }
  
  num getYPosition(TraceDetails tracedetails, int elevetion, int lowestElevetion, int heighestElevetion){
    num elevetionRange = heighestElevetion - lowestElevetion + SKY_HEIGHT_IN_METERS;
    num numberOfAvailablePixels = height ;
    return height - ( (elevetion - lowestElevetion ) * numberOfAvailablePixels /elevetionRange);
  }
  
  
}
