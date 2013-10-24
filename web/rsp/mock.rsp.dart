//Auto-generated by RSP Compiler
//Source: mock.rsp.html
part of trails;

/** Template, mock, for rendering the view. */
Future mock(HttpConnect connect) { //#2
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  Rsp.init(connect, "text/html; charset=utf-8");

  response.write("""<!DOCTYPE html>
<html>
 <head>
	 <title>La Boussole - Maquette</title>
"""); //#2

  return connect.include("/rsp/templates/assetsimports.html").then((_) { //include#6

    response.write("""</head>
<body>

<div class="spaces" >
	<div class="space space-north-west"  > 
	 <div class="inner-space" >
  	<h1>La montée du Moucherotte</h1>
  	<h2>Le topo</h2>
  	<p>Longer l'ancien téléski, puis monter droit au-dessus dans la trouée de la forêt (ancienne piste de ski: pente plus soutenue et vernes en train de repousser).
  		A 1410m, l'ancienne piste part à gauche par une route qui contourne la montagne versant Grenoble (plat...). Cette route passe un semblant de défilé rocheux, puis traverse vers le S et monte en lacets vers le sommet (relais radio).
  		Les derniers lacets peuvent être coupés.
  		Les ruines de l'hôtel qui donnait autrefois du "caractère" au sommet ont été détruites.</p>
  	</div>
	</div>
	<div class="space space-north-east"  >
	     <div class="inner-space" >
		     <div class="align-middle"><img style="margin-top: 80px" src="assets/img/mock_elevation.jpg"></img> </div>
		   </div>
   </div>
	<div class="space space-south-west"  > 
	     <div class="inner-space" >
	       <div class="align-middle"><img width="600px" src="assets/img/mock_map.jpg"></img> </div>
       </div>
 	</div>
	<div class="space space-south-east"  >
	     <div class="inner-space" >
	       <div class="align-middle"><img  width="400px" src="assets/img/mock_picture.png"></img></div>
       </div>
	</div>
"""); //#7

    return Rsp.nnf(center(new HttpConnect.chain(connect))).then((_) { //include#36

      return Rsp.nnf(menu(new HttpConnect.chain(connect))).then((_) { //include#37

        response.write("""</div>

   
    <script type="application/dart" src="client/index.dart"></script>
    <script src="packages/browser/dart.js"></script>
</body>
</html>
"""); //#38

        return Rsp.nnf();
      }); //end-of-include
    }); //end-of-include
  }); //end-of-include
}
