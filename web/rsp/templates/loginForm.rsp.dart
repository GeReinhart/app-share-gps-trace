//Auto-generated by RSP Compiler
//Source: loginForm.rsp.html
part of trails;

/** Template, loginForm, for rendering the view. */
Future loginForm(HttpConnect connect) { //#3
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  Rsp.init(connect, "text/html; charset=utf-8");

  if (request.uri.queryParameters["retry"] != null) { //if#3

    response.write("""        <div class="text-warning">Mauvais login ou mot de passe.</div>
"""); //#4
  } //if

  response.write("""        <form role="form"  action="/s_login" method="post" accept-charset="UTF-8">
          <div class="form-group">
            <input name="s_username" type="text" class="form-control" id="login" placeholder="Login">
          </div>
          <div class="form-group">
            <input name="s_password" type="password" class="form-control" id="password" placeholder="Mot de passe">
          </div>        
          <button type="submit" class="btn btn-default">Se connecter</button>
        </form>
"""); //#6

  return Rsp.nnf();
}
