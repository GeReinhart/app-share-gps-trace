//Auto-generated by RSP Compiler
//Source: aboutFeedbacksFragment.rsp.html
part of trails;

/** Template, aboutFeedbacksFragment, for rendering the view. */
Future aboutFeedbacksFragment(HttpConnect connect) { //#2
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  if (!Rsp.init(connect, "text/html; charset=utf-8"))
    return new Future.value();

  response.write("""

<h2>Retour utilisateurs</h2>

<div class="feedbacks-comments-section" style="margin-top: 20px"  >
  <div>
    <button  id="feedbacks-add-comment-btn" type="submit" class="gx-hidden btn btn-primary">Faire un retour utilisateur sur la-boussole</button>
  </div>
  <div style="margin-top: 20px" class="feedbacks-comments-div gx-vertical-optional-scroll" >
        <table class="table" style="width: 100%"> 
          <tbody id="feedbacks-comments" >  
             <tr class="gx-hidden" >
              <td style="width: 12%; text-align: center;" >
                 <div class="feedbacks-comment-creator" ></div>
                 <br/>
                 <div class="feedbacks-comment-date small-text"></div>
              </td>  
              <td style="width: *" >
                 <span class="feedbacks-comment-content"></span>
                 <span class="feedbacks-comment-update gx-as-link">
                   <img src="/assets/img/trace_update.png" width="15px"/>
                 </span>
              </td>
              <td style="width: 3%" >

              </td>   
             </tr>
          </tbody>  
        </table>
  </div>
</div> """); //#2

  return new Future.value();
}
