import 'package:flutter/material.dart';
import 'package:filmbase/class/movie_data_class.dart';

class MovieDataNotifier{
  final int id;
  final ValueNotifier<MovieDataClass> notifier;
  
  MovieDataNotifier(
    this.id,
    this.notifier
  );
}