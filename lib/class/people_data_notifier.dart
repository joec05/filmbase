import 'package:flutter/material.dart';
import 'package:filmbase/class/people_data_class.dart';

class PeopleDataNotifier{
  final int id;
  final ValueNotifier<PeopleDataClass> notifier;
  
  PeopleDataNotifier(
    this.id,
    this.notifier
  );
}