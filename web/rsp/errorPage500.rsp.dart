//Auto-generated by RSP Compiler
//Source: errorPage500.rsp.html
part of trails;

/** Template, errorPage500, for rendering the view. */
Future errorPage500(HttpConnect connect) { //#2
  var _t0_, _cs_ = new List<HttpConnect>();
  HttpRequest request = connect.request;
  HttpResponse response = connect.response;
  if (!Rsp.init(connect, "text/html; charset=utf-8"))
    return new Future.value();

  response.write("""<!DOCTYPE html>
<html>
 <head>
     <title>La Boussole - erreur du serveur</title>
"""); //#2

  return connect.include("/rsp/templates/assetsimports.html").then((_) { //include#6

    response.write("""  </head>
  <body>   
"""); //#7

    var _0 = new StringBuffer(); _cs_.add(connect); //var#10
    connect = new HttpConnect.stringBuffer(connect, _0); response = connect.response;

    response.write("""           <h1>Erreur coté serveur</h1>
           <p>Veuillez réessayer l'opération plus tard.</p>
           <p>Si le problème persiste, merci de contacter le gestionnaire de la-boussole.</p>
"""); //#11

    connect = _cs_.removeLast(); response = connect.response;

    var _1 = new StringBuffer(); _cs_.add(connect); //var#15
    connect = new HttpConnect.stringBuffer(connect, _1); response = connect.response;

    connect = _cs_.removeLast(); response = connect.response;

    var _2 = new StringBuffer(); _cs_.add(connect); //var#16
    connect = new HttpConnect.stringBuffer(connect, _2); response = connect.response;

    connect = _cs_.removeLast(); response = connect.response;

    var _3 = new StringBuffer(); _cs_.add(connect); //var#17
    connect = new HttpConnect.stringBuffer(connect, _3); response = connect.response;

    connect = _cs_.removeLast(); response = connect.response;

    return Rsp.nnf(spaces(new HttpConnect.chain(connect), nw: _0.toString(), ne: _1.toString(), sw: _2.toString(), se: _3.toString())).then((_) { //include#9

      return Rsp.nnf(sharedWidgets(new HttpConnect.chain(connect), sharedWidgetsId: "sharedWidgets")).then((_) { //include#19

        response.write("""    <script type="application/dart" src="/client/pages/error.dart"></script>
    <script src="/packages/browser/dart.js"></script>
  </body>
</html>
"""); //#20

        return new Future.value();
      }); //end-of-include
    }); //end-of-include
  }); //end-of-include
}
