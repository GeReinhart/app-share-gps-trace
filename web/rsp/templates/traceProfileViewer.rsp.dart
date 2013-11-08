//Auto-generated by RSP Compiler
//Source: traceProfileViewer.rsp.html
part of trails;

/** Template, traceProfileViewer, for rendering the view. */
Future traceProfileViewer(HttpConnect connect, {traceAnalysisRenderer}) { //#2
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  Rsp.init(connect, "text/html; charset=utf-8");

  response.write("""

      <div id="traceProfileViewer" ></div> 
"""); //#2

  if (traceAnalysisRenderer != null) { //if#4

    response.write("""        <script type="text/javascript" src="https://www.google.com/jsapi"></script>
        <script type="text/javascript">
          google.load("visualization", "1", {packages:["corechart"]});
          google.setOnLoadCallback(drawTraceProfile);
          
          
          var traceHeightWidthRatio ="""); //#5

    response.write(Rsp.nnx(traceAnalysisRenderer.traceHeightWidthRatio)); //#11


    response.write(""" ;
          
          function drawTraceProfile() {
            
            
            
            var data = google.visualization.arrayToDataTable([
                                                              ['Distance', 'Altitude', 'Altitude','Altitude', 'Altitude', 'Altitude' , 'Altitude' , 'Altitude' ],

"""); //#11

    for (var point in traceAnalysisRenderer.points) { //for#20

      response.write("""                                                              [  """); //#21

      response.write(Rsp.nnx(point.distanceInMeters)); //#21


      response.write(""",   """); //#21

      response.write(Rsp.nnx(traceAnalysisRenderer.skyElevetionInMeters)); //#21


      response.write(""", """); //#21

      response.write(Rsp.nnx(point.elevetionInMeters)); //#21


      response.write(""", """); //#21

      response.write(Rsp.nnx(point.getSnowInMeters(traceAnalysisRenderer.skyElevetionInMeters))); //#21


      response.write(""", """); //#21

      response.write(Rsp.nnx(point.scatteredInMeters)); //#21


      response.write(""", """); //#21

      response.write(Rsp.nnx(point.thornyInMeters)); //#21


      response.write(""", """); //#21

      response.write(Rsp.nnx(point.leafyInMeters)); //#21


      response.write(""", """); //#21

      response.write(Rsp.nnx(point.meadowInMeters)); //#21


      response.write("""           ],
"""); //#21
    } //for

    response.write("""                                                              
                                                              ]);
                                                                  
            var options = {
						   "chartArea":{"left":"15%","top":"5%",width:"75%",height:"80%"},
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
            };
    
            var chart = new google.visualization.AreaChart(document.getElementById('traceProfileViewer'));
            chart.draw(data, options);
          }
        </script>
"""); //#23
  } //if

  return Rsp.nnf();
}
