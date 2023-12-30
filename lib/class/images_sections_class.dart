import 'package:filmbase/class/item_image_class.dart';

class ImagesSectionsClass{
  List<ItemImageClass> backdrops;
  List<ItemImageClass> logos;
  List<ItemImageClass> posters;

  ImagesSectionsClass(
    this.backdrops,
    this.logos,
    this.posters
  );

  factory ImagesSectionsClass.fromMap(Map map){
    return ImagesSectionsClass(
      List.generate(map['backdrops'].length, (i) => ItemImageClass.fromMap(map['backdrops'][i])), 
      List.generate(map['logos'].length, (i) => ItemImageClass.fromMap(map['logos'][i])),
      List.generate(map['posters'].length, (i) => ItemImageClass.fromMap(map['posters'][i])), 
    );
  }

  factory ImagesSectionsClass.generateNewInstance(){
    return ImagesSectionsClass([], [], []);
  }
}