//Auto-generated by RSP Compiler
//Source: centerWidget.rsp.html
part of trails;

/** Template, centerWidget, for rendering the view. */
Future centerWidget(HttpConnect connect, {centerId}) { //#2
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  if (!Rsp.init(connect, "text/html; charset=utf-8"))
    return new Future.value();

  response.write("""    <div id=\""""); //#2

  response.write(Rsp.nnx(centerId)); //#2


  response.write("""" class="space-center">
        <img  id=\""""); //#2

  response.write(Rsp.nnx(centerId)); //#3


  response.write("""-img" style="cursor:move" height="180px" width="180px" src="/assets/img/compass_275.png"></img>
    </div>
"""); //#3

  return new Future.value();
}