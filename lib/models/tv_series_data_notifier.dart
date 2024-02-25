import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class TvSeriesDataNotifier{
  final int id;
  final ValueNotifier<TvSeriesDataClass> notifier;
  
  TvSeriesDataNotifier(
    this.id,
    this.notifier
  );
}