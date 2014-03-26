
 function GxIconBuilder(){

    this.colors = ["24ab18","222da8","c71e1e","ff8922","a425b8"] ;
    this.lightColors= {"#24ab18":"#9BE895",
                       "#222da8":"#B2B7ED",
                       "#c71e1e":"#E0B6B6",
                       "#ff8922":"#FFDCBD",
                       "#a425b8":"#DBB6E0"}
    this.stylesNumber = 4 ;
    
    this.icons = {};
    this.iconsByPath = {};
    this.iconsColors = {};
    
    this.activities = {
                         "trek":"hiking.png",
                         "running":"jogging.png",
                         "bike":"cycling.png",
                         "mountainbike":"mountainbiking-3.png",
                         "skitouring":"nordicski.png",
                         "snowshoe":"snowshoeing.png"
                        } ;
    
    this.build = function(key,activity){
    
       if(key in this.icons){
            return this.icons[key];
       }else{
            var icon ;
            var path ;
            var color ;
            for (var k = 1; k <= 1000 && ! icon; k++) {
            	for (var j = 1; j <= this.stylesNumber && ! icon ; j++) {
               		for (var i = 0; i < this.colors.length && ! icon ; i++) {
                   		var currentPath = this.colors[i]+"/"+j ;
                   		var currentPathWithNumber = currentPath+"#"+k ;
                   		if (! ( currentPathWithNumber  in this.iconsByPath) && !icon ){
                   		    color = this.colors[i] ;
                      		path = currentPathWithNumber;
                      		icon = this._buildIcon(currentPath, activity) ;
                   		}
               		}
				}
			}
            if (! icon){
               color = "c71e1e/1" ;
               path = color+"/1"  ;
               icon = this._buildIcon(path, "") ; 
            }
            this.iconsColors[key] = color ;
			this.icons[key] = icon ;
			this.iconsByPath[path] = icon ;
			return icon ;
	   }
	}
    
    this._buildIcon = function(path, activity){
        var iconUrl = '/assets/img/icon/'+path+'/'+this.getPngFile(activity);
        return L.icon({
	        iconUrl:   iconUrl,
	      	iconSize: [32, 37],
	      	popupAnchor: [0, -40],
	      	iconAnchor: [16, 37]
	     });
    }
    
    this.getPngFile = function(activity){
      if (activity in this.activities){
         return this.activities[activity] ;
      }
      return this.activities["running"];
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
	this.startMarker = L.marker([startLat, startLong], {icon: icon}) ;
    this.gpxTrackColor ;
	this.gpxTrack ;
    this.popup ;
    this.map;
    this.iconBasePath ;
    this.opacity =1 ; 
    this.isHighlighted = false ;
	
	this.addMarker = function(map){
	   this.map = map ;
	   this.startMarker.addTo(map) ;
       var me = this ;
	   
	   this.startMarker.on('click', function(e) {
           if(! me.popup._isOpen){
           	 me.popup.addTo(me.map) ;
           	 if(me.gpxTrack){
           	    me.gpxTrack.setStyle( {  opacity:1  }); 
           	 }else{
           	    me.displayGpxTrack();
           	 }
           	 me.isHighlighted = true ;
           	 me.fireHighlightEvent(true);
           }
	   });
	   
	}
	
	this.moveMarker = function(lat,long){
	    var position = L.latLng(lat, long) ;
	    this.startMarker.setLatLng( position ) ;
	    this.startMarker.update() ;
	    if ( ! this.isOnMap(lat,long) ){
	      this.map.setView(position);
	    }
	}
	
	this.isOnMap = function(lat,long){
	        return  lat  <= this.map.getBounds().getNorthEast().lat
            &&   lat  >= this.map.getBounds().getSouthWest().lat
            &&   long <= this.map.getBounds().getNorthEast().lng
            &&   long >= this.map.getBounds().getSouthWest().lng   ;
	}
		
	this.openPopup = function (){
	   if(! this.popup._isOpen){
           	 this.popup.addTo(this.map) ;
       }
	}
	
	this.highlight = function (){
	  this.visible();
      this.displayGpxTrack();
      this.openPopup();
      this.isHighlighted = true ;
      this.fireHighlightEvent(true);
	}
            
	this.fireHighlightEvent = function (highlight){
	  var event = new Event('highlight_trace');
      document.dispatchEvent(event);
	}
	
	
	this.bindPopup = function(map){
	    this.map = map ;
	    this.popup = new L.popup(
	                      { offset:  L.point(0, -38)  }
	                    ) ;
    	this.popup.setLatLng(  L.latLng(  startLat  , startLong) ) ;
    	this.popup.setContent("<b>"+this.title+"</b>");
    	
    	var me = this;
    	this.map.on('popupclose', function(e) {
    	    if (  e.popup == me.popup ){
    			if( me.gpxTrack ){
    				me.gpxTrack.setStyle( {  opacity:0  });
    			}
    			me.isHighlighted = false ;
    			me.fireHighlightEvent(false);
    	    }
		});
    	
	}
	
	this.displayGpxTrack = function(){
	   if (  this.gpxTrack ){
	       this.gpxTrack.setStyle( {  opacity:1  });
	   }else{
		   this.gpxTrack = new L.GPX(this.gpxUrl, 
	                       { async: true, 
	                         polyline_options: {
	   							 color: this.gpxTrackColor
	  						 }
	                       }
		                  );
		   this.gpxTrack.addTo(this.map);	   
	   }
	

	}

	this.viewGpxTrack = function(){
	   if (  this.gpxTrack ){
	       this.gpxTrack.setStyle( {  opacity:1  });	   
	   }else{
	       var me = this;
	       this.gpxTrack = new L.GPX(this.gpxUrl,
                       { async: true, 
                         polyline_options: {
   							 color: this.gpxTrackColor
  						 }
                       }).on('loaded', function(e) {
        			         me.map.fitBounds(e.target.getBounds());
	                   }).addTo(this.map);	   
	   }
    }
	
	this.isVisible = function(){
		return this.opacity > 0 ;
	}
	
	this.visible= function(){
	  this.opacity = 1;
	  this.startMarker.setOpacity(this.opacity);
	}

	this.lighter= function(){
	  this.setOpacity(0.5);
	}        	
	
	this.invisible= function(){
	  this.setOpacity(0);
	}           	
	
	this.setOpacity= function(opacity){
	  this.opacity = opacity;
	  this.startMarker.setOpacity(opacity);
	  if(this.gpxTrack){
   		  this.gpxTrack.setStyle( {  opacity:opacity  });
	  }
	  if(this.popup){
   		 // this.popup.setStyle( {  opacity:opacity  });
	  }
	}
	
 }

 function GxMap(id,ignKey,iconBuilder){
    
    this.iconBuilder = iconBuilder ;
    this.traces = {};
    this.id = id;
    this.ignKey = ignKey;
    this.map ;
    this.lastRightClick;
    this.lastRightClickMarker;
  
 	this.init = function() {

   		 var OSM			= new L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {updateWhenIdle:true});
            // , {attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a>'}
  		 var ignWmtsUrl	= "http://gpp3-wxs.ign.fr/"+ ignKey + "/geoportail/wmts?LAYER=GEOGRAPHICALGRIDSYSTEMS.MAPS&EXCEPTIONS=text/xml&FORMAT=image/jpeg&SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile&STYLE=normal&TILEMATRIXSET=PM&&TILEMATRIX={z}&TILECOL={x}&TILEROW={y}" ;
  		 var IGN			= new L.tileLayer(ignWmtsUrl, {updateWhenIdle:true});
           // , {attribution: '&copy; <a href="http://www.ign.fr/">IGN</a>'}
  		 var scanWmtsUrl	= "http://gpp3-wxs.ign.fr/"+ ignKey + "/geoportail/wmts?LAYER=GEOGRAPHICALGRIDSYSTEMS.MAPS.SCAN-EXPRESS.STANDARD&EXCEPTIONS=text/xml&FORMAT=image/jpeg&SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile&STYLE=normal&TILEMATRIXSET=PM&&TILEMATRIX={z}&TILECOL={x}&TILEROW={y}" ;
  		 var SCAN25		= new L.tileLayer(scanWmtsUrl, {updateWhenIdle:true});
           // , {attribution: '&copy; <a href="http://www.ign.fr/">IGN</a>'}
           
  		 var GMS = new L.Google('SATELLITE');

          
    	 var baseMap = {"Ign Topo":IGN,"Ign Topo Express":SCAN25 ,"OpenStreetMap":OSM, "Google Satellite": GMS};

	     this.map = new  L.map(id, {
	         zoomControl: false,
	         layers: [OSM]
	     });

	     var zoomControl = L.control.zoom({
	         position: 'bottomleft'
	     });
         this.map.addControl(zoomControl);
         
         L.control.layers(baseMap).addTo(this.map);
         
         this.map.setView([45.174776, 5.541494], 6);
         
         var me = this ;
         this.map.on('viewreset', function(e){
	       if( me.map.getZoom() == 0){
	          me.map.setView([45.174776, 5.541494], 6);
	          me.map.on('load', this.fitMapViewPortWithMarkers);
	       }
         });
         
         this.map.on('contextmenu',function(e){
	       me._listenRightClick(e);
         });
         this.lastRightClickMarker = L.marker([45.174776, 5.541494], {clickable:false}).addTo(this.map) ;
         this.lastRightClickMarker.setOpacity(0) ;
         
         return this;
 	}
 
    this.getIconUrl = function (key,activity){
        if(key in this.traces){
           var currentIconUrl = this.traces[key].startMarker._icon.src ;
           var baseIconUrl =   currentIconUrl.substring(0, currentIconUrl.lastIndexOf("/")) + "/" ;
           return baseIconUrl + this.iconBuilder.getPngFile(activity);
        }else{
           return "" ;
        }
    }
 
    this.listenToMapChange = function(callBackOnChange){
        this.map.on('moveend', callBackOnChange);
    }

 	this.highlightTraceByKey = function(key){
    	if(key in this.traces){
    	    var trace = this.traces[key] ;
            trace.highlight();
    	}
 	}

 	this.isHighlightedTraceByKey = function(key){
    	if(key in this.traces){
    	    return this.traces[key].isHighlighted;
    	}else{
    	    return false;
    	}
 	}

    this.getTraceColor = function (key){
    	if(key in this.traces){
    	    return this.traces[key].gpxTrackColor;
    	}else{
    	    return "";
    	}    
    }
    
    
    this.moveMarker = function (key,lat,long){
    	if(key in this.traces){
    	    return this.traces[key].moveMarker(lat,long);
    	}   
    }

    this.getLightColor = function (key){
        var traceColor = this.getTraceColor(key);
    	if(traceColor in this.iconBuilder.lightColors){
    	    return this.iconBuilder.lightColors[traceColor];
    	}else{
    	    return "";
    	}    
    }

 	this.displayGpxByKey = function(key){
    	if(key in this.traces){
            for (var keyLoop in this.traces) {
              this.traces[keyLoop].lighter() ;
            }
            this.traces[key].visible();
            this.traces[key].displayGpxTrack();
    	}
 	}
 
  	this.viewGpxByKey = function(key){
    	if(key in this.traces){
            for (var keyLoop in this.traces) {
              this.traces[keyLoop].invisible() ;
            }
            this.traces[key].visible();
            this.traces[key].viewGpxTrack();
    	}
 	}
 
	this._addMarker = function(targetMap,  key, activity, title, startLat, startLong, gpx ){
	   if(key in this.traces){
	     var trace = this.traces[key] ;
	     if( trace.isHighlighted ){
	         trace.highlight() ;
	     }else{
		     trace.visible();
	     }
	     this.traces[key].visible();
	   }else{
	     var icon = this.iconBuilder.build(key , activity) ;
	     var trace = new GxTrace(key,  title, startLat, startLong, gpx,icon);
	     trace.addMarker(this.map);
	     trace.bindPopup(this.map);
	     trace.gpxTrackColor = this.iconBuilder.getTraceColor(key) ;
	     this.traces[key] = trace ;
	   }
	}
	 
	this.addMarkerToMap = function( key, activity, title, startLat, startLong, gpx ){
	   this._addMarker(this.map,  key, activity, title, startLat, startLong, gpx ) ;
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
	       var trace = this.traces[key];
	       if (trace.isVisible()){
	       		hasMarkers = true ;
	       		bounds.extend (trace.startMarker.getLatLng());
	       }
	     }  
	     if (hasMarkers){
	       this.map.fitBounds (bounds);
	       if (this.map.getZoom() > 12){
	         this.map.setZoom(12);
	       }
	       if( this.map.getZoom() == 0){
	          this.map.setView([45.174776, 5.541494], 6);
	       }
	     }
	 }
 
     this.getBounds = function (){
         return this.map.getBounds();
     }
     
     this.isOnTheMap = function (lat, long){
        return  lat  <= this.map.getBounds().getNorthEast().lat
            &&   lat  >= this.map.getBounds().getSouthWest().lat
            &&   long <= this.map.getBounds().getNorthEast().lng
            &&   long >= this.map.getBounds().getSouthWest().lng   ;
     }
  
     this.refreshTiles = function(){
        this.map.invalidateSize() ;
     }   
     
     
     this._listenRightClick = function(e){
     	this.lastRightClick = e ;
        var event = new Event('right_click_on_map');
        document.dispatchEvent(event);
     }
     
     this.drawRightClickMark = function(){
        if (this.lastRightClick){
           this.lastRightClickMarker.setLatLng( this.lastRightClick.latlng );
           this.lastRightClickMarker.setOpacity(1) ;
        }
     }

     this.hideRightClickMark = function(){
        this.lastRightClickMarker.setOpacity(0) ;
     }

     
 }
      


