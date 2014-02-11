//Auto-generated by RSP Compiler
//Source: aboutApplicationFragment.rsp.html
part of trails;

/** Template, aboutApplicationFragment, for rendering the view. */
Future aboutApplicationFragment(HttpConnect connect) { //#2
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  if (!Rsp.init(connect, "text/html; charset=utf-8"))
    return new Future.value();

  response.write("""

           <h1>A propos de la-boussole</h1>
           <div class="text-warning  form-error-message" >Cette application est actuellement en construction.</div>
        
           <h2>Le propos</h2>
           
           <p>Cette application a pour but de partager des traces gps. Au delà de cette vue technique, elle permet 
           aux utilisateurs de faire découvrir des sentiers en forêt, un parcours idéal pour un entrainement de 
           running, une sortie facile et dépaysante en ski de randonnées ou bien simplement un joli coin de nature
            inconnu.</p>

      <p>Innovante :</p>
       <ul>
         <li>la navigation par la boussole centrale permet à l'utilisateur de se focaliser sur ce qui l'intéresse : par exemple il peut afficher en plein écran la carte IGN de la trace gps.</li> 
         <li>proposer une boucle d'amélioration continue de l'application au utilisateur en intégrant un outil permettant d'effectuer des propositions ou de lever un bug.</li>
         <li>la technologie utilisée est en avance de phase : Dart 1.0 date de novembre 2013.</li>
       </ul>
<p>L'interface se veut sobre et efficace : présenter uniquement les informations nécessaires pour ne pas polluer
 les utilisateurs de détails superflus ou de publicités.</p>

<p>Enfin, l’intégralité du code fournissant cette application est ouvert et disponible sur <a href="https://github.com/GeReinhart/app-share-gps-trace"  target="_blank" >GitHub</a>.</p>
           

"""); //#2

  return new Future.value();
}
