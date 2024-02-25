import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ListDataNotifier{
  int id;
  ValueNotifier<ListDataClass> notifier;

  ListDataNotifier(
    this.id,
    this.notifier
  );
}