import 'package:flutter/material.dart';
import 'package:filmbase/class/list_data_class.dart';

class ListDataNotifier{
  int id;
  ValueNotifier<ListDataClass> notifier;

  ListDataNotifier(
    this.id,
    this.notifier
  );
}