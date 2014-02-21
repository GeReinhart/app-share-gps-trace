import "dart:html";
import "dart:convert";
import "dart:async" ;
import 'package:js/js.dart' as js;

import '../spaces.dart';
import "../forms.dart";

import 'page.dart';
import "../widgets/login.dart" ;
import "../widgets/persistentMenu.dart" ;
import "../events.dart" ;
import "../controllers.dart" ;


class TraceSearchPage extends Page {
  static const TIMEOUT = const Duration(milliseconds: 1500);
  
  Map<String,LightTrace> resultsMap = new Map();
  Map<String,LightTrace> hiddenResultsMap = new Map();
  
  String   lastTimeMapChange = "";
  DateTime lastTimeFiltersChange = null;
  SearchForm lastSearchFormSubmited = null;
  bool waitingForResult = false ;
  bool firstRequest = true ;
  bool initDone = false;

  TraceSearchPage(PageContext context): super("trace_search",context,70,50,true){
    layout.centerMoved.listen((_){
      moveMap( _ as SpacesPositions);
      js.context.map.refreshTiles();
    });
    _initTraceSearchPage();
  }

  void _initTraceSearchPage(){
    if(initDone){
      return;
    }
    submitRequest(mapFilter:false);
    
    querySelectorAll(".search-form-inputs").onChange.listen((e){
      lastTimeFiltersChange = new DateTime.now();
    });
    
    new Timer(TIMEOUT, shouldUpdateSearchResultsDisplay);
    initDone = true;
  }
  
  void moveMap(SpacesPositions spacesPositions ){
    
    Element map = querySelector("#search-results-map-canvas") ;
    if (map != null){
      map..style.position = 'absolute'
      ..style.right  = "0px"
      ..style.top    = "0px"
      ..style.width  = (spacesPositions.spaceSE_Width).toString() + "px"
      ..style.height = (spacesPositions.spaceSE_Height).toString() + "px" ;
    }
  }
  
