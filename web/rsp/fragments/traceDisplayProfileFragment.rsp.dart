//Auto-generated by RSP Compiler
//Source: traceDisplayProfileFragment.rsp.html
part of trails;

/** Template, traceDisplayProfileFragment, for rendering the view. */
Future traceDisplayProfileFragment(HttpConnect connect, {traceRenderer}) { //#2
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  if (!Rsp.init(connect, "text/html; charset=utf-8"))
    return new Future.value();

  return Rsp.nnf(traceProfileViewer(new HttpConnect.chain(connect), traceAnalysisRenderer: traceRenderer.traceAnalysisRenderer)).then((_) { //include#2

    return new Future.value();
  }); //end-of-include
}