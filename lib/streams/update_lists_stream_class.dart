import 'dart:async';
import 'package:filmbase/global_files.dart';

class ListsStreamControllerClass{
  final UpdateStreamActionType actionType;
  final int itemID;

  ListsStreamControllerClass(
    this.actionType,
    this.itemID,
  );
}

class UpdateListsStreamClass {
  static final UpdateListsStreamClass _instance = UpdateListsStreamClass._internal();
  late StreamController<ListsStreamControllerClass> _updateListsStreamController;

  factory UpdateListsStreamClass(){
    return _instance;
  }

  UpdateListsStreamClass._internal() {
    _updateListsStreamController = StreamController<ListsStreamControllerClass>.broadcast();
  }

  Stream<ListsStreamControllerClass> get updateListsStream => _updateListsStreamController.stream;


  void removeListener(){
    _updateListsStreamController.stream.drain();
  }

  void emitData(ListsStreamControllerClass data){
    if(!_updateListsStreamController.isClosed){
      _updateListsStreamController.add(data);
    }
  }

  void dispose(){
    _updateListsStreamController.close();
  }
}