import "dart:html";
import "dart:convert";
import 'package:bootjack/bootjack.dart';

import 'spaces.dart';
import "forms.dart";

void main() {
  SpacesLayout layout = new SpacesLayout(180,70,50);
  
  querySelector(".form-control").onKeyUp.listen((e) {
    submitRequest(layout);
  });
  
}

void submitRequest(SpacesLayout layout){
  layout.startLoading();
  
  HttpRequest request = new HttpRequest();
  
  request.onReadyStateChange.listen((_) {
    
    if (request.readyState == HttpRequest.DONE ) {

      removeResults(".search-default-results");
      removeResults(".search-results");
      
      SearchForm form = new SearchForm.fromMap(JSON.decode(request.responseText));
      
      Element searchResultRow=  querySelector("#search-result-row");
      Element searchResultBody=  querySelector("#search-result-body");
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
        });
      }
      layout.stopLoading();
    }
  });

  request.open("POST",  "/trace.as_search", async: false);
  SearchForm form =  new  SearchForm( );
  form.creator = (querySelector(".input-creator") as InputElement ).value ;
  request.send(JSON.encode(form.toJson()));
}


void removeResults(String selector){
  Element defaultResult = querySelector(selector);
  while(defaultResult != null){
    defaultResult.remove();
    defaultResult = querySelector(selector);
  }
}

