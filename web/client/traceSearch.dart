import "dart:html";
import "dart:convert";
import 'package:bootjack/bootjack.dart';
//import 'package:js/js.dart' as js;

import 'spaces.dart';
import "forms.dart";

SpacesLayout layout;

void main() {
  layout = new SpacesLayout.withWestSpace(180,70,50);
  
  querySelector(".search-form-btn").onClick.listen((e) {
    submitRequest();
  });  
}

void submitRequest(){
  HttpRequest request = new HttpRequest();

  layout.startLoading();
  request.onReadyStateChange.listen((_) {
    if (request.readyState == HttpRequest.DONE ) {
      displaySearchResults(request);
    }
  });
  sendSearchRequest(request);
  removeResults(".search-default-results");
  removeResults(".search-results");
}

void displaySearchResults(HttpRequest request){
  SearchForm form = new SearchForm.fromMap(JSON.decode(request.responseText));
  
  Element searchResultRow=  querySelector("#search-result-row");
  Element searchResultBody=  querySelector("#search-result-body");
  //js.context.removeAllMarkers();
  if (form.results != null && form.results.isNotEmpty){
    
    form.results.forEach((ligthTrace){
      Element searchResultCurrentRow = searchResultRow.clone(true) ;
      searchResultCurrentRow.className = "search-results" ;
      searchResultCurrentRow.children[0].innerHtml = ligthTrace.creator;
      searchResultCurrentRow.children[1].innerHtml = ligthTrace.title;
      searchResultCurrentRow.children[2].innerHtml = ligthTrace.activities;
      searchResultCurrentRow.children[3].innerHtml = ligthTrace.length;
      searchResultCurrentRow.children[4].innerHtml = ligthTrace.up;
      searchResultCurrentRow.children[5].innerHtml = ligthTrace.upperPointElevetion;
      searchResultCurrentRow.children[6].innerHtml = ligthTrace.inclinationUp;
      searchResultCurrentRow.children[7].innerHtml = ligthTrace.difficulty;
      searchResultBody.append(searchResultCurrentRow);
      
      //js.context.addMarkerToMap( ligthTrace.keyJsSafe,  ligthTrace.titleJsSafe, ligthTrace.startPointLatitude,ligthTrace.startPointLongitude );
    });
    
    //js.context.fitMapViewPortWithMarkers();
  }
  layout.stopLoading();
}

void sendSearchRequest(HttpRequest request){
  request.open("POST",  "/trace.as_search", async: true);
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

  /*var map = js.context.map ;
  
  var locationFilter = ( querySelector(".search-form-input-location") as CheckboxInputElement).checked;
  if (locationFilter && map !=null){
    form.mapBoundNELat = map.getBounds().getNorthEast().lat();
    form.mapBoundNELong = map.getBounds().getNorthEast().lng();
    form.mapBoundSWLat = map.getBounds().getSouthWest().lat();
    form.mapBoundSWLong = map.getBounds().getSouthWest().lng();
  }*/
  
  request.send(JSON.encode(form.toJson()));

}



void removeResults(String selector){
  Element defaultResult = querySelector(selector);
  while(defaultResult != null){
    defaultResult.remove();
    defaultResult = querySelector(selector);
  }
}

