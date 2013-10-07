
class Trail {
  
  String id;
  
  String creator;
  
  String title ;

  String traceFile;
  
  String description ;
  
  Trail(this.creator, this.title, this.traceFile);

  Trail.withId(this.id,this.creator, this.title, this.traceFile);
  
  Trail.fromJson(Map map) {
    id = map['_id'];
    creator = map['creator'];
    title = map['title'];
    traceFile = map['traceFile'];
    description = map['description'];
  }
  
  Map toJson() {
    return {'_id': id,'creator': creator, 'title': title, 'traceFile': traceFile, 'description': description};
  }
  

}