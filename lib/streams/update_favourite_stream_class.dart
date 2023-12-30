import 'dart:async';
import 'package:filmbase/appdata/global_enums.dart';

class FavouriteStreamControllerClass{
  final UpdateStreamActionType actionType;
  final UpdateStreamDataType dataType;
  final int id;

  FavouriteStreamControllerClass(
    this.id,
    this.dataType,
    this.actionType
  );
}

class UpdateFavouriteStreamClass {
  static final UpdateFavouriteStreamClass _instance = UpdateFavouriteStreamClass._internal();
  late StreamController<FavouriteStreamControllerClass> _updateFavouriteStreamController;

  factory UpdateFavouriteStreamClass(){
    return _instance;
  }

  UpdateFavouriteStreamClass._internal() {
    _updateFavouriteStreamController = StreamController<FavouriteStreamControllerClass>.broadcast();
  }

  Stream<FavouriteStreamControllerClass> get updateFavouriteStream => _updateFavouriteStreamController.stream;


  void removeListener(){
    _updateFavouriteStreamController.stream.drain();
  }

  void emitData(FavouriteStreamControllerClass data){
    if(!_updateFavouriteStreamController.isClosed){
      _updateFavouriteStreamController.add(data);
    }
  }

  void dispose(){
    _updateFavouriteStreamController.close();
  }
}