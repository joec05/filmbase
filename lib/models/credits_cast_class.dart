class CreditsCastClass{
  int id;
  String name;
  String originalName;
  String character;
  String? cover;
  double popularity;
  int order;
  bool adult;
  int gender;
  String knownForDepartment;

  CreditsCastClass(
    this.id,
    this.name,
    this.originalName,
    this.character,
    this.cover,
    this.popularity,
    this.order,
    this.adult,
    this.gender,
    this.knownForDepartment
  );

  factory CreditsCastClass.fromMap(Map map){
    return CreditsCastClass(
      map['id'], 
      map['name'], 
      map['original_name'], 
      map['character'], 
      map['profile_path'], 
      map['popularity'], 
      map['order'], 
      map['adult'], 
      map['gender'], 
      map['known_for_department']
    );
  }
}