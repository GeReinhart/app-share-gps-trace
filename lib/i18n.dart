

class I18n{

  static get defaultLang => "fr" ;
  
  static Map _translations = {
                                          "fr":
                                               {
                                                 "activity-trek":"rando",
                                                 "activity-running":"course à pied",
                                                 "activity-bike":"vélo de route",
                                                 "activity-mountainbike":"vtt",
                                                 "activity-skitouring":"ski de randonnée",
                                                 "activity-snowshoe":"raquettes",
                                                 }  
                              } ;

  static String translate(String lang,String key) { 
    String translation = "***no translation for ${key} in ${lang}***" ;
    if( _translations.containsKey(lang) &&  _translations[lang].containsKey(key)  ){
      translation = _translations[lang][key]; 
    }
    return translation;
  }

  
}