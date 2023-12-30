import 'package:flutter/material.dart';
import 'package:filmbase/class/episode_data_class.dart';

class EpisodeDataNotifier{
  int episodeID;
  ValueNotifier<EpisodeDataClass> notifier;
  
  EpisodeDataNotifier(
    this.episodeID,
    this.notifier
  );
}