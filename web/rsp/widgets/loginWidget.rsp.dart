//Auto-generated by RSP Compiler
//Source: loginWidget.rsp.html
part of trails;

/** Template, loginWidget, for rendering the view. */
Future loginWidget(HttpConnect connect, {loginId}) { //#2
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  if (!Rsp.init(connect, "text/html; charset=utf-8"))
    return new Future.value();

  response.write("""

    <div id=\""""); //#2

  response.write(Rsp.nnx(loginId)); //#3


  response.write("""" class="modal fade" tabindex="-1" role="dialog" style="z-index: 0">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h3>Connection</h3>
          </div>
          <div class="modal-body">
                <div class="form-group">
                  <input id=\""""); //#3

  response.write(Rsp.nnx(loginId)); //#11


  response.write("""-input-login" type="text" class="form-control"  placeholder="Login">
                </div>
                <div class="form-group">
                  <input id=\""""); //#11

  response.write(Rsp.nnx(loginId)); //#14


  response.write("""-input-password" type="password" class="form-control"  placeholder="Mot de passe">
                </div>        
          </div>
          <div class="modal-footer">
            <button id=\""""); //#14

  response.write(Rsp.nnx(loginId)); //#18


  response.write("""-btn-login" type="submit" class="btn btn-primary">Se connecter</button>
            <button id=\""""); //#18

  response.write(Rsp.nnx(loginId)); //#19


  response.write("""-btn-cancel" class="btn btn-default">Annuler</button>
             <div id=\""""); //#19

  response.write(Rsp.nnx(loginId)); //#20


  response.write("""-error-message" class="text-warning" ></div>
          </div>
        </div>
      </div>
    </div>         
"""); //#20

  return new Future.value();
}
