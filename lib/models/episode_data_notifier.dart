import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class EpisodeDataNotifier{
  int episodeID;
  ValueNotifier<EpisodeDataClass> notifier;
  
  EpisodeDataNotifier(
    this.episodeID,
    this.notifier
  );
}