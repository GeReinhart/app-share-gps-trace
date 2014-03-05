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

    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> skyElevetionInMeters , lowestElevetion,skyElevetionInMeters ,  "#5B6DE3", "#5B6DE3",0));    
    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> p.elevetionInMeters , lowestElevetion,skyElevetionInMeters ,  "black", "none",2));    
    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> p.getSnowInMeters(skyElevetionInMeters)-1 , lowestElevetion,skyElevetionInMeters ,  "white", "white",0));    
    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> p.scatteredInMeters -1 , lowestElevetion,skyElevetionInMeters ,  "#C2A385", "#C2A385",0));    
    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> p.thornyInMeters-1 , lowestElevetion,skyElevetionInMeters ,  "#4C8033", "#4C8033",0));    
    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> p.leafyInMeters-1 , lowestElevetion,skyElevetionInMeters ,  "#99FF66", "#99FF66",0));    
    svgGroup.nodes.add(buildProfileFragment(tracedetails, (p)=> p.meadowInMeters-1 , lowestElevetion,skyElevetionInMeters ,  "#FFE066", "#FFE066",0));    
    
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
    
    var line = new SvgElement.tag("polyline");

    String points = "0,${height} "  ;
    for (var i = 0; i < tracedetails.profilePoints.length; i++) {
      int x = getXPosition(tracedetails, i);
      int y = getYPosition(tracedetails,  elevetionValue(tracedetails.profilePoints[i]),lowestElevetion,heighestElevetion ) ;
      points += "${x},${y} " ;
    }
    points += "${width},${height}" ;
    
    line.attributes = {
                       "points" : points,
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
  
  int getXPosition(TraceDetails tracedetails, int profilePointIndex){
    int numberOfPoints = tracedetails.profilePoints.length;
    int numberOfAvailablePixels = width ;
    return (profilePointIndex * numberOfAvailablePixels /numberOfPoints).round();
  }
  
  int getYPosition(TraceDetails tracedetails, int elevetion, int lowestElevetion, int heighestElevetion){
    int elevetionRange = heighestElevetion - lowestElevetion + SKY_HEIGHT_IN_METERS;
    int numberOfAvailablePixels = height ;
    return height - ( (elevetion - lowestElevetion ) * numberOfAvailablePixels /elevetionRange).round();
  }
  
  
}
