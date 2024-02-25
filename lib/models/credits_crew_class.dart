class CreditsCrewClass{
  int id;
  String name;
  String originalName;
  String department;
  String job;
  String? cover;
  double popularity;
  bool adult;
  int gender;
  String knownForDepartment;

  CreditsCrewClass(
    this.id,
    this.name,
    this.originalName,
    this.department,
    this.job,
    this.cover,
    this.popularity,
    this.adult,
    this.gender,
    this.knownForDepartment
  );

  factory CreditsCrewClass.fromMap(Map map){
    return CreditsCrewClass(
      map['id'], 
      map['name'], 
      map['original_name'], 
      map['department'],
      map['job'], 
      map['profile_path'], 
      map['popularity'], 
      map['adult'], 
      map['gender'], 
      map['known_for_department']
    );
  }
}