//Auto-generated by RSP Compiler
//Source: persistentMenuWidget.rsp.html
part of trails;

/** Template, persistentMenuWidget, for rendering the view. */
Future persistentMenuWidget(HttpConnect connect, {persistentMenuId}) { //#2
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  if (!Rsp.init(connect, "text/html; charset=utf-8"))
    return new Future.value();

  response.write("""<div id=\""""); //#2

  response.write(Rsp.nnx(persistentMenuId)); //#2


  response.write(""""   class="space-persitent-menu" >
  <span id=\""""); //#2

  response.write(Rsp.nnx(persistentMenuId)); //#3


  response.write("""-user" class="inverse-video-display" >utilisateur """); //#3

  response.write(Rsp.nnx(currentUser(request.session) != null ?  currentUser(request.session).login: "anonyme")); //#3


  response.write("""</span>
  <span style="background-color: white;" ><a  href="/#about"  >À propos</a></span>
  <span class="inverse-video-display" ><a  href="/#disclaimer"  >Mentions légales et conditions d'utilisation</a></span>
</div>
"""); //#3

  return new Future.value();
}
