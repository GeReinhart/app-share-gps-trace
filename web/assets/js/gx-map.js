var GxMarker = L.Marker.extend({
 
	bindPopup: function(htmlContent, options) {

		if (options && options.showOnMouseOver) {
			
			// call the super method
			L.Marker.prototype.bindPopup.apply(this, [htmlContent, options]);
			
			// unbind the click event
			this.off("click", this.openPopup, this);
			
			// bind to mouse over
			this.on("mouseover", function(e) {
				
				// get the element that the mouse hovered onto
				var target = e.originalEvent.fromElement || e.originalEvent.relatedTarget;
				var parent = this._getParent(target, "leaflet-popup");
 
				// check to see if the element is a popup, and if it is this marker's popup
				if (parent == this._popup._container)
					return true;
				
				// show the popup
				this.openPopup();
				
			}, this);
			
			// and mouse out
			this.on("mouseout", function(e) {
				
				// get the element that the mouse hovered onto
				var target = e.originalEvent.toElement || e.originalEvent.relatedTarget;
				
				// check to see if the element is a popup
				if (this._getParent(target, "leaflet-popup")) {
 
					L.DomEvent.on(this._popup._container, "mouseout", this._popupMouseOut, this);
					return true;
 
				}
				
				// hide the popup
				this.closePopup();
				
			}, this);
			
		}
		
	},
 
	_popupMouseOut: function(e) {
	    
		// detach the event
		L.DomEvent.off(this._popup, "mouseout", this._popupMouseOut, this);
 
		// get the element that the mouse hovered onto
		var target = e.toElement || e.relatedTarget;
		
		// check to see if the element is a popup
		if (this._getParent(target, "leaflet-popup"))
			return true;
		
		// check to see if the marker was hovered back onto
		if (target == this._icon)
			return true;
		
		// hide the popup
		this.closePopup();
		
	},
	
	_getParent: function(element, className) {
		
		var parent = element.parentNode;
		
		while (parent != null) {
			
			if (parent.className && L.DomUtil.hasClass(parent, className))
				return parent;
			
			parent = parent.parentNode;
			
		}
		
		return false;
		
	}
 
});

function GxMapHandler() {

	this.ignKey ;
	this.googleKey ;
	this.map ;
	this.markers = {};

	this.init = function(id) {

		var OSM			= L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a>'});

		var ignWmtsUrl	= "http://gpp3-wxs.ign.fr/"+ this.ignKey + "/geoportail/wmts?LAYER=GEOGRAPHICALGRIDSYSTEMS.MAPS&EXCEPTIONS=text/xml&FORMAT=image/jpeg&SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile&STYLE=normal&TILEMATRIXSET=PM&&TILEMATRIX={z}&TILECOL={x}&TILEROW={y}" ;
		var IGN			= L.tileLayer(ignWmtsUrl, {attribution: '&copy; <a href="http://www.ign.fr/">IGN</a>'});

		var scanWmtsUrl	= "http://gpp3-wxs.ign.fr/"+ this.ignKey + "/geoportail/wmts?LAYER=GEOGRAPHICALGRIDSYSTEMS.MAPS.SCAN-EXPRESS.STANDARD&EXCEPTIONS=text/xml&FORMAT=image/jpeg&SERVICE=WMTS&VERSION=1.0.0&REQUEST=GetTile&STYLE=normal&TILEMATRIXSET=PM&&TILEMATRIX={z}&TILECOL={x}&TILEROW={y}" ;
		var SCAN25		= L.tileLayer(scanWmtsUrl, {attribution: '&copy; <a href="http://www.ign.fr/">IGN</a>'});

		var GMS = new L.Google('SATELLITE');

		this.map = L.map(id, {
			center: new L.LatLng(48.853, 2.35),
			zoom: 13,
			layers: [OSM]
		});

		var baseMap = {"Ign Topo":IGN,"Ign Topo Express":SCAN25 ,"OpenStreetMap":OSM, "Google Satellite": GMS};

		L.control.layers(baseMap).addTo(this.map);

	}

	this.addMarker = function(marker) {

		var pos = new L.LatLng(marker.lat, marker.lng);
		var mapMarker = new GxMarker(pos) ;

		if(marker.icon) {
			mapMarker.setIcon(L.icon({iconUrl: marker.icon, iconSize: [16, 16]})) ; 
		}
		
		if(marker.title) {
			mapMarker.bindPopup(marker.title, {showOnMouseOver: true, closeButton: false}) ;
		}

		if(marker.click) {

			mapMarker.fichier = marker.fichier;
			mapMarker.on('click', function(e) {
				jQuery.fancybox( {href : this.fichier});
			});

		}

		mapMarker.addTo(this.map);

		return mapMarker ;

	}

	this.addMarkers = function(markers) {
		
		for (var i = 0; i < markers.length; i++) {
			this.addMarker(markers[i]) ;
		}

	}

	this.addGPX = function(filepath) {

		var me = this ;

		var track = new L.GPX(filepath, {async: true}).on('loaded', function(e) {

			me.map.fitBounds(e.target.getBounds());

		}).addTo(this.map);

		return track ;

	}

}



