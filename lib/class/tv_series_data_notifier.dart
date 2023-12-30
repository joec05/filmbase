import 'package:flutter/material.dart';
import 'package:filmbase/class/tv_series_data_class.dart';

class TvSeriesDataNotifier{
  final int id;
  final ValueNotifier<TvSeriesDataClass> notifier;
  
  TvSeriesDataNotifier(
    this.id,
    this.notifier
  );
}