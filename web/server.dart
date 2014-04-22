library trails;

import "dart:io";
import "dart:async";
import "package:rikulo_security/security.dart";
import "package:stream/stream.dart";

import  "../lib/persistence.dart";
import  "../lib/aaa.dart";
import  "../lib/controllers.dart";


class TracesServer{
  
  String host;
  int port;
  
  TraceController _traceController;
  UserServerController _userServerController;
  FragmentsController _fragmentsController;
  ErrorServerController _errorServerController;
  
  TracesServer(this.host,this.port){
    createApplicationContext();
  }
  
  TracesServer.forHeroku(){
    host ="0.0.0.0";
    port = int.parse(Platform.environment['PORT']);
    createApplicationContext();
  }
  
  void createApplicationContext(){
    String mongoDbUri = Platform.environment['MONGO_DB_URI'] ;
    String appUri = Platform.environment['APP_TRACE_URI'] ;
    print ("Db: "+mongoDbUri);

    PersistenceLayer _persistenceLayer = new MongoPersistence(mongoDbUri);
    _persistenceLayer.open();
    Crypto _crypto = new Crypto();
    _traceController = new TraceController(_persistenceLayer,_crypto,appUri) ;
    _userServerController = new UserServerController(_persistenceLayer,_crypto) ;
    _fragmentsController = new FragmentsController(_persistenceLayer);
    _errorServerController = new ErrorServerController();
  }
  
  
  void start(){
    new StreamServer(
        uriMapping: {
          "/": _traceController.indexShow, 
          "/sandbox": _traceController.sandboxShow, 
          
          "/j_register": _userServerController.jsonRegister,
          "/j_login": _userServerController.jsonLogin,
          "/j_logout": _userServerController.jsonLogout,
          "/j_trace_search": _traceController.jsonTraceSearch,
          "/j_trace_delete": _traceController.jsonTraceDelete,
          "/j_trace_details/(creator:[^/]*)/(titleKey:[^/]*)": _traceController.jsonTraceDetails,
          "/j_trace_create_or_update": _traceController.jsonTraceCreateOrUpdate,
          "/j_watch_point_create_or_update": _traceController.jsonWatchPointCreateOrUpdate,
          "/j_watch_point_select": _traceController.jsonWatchPointSelect,
          "/j_watch_point_delete": _traceController.jsonWatchPointDelete,
          
          "/f_index_text" : _fragmentsController.indexText,
          "/f_index_buttons" : _fragmentsController.indexButtons,
          "/f_legal_disclaimer" : _fragmentsController.legalDisclaimer,
          "/f_legal_terms" : _fragmentsController.legalTerms,

          "/f_about_application" : _fragmentsController.aboutApplication,
          "/f_about_dev" : _fragmentsController.aboutDev,          
          "/f_about_feedbacks" : _fragmentsController.aboutFeedbacks,
          "/f_about_author" : _fragmentsController.aboutAuthor,
          "/f_trace_form": _fragmentsController.traceCreateOrUpdateForm, 
          "/f_trace_search_form": _fragmentsController.traceSearchForm, 
          "/f_trace_search_results": _fragmentsController.traceSearchResults, 
          "/f_trace_search_map": _fragmentsController.traceSearchMap, 
          
          "/trace/(creator:[^/]*)/(titleKey:[^/]*)": _traceController.traceShowByKey,
          "/trace.gpx/(creator:[^/]*)/(titleKey:[^/]*)": _traceController.traceFormatGpxShowByKey,
          "/trace.gpx/id-(traceId:[^/]*)": _traceController.traceFormatGpxShowById,
          

          
          
        },/*
        filterMapping: {
          "/trace\.add.*": _traceController.security.filter
        },*/
        errorMapping: {
          "403": _errorServerController.errorPage403Show,
          "404": _errorServerController.errorPage404Show,
           "500": _errorServerController.errorPage500Show
        }
    ).start(address:host, port:port);
  }

}








