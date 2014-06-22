//Auto-generated by RSP Compiler
//Source: aboutDevFragment.rsp.html
part of trails;

/** Template, aboutDevFragment, for rendering the view. */
Future aboutDevFragment(HttpConnect connect) { //#2
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  if (!Rsp.init(connect, "text/html; charset=utf-8"))
    return new Future.value();

  response.write("""

           <h2>Fonctionnalités</h2>

           <h3>A venir</h3>
               <ul>
                 <li>exploiter la notion de temps des traces GPS</li>
                 <li>pouvoir donner une note à une trace</li>
                 <li>ajout de photos pour une trace</li>
                 <li>...</li>
                 <li>course poursuite virtuelle</li>
                 <li>suivi de coureur</li>
               </ul>

           <h3>23 juin 2014 : Permettre des retours utilisateurs</h3>

           <h3>20 juin 2014 : Ajout de commentaire à une trace</h3>

           <h3>15 mai 2014 : Possibilité d'enregister une recherche par l'url</h3>
               <ul>
                 <li>les critères des recherches sont stockés dans l'url</li>
                 <li>une recherche peut être ajoutée comme favoris dans le navigateur</li>
                 <li>par exemple : <a target="_blank" href="http://www.la-boussole.info/#trace_search?s=rando des nuls&c=&a=trek&lg=&ll=&ug=&ul=&sg=&sl=&eg=&el=&nea=45.64860838388028&neo=9.591064453125&swa=44.315987905196906&swo=2.9827880859375">"les randos des nuls"</a>  </li>
               </ul>

           <h3>14 mai 2014 : Navigation dans les traces</h3>
               <ul>
                 <li>accès aux traces ouvertes dans le menu en haut à droite</li>
                 <li>passage à la trace suivante</li>
                 <li>passage à la trace précédente</li>
                 <li>suppression de la trace courante</li>
               </ul>

           <h3>26 avril 2014 : Bouton actions au centre</h3>
               <ul>
                 <li>possibilité d'effectuer les principales actions depuis la boussole elle même</li>
               </ul>

           <h3>22 avril 2014 : Marqueurs</h3>
               <ul>
                 <li>possibilité d'ajouter/modifier/supprimer un marqueur sur une trace</li>
                 <li>marqueur : point d'eau, refuge, bivouac...</li>
               </ul>


           <h3>15 avril 2014 : Première version stable</h3>
               <ul>
                 <li>ajout d'une trace au format GPX</li>
                 <li>recherche évoluée de traces</li>
                 <li>visualisation de trace</li>
               </ul>
"""); //#2

  return new Future.value();
}
