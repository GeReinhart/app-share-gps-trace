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
	 <title>La Boussole - Enregistrement</title>
"""); //#2

  return connect.include("/rsp/templates/assetsimports.html").then((_) { //include#7

    response.write("""  </head>
 
  <body>   
  
  <div class="spaces" >
    <div class="space space-north-west"  > 
    
        <h1>Enregistrement</h1>

          <div class="form-group form-login">
            <input  type="text" class="form-control input-login"  placeholder="Login">
          </div>
          <div class="form-group form-password">
            <input  type="password" class="form-control input-password"  placeholder="Mot de passe">
          </div>        
          <div class="form-group form-passwordConfirm">
            <input  type="password" class="form-control input-passwordConfirm"  placeholder="Confirmation mot de passe">
          </div>    
          <div class="form-group">
              <button  type="submit" class="btn btn-default btn-submit-register">S'enregister</button>
              <div class="text-warning  form-error-message" ></div>
          </div>    
    </div>
    <div class="space space-north-east"  > &nbsp; </div>
    <div class="space space-south-west"  > &nbsp; </div>
    <div class="space space-south-east"  > &nbsp; </div>
"""); //#8

    return Rsp.nnf(center(new HttpConnect.chain(connect))).then((_) { //include#34

      return Rsp.nnf(menu(new HttpConnect.chain(connect))).then((_) { //include#35

        response.write("""  </div>


    <script type="application/dart" src="client/register.dart"></script>
    <script src="packages/browser/dart.js"></script>
  </body>
</html>
"""); //#36

        return Rsp.nnf();
      }); //end-of-include
    }); //end-of-include
  }); //end-of-include
}
