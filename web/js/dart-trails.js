

function Layout(  spaceNorthWestSelectorParam, spaceNorthEastSelectorParam, spaceSouthWestSelectorParam, spaceSouthEastSelectorParam , spaceCenterSelectorParam ){
	
	var spaceNorthWestSelector = spaceNorthWestSelectorParam;
	var spaceNorthEastSelector = spaceNorthEastSelectorParam;
	var spaceSouthWestSelector = spaceSouthWestSelectorParam;
	var spaceSouthEastSelector = spaceSouthEastSelectorParam;	
	var spaceCenterSelector    = spaceCenterSelectorParam;
	
	var documentWidth  ;
	var documentHeight ; 
	var centerRight ;
	var centerTop ;
	
	this.organizeSpaces = function( documentWidthParam, documentHeightParam, centerRightParam , centerTopParam){
		
		centerRight = centerRightParam ;
		centerTop = centerTopParam ;
		documentWidth = documentWidthParam ;
		documentHeight = documentHeightParam; 
		
		console.log("Organize spaces on window ("+ documentWidth +"/"+  documentHeight+ ") : compass on " + centerRight + "/" + centerTop );
		
		$(spaceNorthWestSelector).css('position','absolute');
		$(spaceNorthWestSelector).css('right', (centerRight+1) );
		$(spaceNorthWestSelector).css('top',   '0');
		$(spaceNorthWestSelector).css('width', (documentWidth - centerRight-1)  );		
		$(spaceNorthWestSelector).css('height', centerTop );

		$(spaceNorthEastSelector).css('position','absolute');
		$(spaceNorthEastSelector).css('right','0');
		$(spaceNorthEastSelector).css('top','0');
		$(spaceNorthEastSelector).css('width', centerRightParam  );		
		$(spaceNorthEastSelector).css('height',centerTop);
		
		$(spaceSouthWestSelector).css('position','absolute');
		$(spaceSouthWestSelector).css('right', (centerRight+1) );
		$(spaceSouthWestSelector).css('top', (centerTop+1));
		$(spaceSouthWestSelector).css('width', (documentWidth - centerRight-1)  );		
		$(spaceSouthWestSelector).css('height',(documentHeight- centerTop-1) );	

		$(spaceSouthEastSelector).css('position','absolute');
		$(spaceSouthEastSelector).css('right', '0');
		$(spaceSouthEastSelector).css('top',  (centerTop+1) );
		$(spaceSouthEastSelector).css('width', centerRight  );		
		$(spaceSouthEastSelector).css('height',(documentHeight - centerTop-1) );	
	
		$(spaceCenterSelector).css('position','absolute');
		$(spaceCenterSelector).css('right',(centerRight  - 50 /2   +1 ) );
		$(spaceCenterSelector).css('top',  (centerTop    - 50 /2 + 1) );
		$(spaceCenterSelector).css('width', 50  );		
		$(spaceCenterSelector).css('height',50 );	
	}
	
	this.updateSpaces = function(documentWidthParam, documentHeightParam){
		this.organizeSpaces(documentWidthParam, documentHeightParam, centerRight, centerTop);
	}
	
}





