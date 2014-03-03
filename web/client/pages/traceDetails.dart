import "dart:html";
import "dart:convert";
import 'package:bootjack/bootjack.dart';
import 'package:js/js.dart' as js;


import 'page.dart';
import "../controllers.dart" ;
import "../spaces.dart";
import "../forms.dart";
import "../widgets/confirm.dart" ;
import "../events.dart" ;

class TraceDetailsPage extends Page {

  ConfirmWidget _deleteConfirm ;
  
  List<String> keys = new List<String>();
  Map<String,TraceDetails> traceDetailsByKey = new Map<String,TraceDetails>();
  String currentKey = null;
  bool readyToDisplayProfile = false;
  TraceDetails _traceDetailsWaitingToDisplayProfile = null;
  
  TraceDetailsPage(PageContext context): super("trace_details",context,65,40,false){
    _deleteConfirm = new ConfirmWidget("deleteTraceConfirmModal", deleteTrace);
    _initDisplayProfile();
    
    layout.centerMoved.listen((_){
      _moveMap( _ as SpacesPositions);
      moveTraceViewers( _ as SpacesPositions);
    });

    querySelectorAll(".trace-delete-menu").onClick.listen((event){
      _deleteConfirm.showConfirmModal();
    });    
  }
  
  
  void deleteTrace(OKCancelEvent event) {
  
    if (event.cancel){
      return;
    }
    layout.startLoading();
    
    HttpRequest request = new HttpRequest();
    
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {
  
        DeleteTraceForm form = new DeleteTraceForm.fromJson(JSON.decode(request.responseText));
        var message = querySelector(".form-error-message");
        if (form.success){
          window.location.assign('/#trace_search');
        }
        
        layout.stopLoading();
      }
    });
  
    request.open("POST",  "/j_trace_delete", async: false);
    
    DeleteTraceForm form =  new  DeleteTraceForm( querySelector("[data-key]").attributes["data-key"] );
    request.send(JSON.encode(form.toJson()));
  
  }
  

  void _moveMap(SpacesPositions spacesPositions ){
    
    Element map = querySelector("#trace-details-map-canvas") ;
    if (map != null){
        map..style.position = 'absolute'
            ..style.right  = "0px"
            ..style.top    = "0px"
            ..style.width  = (spacesPositions.spaceSE_Width).toString() + "px"
            ..style.height = (spacesPositions.spaceSE_Height).toString() + "px" ;
        
        js.context.traceDetailsMap.refreshTiles();
    }
  }
  
  void _moveProfile(SpacesPositions spacesPositions){
    Element traceProfileViewer = querySelector("#traceProfileViewer") ;
    if (traceProfileViewer != null && currentKey != null){
     
      num traceHeightWidthRatio = traceDetailsByKey[currentKey].traceHeightWidthRatio;
      num traceProfileViewerWidth = spacesPositions.spaceNE_Width  ;
      num traceProfileViewerHeight = traceProfileViewerWidth * traceHeightWidthRatio * 10;
      
      if (  traceProfileViewerHeight >  spacesPositions.spaceNE_Height ){
        traceProfileViewerWidth = traceProfileViewerHeight / traceHeightWidthRatio / 10  ;
        traceProfileViewerHeight = spacesPositions.spaceNW_Height ;
      }
      
      traceProfileViewer..style.position = 'absolute'
      ..style.right  = "0px" 
      ..style.top    = "0px" 
      ..style.width  = ( spacesPositions.spaceNE_Width  ).toString() + "px" 
      ..style.height = ( spacesPositions.spaceNE_Height ).toString() + "px" ;      
    }
  }
  
  void moveTraceViewers(SpacesPositions spacesPositions ){

    _moveProfile( spacesPositions);
    Element traceProfileViewer = querySelector("#traceProfileViewer") ;
    if (traceProfileViewer != null && currentKey != null){
      _drawProfile(traceDetailsByKey[currentKey]) ;
    }
    
    Element traceStatisticsViewer = querySelector("#traceStatisticsViewer") ;
    if (traceStatisticsViewer != null){
      traceStatisticsViewer..style.position = 'absolute'
      ..style.right  = (spacesPositions.spaceSW_Width  * 0.10 ).toString() + "px" 
      ..style.top    = (spacesPositions.spaceSW_Height * 0.10 ).toString() + "px" 
      ..style.width  = (spacesPositions.spaceSW_Width  * 0.70 ).toString() + "px" 
      ..style.height = (spacesPositions.spaceSW_Height * 0.70 ).toString() + "px" ;
    }
    
  }

  bool canShowPage(PageParameters pageParameters){
    if (pageParameters.pageName == null){
      return false;
    }
    return pageParameters.pageName.startsWith("trace_details") ;
  }

  void showPage( PageParameters pageParameters) {
    organizeSpaces();
    _moveMap(layout.postions);
    
    String key = pageParameters.pageName.substring( "trace_details_".length  ) ;
    String keyJsSafe = _transformJsSafe(key) ;
    loadingNE.startLoading();
    loadingSE.startLoading();

    
    
    if(   keys.contains(key)    ){
      showBySelector( "#${name}NW_${keyJsSafe}");
      showBySelector( "#${name}SW_${keyJsSafe}");
      loadingNE.stopLoading();
      loadingSE.stopLoading();
      _displayProfile( traceDetailsByKey[key] );
      showBySelector("#${name}NE");
      _displayMap( traceDetailsByKey[key] );
      this.currentKey = key;
    }else{
      _showPage( key);       
    }
  }
 
 String _transformJsSafe(String input){
   return input.replaceAll("/", "_").replaceAll("'", "-");
 }
  
 void _showPage(String key){
    
    String keyJsSafe = _transformJsSafe(key) ;
    loadingNW.startLoading();
    loadingSW.startLoading();
    HttpRequest request = new HttpRequest();
    request.onReadyStateChange.listen((_) {
      
      if (request.readyState == HttpRequest.DONE ) {
        TraceDetails traceDetails = new TraceDetails.fromMap(JSON.decode(request.responseText));
        traceDetailsByKey[key] = traceDetails;
        keys.add(key);
        this.currentKey = key;
        
        Element nwFragment  =_injectInDOMCloneEmptyElement("${name}NW",  keyJsSafe ) ;
        _displayData("trace-details-title",keyJsSafe,traceDetails.title) ;
        _displayData("trace-details-activities",keyJsSafe,traceDetails.activities) ;
        _displayData("trace-details-description",keyJsSafe,traceDetails.descriptionToRender) ;
        _displayData("trace-details-creator",keyJsSafe,traceDetails.creator) ;
        _displayData("trace-details-lastupdate",keyJsSafe,traceDetails.lastupdate) ;
        nwFragment.classes.remove("gx-hidden") ;
        loadingNW.stopLoading();
        
        
        Element swFragment  =_injectInDOMCloneEmptyElement("${name}SW",  keyJsSafe ) ;
        _displayData("trace-details-lengthKmPart",keyJsSafe,"${traceDetails.lengthKmPart} km") ;
        _displayData("trace-details-lengthMetersPart",keyJsSafe,"${traceDetails.lengthMetersPart} m") ;
        _displayData("trace-details-up",keyJsSafe, "${traceDetails.up} m") ;
        _displayData("trace-details-inclinationUp",keyJsSafe,"${traceDetails.inclinationUp} %") ;
        _displayData("trace-details-upperPointElevetion",keyJsSafe,"${traceDetails.upperPointElevetion} m") ;
        _displayData("trace-details-difficulty",keyJsSafe,"${traceDetails.difficulty} points") ;
        swFragment.classes.remove("gx-hidden") ;
        loadingSW.stopLoading();
        
        _displayMap(traceDetails);
        _displayProfile(traceDetails) ;
        showBySelector("#${name}NE");
        
        

      }
    });
    request.open("GET",  "/j_trace_details/${key}", async: true);
    request.send();      
  }
 
 Element _injectInDOMCloneEmptyElement(String selectorId, String keyJsSafe ){
   Element original = querySelector("#${selectorId}") ;
   Element clone =  original.clone(true) ;
   clone.setAttribute("id", "${selectorId}_${keyJsSafe}") ;
   original.parentNode.append(clone);
   return clone ;
 }
  
 void _displayData(String classSelector, String key, String data){
   bool first= true ;
   querySelectorAll(".${classSelector}").forEach((e){
     Element element = e as Element;
     if( !first   && (element.id == null || element.id.isEmpty) ){
       element.setAttribute("id", "${name}NW_${key}_${classSelector}") ;
       element.setInnerHtml(data) ;
     }
     first = false;
   }) ;
 }
 
 void _displayMap(TraceDetails traceDetails){
   js.context.traceDetailsMap.addMarkerToMap( traceDetails.keyJsSafe, traceDetails.mainActivity , traceDetails.titleJsSafe, traceDetails.startPointLatitude,traceDetails.startPointLongitude,traceDetails.gpxUrl );
   js.context.traceDetailsMap.viewGpxByKey(traceDetails.keyJsSafe) ;
   js.context.traceDetailsMap.refreshTiles();
   showBySelector("#${name}SE", hiddenClass: "gx-hidden-map");
   loadingSE.stopLoading();
 }
 
 void _displayProfile(TraceDetails traceDetails){
   if (readyToDisplayProfile){
     _drawProfile(traceDetails); 
   }else{
     _traceDetailsWaitingToDisplayProfile = traceDetails;
   }
 }
 
 void _initDisplayProfile(){
   js.context.google.load('visualization', '1', 
       js.map(
         {
           'packages': ['corechart'],
           'callback': () { 
             this.readyToDisplayProfile = true;
             if(_traceDetailsWaitingToDisplayProfile!=null){
              _drawProfile( _traceDetailsWaitingToDisplayProfile);
             }
           }
         }
       )
   );
 }
 
 void _drawProfile(TraceDetails traceDetails) {
   
   _moveProfile(layout.postions);
   var gviz = js.context.google.visualization;
   var listData = [
                   ['Distance', 'Altitude', 'Altitude','Altitude', 'Altitude', 'Altitude' , 'Altitude' , 'Altitude' ]
                  ] ;
   
   num numPixPerLength         =  traceDetails.length /  layout.postions.spaceNE_Width ;
   num skyElevetionInMeters    =  layout.postions.spaceNE_Height * numPixPerLength / 10;
   
   if ( skyElevetionInMeters + 300 <  traceDetails.upperPointElevetion) {
     skyElevetionInMeters = traceDetails.upperPointElevetion.round() + 500 ;
   }
   
   traceDetails.profilePoints.forEach((point){
     listData.add(  [ point.distanceInMeters,
                      skyElevetionInMeters,
                      point.elevetionInMeters,
                      point.getSnowInMeters(skyElevetionInMeters),
                      point.scatteredInMeters,
                      point.thornyInMeters,
                      point.leafyInMeters,
                      point.meadowInMeters  ] ) ;
   });
   
   var arrayData = js.array(listData);

   var tableData = gviz.arrayToDataTable(arrayData);

   // "chartArea":{"left":"15%","top":"5%","width":"75%","height":"80%"},
   var options = js.map({
     "backgroundColor": {"stroke" : "#5B6DE3", "strokeWidth":"0","fill":"#5B6DE3"},
     "width": layout.postions.spaceNE_Width,
     "height": layout.postions.spaceNE_Height,
     "axisTitlesPosition" : "none",
     "tooltip" : {"trigger":"none"},
     "chartArea":{"left":"0%","top":"0%","width":"100%","height":"100%"},
     "hAxis" : {"gridlines" : { "count" : "0" }},
     "vAxis" : {"gridlines" : { "count" : "0"  }},
     "curveType": "function",
     "series": [
                {"color": '#5B6DE3', "lineWidth": 0, "areaOpacity": 1,  "visibleInLegend": false},
                {"color": 'black', "lineWidth": 1, "areaOpacity": 1,  "visibleInLegend": false},
                {"color": 'white', "lineWidth": 0, "areaOpacity": 1,  "visibleInLegend": false},
                {"color": '#C2A385', "lineWidth": 0, "areaOpacity": 1,  "visibleInLegend": false},
                {"color": '#4C8033', "lineWidth": 0, "areaOpacity": 1,  "visibleInLegend": false},
                {"color": '#99FF66', "lineWidth": 0, "areaOpacity": 1,  "visibleInLegend": false},
                {"color": '#FFE066', "lineWidth": 0, "areaOpacity": 1,  "visibleInLegend": false}
                ]
  });
   
  var chart = new js.Proxy(gviz.AreaChart, querySelector('#traceProfileViewer'));
 
   
  Element traceProfileViewer = querySelector("#trace_detailsNE") ;
 
   
  traceProfileViewer.onMouseMove.listen((e){
    
    Element verticalLine = querySelector("#traceProfileViewer-vertical-line") ;
    var cli = chart.getChartLayoutInterface();
    var chartAreaBoundingBox = cli.getChartAreaBoundingBox() ;
    var clientX =  e.client.x - ( window.innerWidth - layout.postions.spaceNE_Width )  ;  
    
    verticalLine.style.position = 'absolute';
    verticalLine.style.zIndex = '1000';
    verticalLine.style.width = '1px';
    verticalLine.style.backgroundColor = 'black';
    
    int index = ( clientX / layout.postions.spaceNE_Width * traceDetails.profilePoints.length ).toInt() ;
    
    if (  index >= 0 && index < traceDetails.profilePoints.length  ){
      ProfilePoint profilePoint = traceDetails.profilePoints[index] ;
      int valueX =   profilePoint.elevetionInMeters  ;
      int valueY =   profilePoint.distanceInMeters  ;
      
      var elevetion = "${valueX}m" ;
      var distance = "${(valueY/1000).truncate()}km&nbsp;${( valueY- (valueY/1000).truncate()*1000)}m " ;

      verticalLine.style.left = "${clientX}px";
      verticalLine.style.top = "${(cli.getChartAreaBoundingBox().top +traceProfileViewer.offsetTop)}px"; ;
      verticalLine.style.height = "${cli.getChartAreaBoundingBox().height}px";
      verticalLine.setInnerHtml("<span style='border-style: solid; border-width:1px; background-color:white; '  >&nbsp;${distance}&nbsp;${elevetion}&nbsp;</span>",
                                validator: buildNodeValidatorBuilderForSafeHtml());
      
      js.context.traceDetailsMap.moveMarker(traceDetails.keyJsSafe,profilePoint.latitude,profilePoint.longitude); 
      
    }
      //var event = new CustomEvent("name-of-event", { "detail": {"valueX": valueX, "valueY" : valueY }});
      //document.dispatchEvent(event);
      
  
    
    
  });
  
   
   /*
    *         var runOnce = google.visualization.events.addListener(chart, 'ready', function () {
            google.visualization.events.removeListener(runOnce);
            // create mousemove event listener in the chart's container
            // I use jQuery, but you can use whatever works best for you        
        
            $('#chart_div_ts_count').mousemove(function (e) {

              
              var verticalLine = $('#vertical-line') ;
              var cli = chart.getChartLayoutInterface();
              var chartAreaBoundingBox = cli.getChartAreaBoundingBox() ;
                var clientX = e.clientX;
              
              verticalLine.css('position','absolute');
              verticalLine.css('z-index',1000);
              verticalLine.css('width','1px');
              verticalLine.css('background-color','black');
              
              if (   clientX >=  chartAreaBoundingBox.left +  container.offsetLeft  &&
                   clientX <=  chartAreaBoundingBox.left +  container.offsetLeft + chartAreaBoundingBox.width   
                   ){
                var clientChartX = clientX - chartAreaBoundingBox.left - container.offsetLeft ;
                    var index = Math.round( clientChartX / chartAreaBoundingBox.width * data.getNumberOfRows() ) ;
                    var valueX = data.getValue(index,1) ;
                    var valueY = data.getValue(index,0) ;
                    
                    verticalLine.css('left',clientX);
                verticalLine.css('top',cli.getChartAreaBoundingBox().top +container.offsetTop     );
                verticalLine.css('height',cli.getChartAreaBoundingBox().height);
                verticalLine.empty();
                verticalLine.append("<span style='border-style: solid; border-width:1px; background-color:white; '  >&nbsp;"+ valueX +"&nbsp;"+ valueY +"&nbsp;</span>");
                
                
                var event = new CustomEvent("name-of-event", { "detail": {"valueX": valueX, "valueY" : valueY }});
                document.dispatchEvent(event);
                
              }
              
          }); 
        
        });
    * */
   
   
   
   
   
   chart.draw(tableData, options);
   
   loadingNE.stopLoading();
 }
 
 
 
 void hidePage() {
    String keyJsSafe = _transformJsSafe(currentKey) ;
    hideBySelector("#${name}SE", hiddenClass: "gx-hidden-map");
    hideBySelector("#${name}NE");
    hideBySelector("#${name}NW_${keyJsSafe}");
    hideBySelector("#${name}SW_${keyJsSafe}");
 }
 
 
}


void main() {
  TraceDetailsPage page = new TraceDetailsPage(new PageContext());
}




