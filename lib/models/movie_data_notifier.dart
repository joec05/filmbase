import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class MovieDataNotifier{
  final int id;
  final ValueNotifier<MovieDataClass> notifier;
  
  MovieDataNotifier(
    this.id,
    this.notifier
  );
}