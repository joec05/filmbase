import 'package:filmbase/global_files.dart';

class NetworkDataClass{
  int id;
  String name;
  String? cover;
  String originCountry;
  String homepage;
  String headquarters;
  List<String> alternativeNames;
  List<ItemImageClass> images;

  NetworkDataClass(
    this.id,
    this.name,
    this.cover,
    this.originCountry,
    this.homepage,
    this.headquarters,
    this.alternativeNames,
    this.images
  );

  NetworkDataClass fromMapBasic(Map map){
    return NetworkDataClass(
      map['id'], 
      map['name'],
      map['logo_path'], 
      map['origin_country'],
      homepage,
      headquarters,
      alternativeNames,
      images
    );
  }

  NetworkDataClass fromMap(Map map){
    return NetworkDataClass(
      map['id'], 
      map['name'],
      map['logo_path'], 
      map['origin_country'],
      map['homepage'],
      map['headquarters'], 
      List.generate(map['alternative_names'].length, (i) => map['alternative_names'][i]['name']),
      List.generate(map['images'].length, (i) => ItemImageClass.fromMap(map['images'][i])),
    );
  }

  factory NetworkDataClass.generateNewInstance(){
    return NetworkDataClass(
      0, '', '', '', '', '', [], []
    );
  }
}