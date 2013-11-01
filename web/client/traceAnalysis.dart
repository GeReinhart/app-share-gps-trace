import 'spaces.dart';
import 'dart:html';
import 'package:js/js.dart' as js;

void main() {
  SpacesLayout layout = new SpacesLayout(180,50,50);
  
  js.context.google.load('visualization', '1', 
      js.map(
              {
                'packages': ['corechart'],
                'callback': drawVisualization,
              }
      )
   );
  
}

void drawVisualization() {
  
    var gviz = js.context.google.visualization;
  
   // Create and populate the data table.
    var listData = [
          ['x', 'Altitude', 'Altitude', 'Altitude','Altitude','Altitude',  ],
          [  1,   4000,       300,       299,       299,      299,      ],
          [  2,   4000,       600,       599,       599,      599,      ],
          [  3,   4000,      1200,      1199,      1199,      999,      ],
          [  4,   4000,      2200,      2199,      1999,      999,      ],
          [  5,   4000,      2100,      2099,      1999,      999,      ],
          [  6,   4000,      2100,      2099,      1999,      999,      ],
          [  7,   4000,      2400,      2399,      1999,      999,      ],
          [  8,   4000,      1200,      1199,      1199,      999,      ],
          [  9,   4000,       600,       599,       599,      599,      ],
          [ 10,   4000,      1000,       999,       999,      999,      ],
          [ 11,   4000,       900,       899,       899,      899,      ],
          [ 12,   4000,      1000,       999,       999,      999,      ],
          [ 13,   4000,       300,       299,       299,      299,      ],
          [ 25,   4000,       300,       299,       299,      299,      ]
          ];
    
    var arrayData = js.array(listData);

    var tableData = gviz.arrayToDataTable(arrayData);
    
    var options = js.map({
      "curveType": "function",
      "width": 500, "height": 400,
      "vAxis": {"maxValue": 10},
      "series": [
               {"color": '#5B6DE3', "lineWidth": 0, "areaOpacity": 1,  "visibleInLegend": false},
               {"color": 'black',   "lineWidth": 1, "areaOpacity": 0,  "visibleInLegend": false},
               {"color": 'white',   "lineWidth": 0, "areaOpacity": 1,  "visibleInLegend": false},
               {"color": '#C2A385', "lineWidth": 0, "areaOpacity": 1,  "visibleInLegend": false},
               {"color": '#A3C266', "lineWidth": 0, "areaOpacity": 1,  "visibleInLegend": false}
               ]
    });

    // Create and draw the visualization.
    var chart = new js.Proxy(gviz.AreaChart, querySelector('#visualization'));
    chart.draw(tableData, options);

}

