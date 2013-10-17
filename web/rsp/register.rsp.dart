//Auto-generated by RSP Compiler
//Source: register.rsp.html
part of trails;

/** Template, register, for rendering the view. */
Future register(HttpConnect connect) { //#2
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  Rsp.init(connect, "text/html; charset=utf-8");

  response.write("""<!DOCTYPE html>

<html>
 <head>
   <meta charset="utf-8">   
	 <title>La Boussole</title>
	 <link rel="shortcut icon" type="image/x-icon" href="img/compass_275.png" ><link>	
     <link href="css/bootstrap.css"  rel="stylesheet" media="screen" ><link>   
     <link href="css/dart-trails.css" rel="stylesheet" media="screen" ><link>
     <script src="js/google-analytics.js"></script>  
  </head>
 
  <body>   
  
  <div class="spaces" >
    <div class="space space-north-west"  > 
    
        <h1>Enregistrement</h1>
"""); //#2

  if (request.uri.queryParameters["retry"] != null) { //if#20

    response.write("""        <div class="text-warning">Mauvais login ou mot de passe.</div>
"""); //#21
  } //if

  response.write("""        <form id="registerForm" role="form"  action="/s_register" method="post" accept-charset="UTF-8">
          <div class="form-group">
            <input name="s_login" type="text" class="form-control" id="s_login" placeholder="Login">
          </div>
          <div class="form-group">
            <input name="s_password" type="password" class="form-control" id="s_password" placeholder="Mot de passe">
          </div>        
          <div class="form-group">
            <input name="s_passwordConfirm" type="password" class="form-control" id="s_passwordConfirm" placeholder="Confirmation mot de passe">
          </div>    
          <button id="registerSubmit" type="submit" class="btn btn-default">S'enregister</button>
        </form>    
    
    </div>
    <div class="space space-north-east"  > &nbsp; </div>
    <div class="space space-south-west"  > &nbsp; </div>
    <div class="space space-south-east"  > &nbsp; </div>
    <div class="space-center" ><a href="/about"><img   height="180px" width="180px" src="img/compass_275.png"></img></a></div>
  </div>


    <script type="application/dart" src="client/register.dart"></script>
    <script src="packages/browser/dart.js"></script>
  </body>
</html>
"""); //#23

  return Rsp.nnf();
}