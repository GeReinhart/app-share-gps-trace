//Auto-generated by RSP Compiler
//Source: searchResults.rsp.html
part of trails;

/** Template, searchResults, for rendering the view. */
Future searchResults(HttpConnect connect) { //#2
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  if (!Rsp.init(connect, "text/html; charset=utf-8"))
    return new Future.value();

  response.write("""

        <table class="table" style="width: 100% ;margin-top: 40px">  
          <thead>  
            <tr>  
              <th style="width: 10%" >Auteur</th>  
              <th style="width: *" >Trace</th>  
              <th style="width: 15%" >Activités</th>  
              <th style="width: 10%" >Distance</th>  
              <th style="width: 10%" >Dénivelé</th>
              <th style="width: 10%" >Sommet</th>
              <th style="width: 10%" >Pente</th>
              <th style="width: 10%" >Difficulté</th>
            </tr>  
          </thead>  
          <tbody id="search-result-body" >  
             <tr id="search-result-row"  >
                  <td></td>  
                  <td></td>  
                  <td></td>
                  <td></td>  
                  <td></td>
                  <td></td>
                  <td></td>
                  <td></td>
             </tr>
          </tbody>  
        </table>
"""); //#2

  return new Future.value();
}
