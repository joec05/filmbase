import 'dart:async';
import 'package:filmbase/global_files.dart';

class RatedStreamControllerClass{
  final UpdateStreamDataType dataType;
  final int id;

  RatedStreamControllerClass(
    this.id,
    this.dataType,
  );
}

class UpdateRatedStreamClass {
  static final UpdateRatedStreamClass _instance = UpdateRatedStreamClass._internal();
  late StreamController<RatedStreamControllerClass> _updateRatedStreamController;

  factory UpdateRatedStreamClass(){
    return _instance;
  }

  UpdateRatedStreamClass._internal() {
    _updateRatedStreamController = StreamController<RatedStreamControllerClass>.broadcast();
  }

  Stream<RatedStreamControllerClass> get updateRatedStream => _updateRatedStreamController.stream;


  void removeListener(){
    _updateRatedStreamController.stream.drain();
  }

  void emitData(RatedStreamControllerClass data){
    if(!_updateRatedStreamController.isClosed){
      _updateRatedStreamController.add(data);
    }
  }

  void dispose(){
    _updateRatedStreamController.close();
  }
}