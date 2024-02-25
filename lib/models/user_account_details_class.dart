class UserAccountDetailsClass{
  int id;
  String name;
  String username;
  String? cover;
  bool includeAdult;

  UserAccountDetailsClass(
    this.id,
    this.name,
    this.username,
    this.cover,
    this.includeAdult,
  );

  UserAccountDetailsClass createDuplicate(){
    return UserAccountDetailsClass(
      id, name, username, cover, includeAdult
    );
  }

  factory UserAccountDetailsClass.fromMap(Map map){
    return UserAccountDetailsClass(
      map['id'], 
      map['name'], 
      map['username'],
      map['avatar']['tmdb']['avatar_path'],
      map['include_adult'],
    );
  }
}