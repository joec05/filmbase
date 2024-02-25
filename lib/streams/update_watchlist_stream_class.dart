import 'dart:async';
import 'package:filmbase/global_files.dart';

class WatchlistStreamControllerClass{
  final UpdateStreamActionType actionType;
  final UpdateStreamDataType dataType;
  final int id;

  WatchlistStreamControllerClass(
    this.id,
    this.dataType,
    this.actionType
  );
}

class UpdateWatchlistStreamClass {
  static final UpdateWatchlistStreamClass _instance = UpdateWatchlistStreamClass._internal();
  late StreamController<WatchlistStreamControllerClass> _updateWatchlistStreamController;

  factory UpdateWatchlistStreamClass(){
    return _instance;
  }

  UpdateWatchlistStreamClass._internal() {
    _updateWatchlistStreamController = StreamController<WatchlistStreamControllerClass>.broadcast();
  }

  Stream<WatchlistStreamControllerClass> get updateWatchlistStream => _updateWatchlistStreamController.stream;


  void removeListener(){
    _updateWatchlistStreamController.stream.drain();
  }

  void emitData(WatchlistStreamControllerClass data){
    if(!_updateWatchlistStreamController.isClosed){
      _updateWatchlistStreamController.add(data);
    }
  }

  void dispose(){
    _updateWatchlistStreamController.close();
  }
}