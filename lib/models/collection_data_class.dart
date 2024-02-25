import 'package:filmbase/models/item_image_class.dart';

class CollectionDataClass{
  int id;
  String name;
  String overview;
  String? cover;
  String? backdropPath;
  List<int> movies;
  List<int> tvShows;
  List<ItemImageClass> images;

  CollectionDataClass(
    this.id,
    this.name,
    this.overview,
    this.cover,
    this.backdropPath,
    this.movies,
    this.tvShows,
    this.images
  );

  factory CollectionDataClass.fromMap(Map map){
    return CollectionDataClass(
      map['id'], 
      map['name'], 
      map['overview'], 
      map['poster_path'], 
      map['backdrop_path'],
      List<int>.from(map['movies']),
      List<int>.from(map['tv_shows']),
      List.generate(map['images'].length, (i) => ItemImageClass.fromMap(map['images'][i]))
    );
  }

  factory CollectionDataClass.fromMapBasic(Map map){
    return CollectionDataClass(
      map['id'], 
      map['name'], 
      map['overview'] ?? '', 
      map['poster_path'] ?? '', 
      map['backdrop_path'] ?? '',
      [], [], []
    );
  }

  factory CollectionDataClass.generateNewInstance(){
    return CollectionDataClass(
      0, '', '', '', '', [], [], []
    );
  }
}