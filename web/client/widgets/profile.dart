import "dart:html";
import "dart:svg";
import "widget.dart" ;
import "../forms.dart";


class ProfileWidget extends Widget {
  
  ProfileWidget(String id) : super(id);


  void reset(){
    querySelector("#${id}").children.clear();
  }
  
  void show(TraceDetails tracedetails){
    
    
    var svgGroup = new SvgElement.tag("g");
    
    int lowestElevetion   = getLowestPoint(tracedetails);
    int heighestElevetion = getHeighestPoint(tracedetails);
    
    var profileLine = new SvgElement.tag("polyline");

    String points = "" ;
    for (var i = 0; i < tracedetails.profilePoints.length; i++) {
      int x = getXPosition(tracedetails, i);
      int y = getYPosition(tracedetails, i,lowestElevetion,heighestElevetion ) ;
      points += "${x},${y}" ;
      if (i < tracedetails.profilePoints.length){
        points += " " ;
      }
    }
    
    profileLine.attributes = {
                       "points" : points,
                       "style": "fill:none;stroke:black;stroke-width:1"
    };
    
    svgGroup.nodes.add(profileLine);
    
    SvgElement svg = new SvgElement.tag('svg');
    svg.nodes.add(svgGroup);
    svg.attributes = {
       "height": "${height}",
       "width": "${width}",
       "version": "1.1"
    };
    querySelector("#${id}").nodes.add(svg);
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
  
  int getYPosition(TraceDetails tracedetails, int profilePointIndex, int lowestElevetion, int heighestElevetion){
    int elevetionRange = heighestElevetion - lowestElevetion + 500;
    int numberOfAvailablePixels = height ;
    return height - ( (tracedetails.profilePoints[profilePointIndex].elevetionInMeters - lowestElevetion ) * numberOfAvailablePixels /elevetionRange).round();
  }
  
  
}