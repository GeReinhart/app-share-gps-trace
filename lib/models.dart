

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

class User {
  
  String id;

  String login;

  String encryptedPassword;
  
  String firstName;
  
  String lastName ;
  
  User(this.login, this.encryptedPassword, this.firstName, this.lastName);

  User.withLogin(this.login, this.encryptedPassword);
  
  User.withId(this.id,this.login, this.encryptedPassword, this.firstName, this.lastName);
  
  User.fromJson(Map map) {
    id = map['_id'];
    login = map['login'];
    encryptedPassword = map['encryptedPassword'];
    firstName = map['firstName'];
    lastName = map['lastName'];
  }
  
  Map toJson() {
    return {'_id': id,'login': login, 'encryptedPassword': encryptedPassword, 
      'firstName': firstName, 'lastName': lastName};
  }
  
  
}
