//Auto-generated by RSP Compiler
//Source: center.rsp.html
part of trails;

/** Template, center, for rendering the view. */
Future center(HttpConnect connect) { //#2
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  Rsp.init(connect, "text/html; charset=utf-8");

  response.write("""<div class="space-center" ><a href="#"><img  height="180px" width="180px" src="assets/img/compass_275.png"></img></a></div>"""); //#2

  return Rsp.nnf();
}
