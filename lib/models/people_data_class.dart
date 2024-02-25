import 'package:filmbase/global_files.dart';

class PeopleDataClass{
  int id;
  String name;
  List<String> otherNames;
  String? cover;
  double popularity;
  int gender;
  String bio;
  String? placeOfBirth;
  String? birthday;
  String? deathday;
  String? homepage;
  bool adult;
  String knownForDepartment;
  List<ItemImageClass> images;
  PeopleCreditsClass credits;

  PeopleDataClass(
    this.id,
    this.name,
    this.otherNames,
    this.cover,
    this.popularity,
    this.gender,
    this.bio,
    this.placeOfBirth,
    this.birthday,
    this.deathday,
    this.homepage,
    this.adult,
    this.knownForDepartment,
    this.images,
    this.credits
  );

  PeopleDataClass fromMap(Map map){
    return PeopleDataClass(
      map['id'], 
      map['name'], 
      List<String>.from(map['also_known_as']),
      map['profile_path'], 
      map['popularity'], 
      map['gender'], 
      map['biography'], 
      map['place_of_birth'], 
      map['birthday'], 
      map['deathday'], 
      map['homepage'], 
      map['adult'], 
      map['known_for_department'],
      List.generate(map['images'].length, (i) => ItemImageClass.fromMap(map['images'][i])),
      PeopleCreditsClass.fromMap(map['credits'])
    );
  }

  PeopleDataClass fromMapBasic(Map map){
    return PeopleDataClass(
      map['id'], 
      map['name'], 
      List<String>.from(map['also_known_as']),
      map['profile_path'], 
      map['popularity'], 
      map['gender'], 
      map['biography'], 
      map['place_of_birth'], 
      map['birthday'], 
      map['deathday'], 
      map['homepage'], 
      map['adult'], 
      map['known_for_department'],
      images,
      credits
    );
  }

  factory PeopleDataClass.generateNewInstance(int id){
    return PeopleDataClass(
      id, '', [], '', 0, 0, '', '', '', '', '', false, '', [], PeopleCreditsClass.generateNewInstance()
    );
  }
}