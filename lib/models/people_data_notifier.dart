import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class PeopleDataNotifier{
  final int id;
  final ValueNotifier<PeopleDataClass> notifier;
  
  PeopleDataNotifier(
    this.id,
    this.notifier
  );
}