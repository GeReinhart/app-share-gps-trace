

 function GxIconBuilder(){

    this.colours = ["c71e1e","ff8922"] ;
    this.stylesNumber = 4 ;
    
    this.icons = {};
    this.iconsByPath = {};
    this.iconsColors = {};
    
    this.activities = {
                         "activity-trek":"hiking.png",
                         "activity-running":"jogging.png",
                         "activity-bike":"cycling.png",
                         "activity-mountainbike":"mountainbiking-3.png",
                         "activity-skitouring":"nordicski.png",
                         "activity-snowshoe":"snowshoeing.png"
                        } ;
    
    this.build = function(key,activity){
    
       if(key in this.icons){
            return this.icons[key];
       }else{
            var icon ;
            var path ;
            var colour ;
            for (var k = 1; k <= 1000 && ! icon; k++) {
            	for (var j = 1; j <= this.stylesNumber && ! icon ; j++) {
               		for (var i = 0; i < this.colours.length && ! icon ; i++) {
                   		var currentPath = this.colours[i]+"/"+j ;
                   		var currentPathWithNumber = currentPath+"#"+k ;
                   		if (! ( currentPathWithNumber  in this.iconsByPath) && !icon ){
                   		    colour = this.colours[i] ;
                      		path = currentPathWithNumber;
                      		icon = this._buildIcon(currentPath, activity) ;
                   		}
               		}
				}
			}
            if (! icon){
               colour = "c71e1e/1" ;
               path = colour+"/1"  ;
               icon = this._buildIcon(path, "") ; 
            }
            this.iconsColors[key] = colour ;
			this.icons[key] = icon ;
			this.iconsByPath[path] = icon ;
			return icon ;
	   }
	}
    
    this._buildIcon = function(path, activity){
        var iconUrl = '/assets/img/icon/'+path+'/'+this._getPngFile(activity);
        return L.icon({
	        iconUrl:   iconUrl,
	      	iconSize: [32, 37],
	      	popupAnchor: [0, -40],
	      	iconAnchor: [16, 37]
	     });
    }
    
    this._getPngFile = function(activity){
      if (activity in this.activities){
         return this.activities[activity] ;
      }
      return this.activities["activity-running"];
    }
    
    this.getIconColor = function(key){
       if(key in this.iconsColors){
            return "#"+this.iconsColors[key];
       }else{
       		return "red" ;
       }
    }
    
    this.getTraceColor = function(key){
       return this.getIconColor(key);
    }
    
 }

 function GxTrace(key,  title, startLat, startLong, gpxUrl, icon) {
 	this.key  = key ;
	this.title = title;
	this.gpxUrl= gpxUrl;
	this.gpxTrack ;
	this.startMarker = L.marker([startLat, startLong], {icon: icon}) ;
    this.popup ;
    this.map 
	
	this.addMarker = function(map){
	   this.map = map ;
	   this.startMarker.addTo(map) ;
       var me = this ;
	   
	   this.startMarker.on('click', function(e) {
           if(! me.popup._isOpen){
           	 me.popup.addTo(map) ;
           }else{
             
           }
	   });
	   
	}
	
	this.bindPopup = function(map){
	    this.map = map ;
	    this.popup = new L.popup(
	                      { offset:  L.point(0, -38)  }
	                    ) ;
    	this.popup.setLatLng(  L.latLng(  startLat  , startLong) ) ;
    	this.popup.setContent("<b>"+this.title+"</b>");
	}
	
	this.visible= function(){
	  this.setOpacity(1);
	}

	this.lighter= function(){
	  this.setOpacity(0.5);
	}        	
	
	this.invisible= function(){
	  this.setOpacity(0);
	}           	
	
	this.setOpacity= function(opacity){
	  this.startMarker.setOpacity(opacity);
	  if(this.gpxTrack){
	    if ( opacity == 0 ){
	        this.gpxTrack.clearLayers();
	    }
	  }
	}
	
 }

 function GxMap(id,ignKey,iconBuilder){
    
    this.iconBuilder = iconBuilder ;
    this.traces = {};
    this.id = id;
    this.ignKey = ignKey;
    this.map ;
  
 	this.init = function() {

   		 var OSM			= L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png');
            // , {attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a>'}
  		 var ignWmtsUrl	= "http://gpp3-wxs.ign.fr/"+ ignKey + "/geoportail/wmts?LAYER=GEOGRAPHICALGRIDSYSTEMS.MAPS&EXCEPTIONS=text/xml&FORMAT=image/jpeg&SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile&STYLE=normal&TILEMATRIXSET=PM&&TILEMATRIX={z}&TILECOL={x}&TILEROW={y}" ;
  		 var IGN			= L.tileLayer(ignWmtsUrl);
           // , {attribution: '&copy; <a href="http://www.ign.fr/">IGN</a>'}
  		 var scanWmtsUrl	= "http://gpp3-wxs.ign.fr/"+ ignKey + "/geoportail/wmts?LAYER=GEOGRAPHICALGRIDSYSTEMS.MAPS.SCAN-EXPRESS.STANDARD&EXCEPTIONS=text/xml&FORMAT=image/jpeg&SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile&STYLE=normal&TILEMATRIXSET=PM&&TILEMATRIX={z}&TILECOL={x}&TILEROW={y}" ;
  		 var SCAN25		= L.tileLayer(scanWmtsUrl);
           // , {attribution: '&copy; <a href="http://www.ign.fr/">IGN</a>'}
           
  		 var GMS = new L.Google('SATELLITE');

    	 var baseMap = {"Ign Topo":IGN,"Ign Topo Express":SCAN25 ,"OpenStreetMap":OSM, "Google Satellite": GMS};

       
	     this.map = L.map(id, {
	         zoomControl: false,
	         layers: [IGN]
	     });

	     var zoomControl = L.control.zoom({
	         position: 'bottomleft'
	     });
         this.map.addControl(zoomControl);
         
         L.control.layers(baseMap).addTo(this.map);
         
         return this;
 	}
 
    this.listenToMapChange = function(callBackOnChange){
        this.map.on('moveend', callBackOnChange);
    }

 	this.displayGpxByKey = function(key){
    	if(key in this.traces){
            for (var key in this.traces) {
              this.traces[key].lighter() ;
            }
            this.traces[key].visible();
            this.traces[key].gpxTrack = new L.GPX(this.traces[key].gpxUrl, 
                          {  async: true,
		                     polyline_options: {
		   						color: this.iconBuilder.getTraceColor(key)
		  					 }         
                          }).addTo(this.map);
    	}
 	}
 
  	this.viewGpxByKey = function(key){
    	if(key in this.traces){
            for (var key in this.traces) {
              this.traces[key].lighter() ;
            }
            this.traces[key].visible();
            var me = this ;
            this.traces[key].gpxTrack = new L.GPX(this.traces[key].gpxUrl,
                       { async: true, 
                         polyline_options: {
   							 color: this.iconBuilder.getTraceColor(key)
  						 }
                       })
                   .on('loaded', function(e) {
        			me.map.fitBounds(e.target.getBounds());
       		}).addTo(this.map);
    	}
 	}
 
	this._addMarker = function(targetMap,  key, activity, title, startLat, startLong, gpx ){
	   if(key in this.traces){
	     this.traces[key].visible();
	   }else{
	     var icon = this.iconBuilder.build(key , activity) ;
	     var trace = new GxTrace(key,  title, startLat, startLong, gpx,icon);
	     trace.addMarker(this.map);
	     trace.bindPopup(this.map);
	     trace.gpxTrack = new L.GPX(trace.gpxUrl, 
                       { async: true, 
                         polyline_options: {
   							 color: this.iconBuilder.getTraceColor(key)
  						 }
                       }
	         ).addTo(this.map);
	     this.traces[key] = trace ;
	   }
	}
	 
	this.addMarkerToMap = function( key, activity, title, startLat, startLong, gpx ){
	   this._addMarker(map,  key, activity, title, startLat, startLong, gpx ) ;
	} 
	 
	this.removeAllMarkers = function(){
	   for (var key in this.traces) {
	     this.traces[key].invisible() ;
	   }
	}
	 
	this.fitMapViewPortWithMarkers =  function(){
	     if (! this.traces){
	       return;
	     }
	     var bounds = new L.LatLngBounds ();
	     var hasMarkers = false ;
	     for (var key in this.traces) {
	       marker = this.traces[key].startMarker;
	       hasMarkers = true ;
	       bounds.extend (marker.getLatLng());
	     }  
	     if (hasMarkers){
	       this.map.fitBounds (bounds);
	       if (this.map.getZoom() > 12){
	         this.map.setZoom(12);
	       }
	     }
	 }
 
     this.getBounds = function (){
         return this.map.getBounds();
     }
 }
      