  void submitRequest({mapFilter:true}){
    HttpRequest request = new HttpRequest();
  
    layout.startLoading();
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE ) {
        waitingForResult = false;
        displaySearchResults(request,fitMapViewPortWithMarkers:firstRequest);
        firstRequest=false;
      }
    });
    sendSearchRequest(request, mapFilter:mapFilter);
  }
  
  void displaySearchResults(HttpRequest request, {fitMapViewPortWithMarkers:true}){
    if (request.responseText == null || request.responseText != null  && request.responseText.isEmpty){
      layout.stopLoading();
      return ;   
    }
    
    SearchForm form = new SearchForm.fromMap(JSON.decode(request.responseText));
    lastSearchFormSubmited = form ;
    
    Element searchResultRow=  querySelector("#search-result-row");
    Element searchResultBody=  querySelector("#search-result-body");
    js.context.map.removeAllMarkers();
    removeResults(".search-results");
    setResultsMap(form.results);
    if (form.results != null && form.results.isNotEmpty){
        form.results.forEach((lightTrace){
        displaySearchResult( searchResultBody, searchResultRow,  lightTrace) ;
        String gpxUrl = "/trace.gpx/${lightTrace.key}";   
        js.context.map.addMarkerToMap( lightTrace.keyJsSafe, lightTrace.mainActivity , lightTrace.titleJsSafe, lightTrace.startPointLatitude,lightTrace.startPointLongitude,gpxUrl );
      });
      if (fitMapViewPortWithMarkers){
        js.context.map.fitMapViewPortWithMarkers();
      }
    }
    layout.stopLoading();
  }
  
  void displaySearchResult(Element searchResultBody,Element searchResultRow, LightTrace lightTrace){
    Element searchResultCurrentRow = searchResultRow.clone(true) ;
    
    
    AnchorElement activitiesLink = new AnchorElement();
    activitiesLink.classes.add("gx-as-link") ;
    activitiesLink.attributes["data-key"] = lightTrace.keyJsSafe ;
    String activities = "" ;
    lightTrace.activityKeys.forEach((key){
      ImageElement img = new ImageElement();
      img.src = js.context.map.getIconUrl( lightTrace.keyJsSafe, key  );
      activitiesLink.append(img);
      activitiesLink.appendText(" ");
    });
    activitiesLink.onClick.listen((e)=> js.context.map.highlightTraceByKey(lightTrace.keyJsSafe) );
    
    
    searchResultCurrentRow.className = "search-results key-${lightTrace.keyJsSafe}" ;
    searchResultCurrentRow.children[0].innerHtml = lightTrace.creator;
    searchResultCurrentRow.children[1].innerHtml = lightTrace.title;
    searchResultCurrentRow.children[2].append(activitiesLink) ;
    searchResultCurrentRow.children[3].innerHtml = lightTrace.length;
    searchResultCurrentRow.children[4].innerHtml = lightTrace.up;
    searchResultCurrentRow.children[5].innerHtml = lightTrace.upperPointElevetion;
    searchResultCurrentRow.children[6].innerHtml = lightTrace.inclinationUp;
    searchResultCurrentRow.children[7].innerHtml = lightTrace.difficulty;
    searchResultBody.append(searchResultCurrentRow);
  }
  
  
  void setResultsMap(List<LightTrace> results){
    if (results != null && results.isNotEmpty){
      results.forEach((lightTrace){
        resultsMap[ lightTrace.keyJsSafe ] = lightTrace;
      });
      hiddenResultsMap = new Map();
    }else{
      resultsMap = new Map();
      hiddenResultsMap = new Map();
    }
  }
  
  void shouldUpdateSearchResultsDisplay(){
    
    String newTimeMapChange = (querySelector("#search-form-js-dart-bridge") as InputElement).value;
    bool shouldSubmitRequest = false ;
    if ( lastSearchFormSubmited != null && ! waitingForResult  ){
      SearchForm  currentSearchForm = buildSearchFormFromPage() ;
      if (!lastSearchFormSubmited.equals(currentSearchForm)){
        shouldSubmitRequest = true;
      }
    }
    if ( shouldSubmitRequest ){
      updateSearchResultsDisplay();
      submitRequest();
    }
    new Timer(TIMEOUT, shouldUpdateSearchResultsDisplay);
  }
  
  void updateSearchResultsDisplay(){
    Element searchResultRow  =  querySelector("#search-result-row");
    Element searchResultBody =  querySelector("#search-result-body");
    Map<String,LightTrace> updatedResultsMap = new Map();
    Map<String,LightTrace> updatedHiddenResultsMap = new Map();
    Map<String,LightTrace> allResultsMap = new Map();
    hiddenResultsMap.forEach((key,lightTrace)=>(allResultsMap[key]= lightTrace));
    resultsMap.forEach((key,lightTrace)=>(allResultsMap[key]= lightTrace));
    
    allResultsMap.forEach((key,lightTrace){
      if ( js.context.map.isOnTheMap( lightTrace.startPointLatitude,lightTrace.startPointLongitude  )  ){
        updatedResultsMap[key] = lightTrace;
        if(!resultsMap.containsKey(key)){
          displaySearchResult( searchResultBody, searchResultRow,  lightTrace) ;
        }
      }else{
        updatedHiddenResultsMap[key] = lightTrace;
        if(resultsMap.containsKey(key)){
          removeResults( ".key-${lightTrace.keyJsSafe}"  ) ;
        }
  
      }
    });
    
    resultsMap = updatedResultsMap;
    hiddenResultsMap = updatedHiddenResultsMap;
  }
  
  
  void sendSearchRequest(HttpRequest request, {mapFilter:true}){
    request.open("POST",  "/j_trace_search", async: true);
    SearchForm form = buildSearchFormFromPage(mapFilter:mapFilter);
    request.send(JSON.encode(form.toJson()));
    waitingForResult = true;
  }
  
  SearchForm buildSearchFormFromPage({mapFilter:true}){
    SearchForm form =  new  SearchForm( );
    form.search = (querySelector(".search-form-input-text") as InputElement ).value ;
    querySelectorAll(".search-form-input-activity").forEach((e){
      CheckboxInputElement  activity= e as CheckboxInputElement;
      if (activity.checked){
        form.addActivity(activity.name.substring("activity-".length, activity.name.length));
      }
    }) ;
  
    form.lengthGt              = (querySelector(".search-form-input-length-gt") as InputElement ).value ;  
    form.lengthLt              = (querySelector(".search-form-input-length-lt") as InputElement ).value ;  
    form.upGt                  = (querySelector(".search-form-input-up-gt") as InputElement ).value ;  
    form.upLt                  = (querySelector(".search-form-input-up-lt") as InputElement ).value ;  
    form.upperPointElevetionGt = (querySelector(".search-form-input-upper-point-elevetion-gt") as InputElement ).value ;  
    form.upperPointElevetionLt = (querySelector(".search-form-input-upper-point-elevetion-lt") as InputElement ).value ;  
    form.inclinationUpGt       = (querySelector(".search-form-input-inclination-up-gt") as InputElement ).value ;  
    form.inclinationUpLt       = (querySelector(".search-form-input-inclination-up-lt") as InputElement ).value ;  
    form.difficultyGt          = (querySelector(".search-form-input-difficulty-gt") as InputElement ).value ;  
    form.difficultyLt          = (querySelector(".search-form-input-difficulty-lt") as InputElement ).value ;  
     
   if(mapFilter){
      form.mapBoundNELat  = double.parse((querySelector('#search-form-input-location-ne-lat') as InputElement ).value);
      form.mapBoundNELong = double.parse((querySelector('#search-form-input-location-ne-long')as InputElement ).value);
      form.mapBoundSWLat  = double.parse((querySelector('#search-form-input-location-sw-lat') as InputElement ).value);
      form.mapBoundSWLong = double.parse((querySelector('#search-form-input-location-sw-long')as InputElement ).value);
    }
  
    return form;
  }
  
  
  void removeResults(String selector){
    Element result = querySelector(selector);
    while(result != null){
      result.remove();
      result = querySelector(selector);
    }
  }

  void showPage() {
    organizeSpaces();
    showBySelector("#${name}W");
    showBySelector("#${name}NE");
    showBySelector("#search-results-map-canvas", hiddenClass: "gx-hidden-map");
    _initTraceSearchPage();
    js.context.map.refreshTiles();
  }
  
  void hidePage() {
    hideBySelector("#${name}W");
    hideBySelector("#${name}NE");
    hideBySelector("#search-results-map-canvas", hiddenClass: "gx-hidden-map");
  }

}

