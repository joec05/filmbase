import 'package:filmbase/class/media_item_class.dart';

class ListDataClass{
  int id;
  String name;
  String type;
  String? cover;
  String description;
  String? creator;
  int favouriteCount;
  int itemCount;
  List<MediaItemClass> mediaItems;

  ListDataClass(
    this.id,
    this.name,
    this.type,
    this.cover,
    this.description,
    this.creator,
    this.favouriteCount,
    this.itemCount,
    this.mediaItems
  );

  ListDataClass createDuplicate(){
    return ListDataClass(
      id, name, type, cover, description, creator, favouriteCount,
      itemCount, mediaItems
    );
  }

  ListDataClass fromMapCreate(Map map){
    return ListDataClass(
      map['id'], 
      map['name'],
      map['type'], 
      null, 
      map['description'],
      creator, 
      favouriteCount, 
      itemCount,
      mediaItems
    );
  }

  ListDataClass fromMapBasic(Map map){
    return ListDataClass(
      map['id'], 
      map['name'],
      map['list_type'], 
      map['poster_path'], 
      map['description'],
      map['created_by'], 
      map['favorite_count'], 
      map['item_count'],
      mediaItems
    );
  }

  ListDataClass fromMap(Map map){
    return ListDataClass(
      map['id'], 
      map['name'],
      map['list_type'] ?? type, 
      map['poster_path'], 
      map['description'],
      map['created_by'], 
      map['favorite_count'], 
      map['item_count'],
      map['media_items'] ?? mediaItems
    );
  }

  factory ListDataClass.generateNewInstance(int id){
    return ListDataClass(
      id, '', '', '', '', '', 0, 0, []
    );
  }
}