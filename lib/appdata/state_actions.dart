import 'package:flutter/material.dart';
import 'package:filmbase/class/episode_data_class.dart';
import 'package:filmbase/class/episode_data_notifier.dart';
import 'package:filmbase/class/list_data_class.dart';
import 'package:filmbase/class/list_data_notifier.dart';
import 'package:filmbase/class/movie_data_class.dart';
import 'package:filmbase/class/movie_data_notifier.dart';
import 'package:filmbase/class/people_data_class.dart';
import 'package:filmbase/class/people_data_notifier.dart';
import 'package:filmbase/class/tv_series_data_class.dart';
import 'package:filmbase/class/tv_series_data_notifier.dart';
import 'package:filmbase/state/main.dart';

void updateMovieBasicData(Map movieDataMap){
  int id = movieDataMap['id'];
  if(appStateClass.globalMovies[id] != null){
    MovieDataClass movieDataClass = appStateClass.globalMovies[id]!.notifier.value;
    appStateClass.globalMovies[id]!.notifier.value = movieDataClass.fromMapBasic(movieDataMap);
  }else{
    appStateClass.globalMovies[id] = MovieDataNotifier(
      id,
      ValueNotifier(
        MovieDataClass.generateNewInstance(id).fromMapBasic(movieDataMap)
      )
    );
  }
}

void updateMovieData(Map movieDataMap){
  int id = movieDataMap['id'];
  if(appStateClass.globalMovies[id] != null){
    MovieDataClass movieDataClass = appStateClass.globalMovies[id]!.notifier.value;
    appStateClass.globalMovies[id]!.notifier.value = movieDataClass.fromMap(movieDataMap);
  }else{
    appStateClass.globalMovies[id] = MovieDataNotifier(
      id,
      ValueNotifier(
        MovieDataClass.generateNewInstance(id).fromMap(movieDataMap)
      )
    );
  }
}

void updateTvSeriesBasicData(Map movieDataMap){
  int id = movieDataMap['id'];
  if(appStateClass.globalTvSeries[id] != null){
    TvSeriesDataClass tvSeriesDataClass = appStateClass.globalTvSeries[id]!.notifier.value;
    appStateClass.globalTvSeries[id]!.notifier.value = tvSeriesDataClass.fromMapBasic(movieDataMap);
  }else{
    appStateClass.globalTvSeries[id] = TvSeriesDataNotifier(
      id,
      ValueNotifier(
        TvSeriesDataClass.generateNewInstance(id).fromMapBasic(movieDataMap)
      )
    );
  }
}

void updateTvSeriesData(Map tvSeriesDataMap){
  int id = tvSeriesDataMap['id'];
  if(appStateClass.globalTvSeries[id] != null){
    TvSeriesDataClass tvSeriesDataClass = appStateClass.globalTvSeries[id]!.notifier.value;
    appStateClass.globalTvSeries[id]!.notifier.value = tvSeriesDataClass.fromMap(tvSeriesDataMap);
  }else{
    appStateClass.globalTvSeries[id] = TvSeriesDataNotifier(
      id,
      ValueNotifier(
        TvSeriesDataClass.generateNewInstance(id).fromMap(tvSeriesDataMap)
      )
    );
  }
}

void updatePeopleData(Map peopleDataMap){
  int id = peopleDataMap['id'];
  if(appStateClass.globalPeople[id] != null){
    PeopleDataClass peopleDataClass = appStateClass.globalPeople[id]!.notifier.value;
    appStateClass.globalPeople[id]!.notifier.value = peopleDataClass.fromMap(peopleDataMap);
  }else{
    appStateClass.globalPeople[id] = PeopleDataNotifier(
      id,
      ValueNotifier(
        PeopleDataClass.generateNewInstance(id).fromMap(peopleDataMap)
      )
    );
  }
}

void updatePeopleBasicData(Map peopleDataMap){
  int id = peopleDataMap['id'];
  if(appStateClass.globalPeople[id] != null){
    PeopleDataClass peopleDataClass = appStateClass.globalPeople[id]!.notifier.value;
    appStateClass.globalPeople[id]!.notifier.value = peopleDataClass.fromMapBasic(peopleDataMap);
  }else{
    appStateClass.globalPeople[id] = PeopleDataNotifier(
      id,
      ValueNotifier(
        PeopleDataClass.generateNewInstance(id).fromMapBasic(peopleDataMap)
      )
    );
  }
}

void updateEpisodeBasicData(Map episodeDataMap){
  int id = episodeDataMap['id'];
  if(appStateClass.globalEpisodes[id] != null){
    EpisodeDataClass episodeDataClass = appStateClass.globalEpisodes[id]!.notifier.value;
    appStateClass.globalEpisodes[id]!.notifier.value = episodeDataClass.fromMapBasic(episodeDataMap);
  }else{
    appStateClass.globalEpisodes[id] = EpisodeDataNotifier(
      id,
      ValueNotifier(
        EpisodeDataClass.generateNewInstance(id).fromMapBasic(episodeDataMap)
      )
    );
  }
}

void updateEpisodeData(Map episodeDataMap){
  int id = episodeDataMap['id'];
  if(appStateClass.globalEpisodes[id] != null){
    EpisodeDataClass episodeDataClass = appStateClass.globalEpisodes[id]!.notifier.value;
    appStateClass.globalEpisodes[id]!.notifier.value = episodeDataClass.fromMap(episodeDataMap);
  }else{
    appStateClass.globalEpisodes[id] = EpisodeDataNotifier(
      id,
      ValueNotifier(
        EpisodeDataClass.generateNewInstance(id).fromMap(episodeDataMap)
      )
    );
  }
}

void updateListData(Map listDataMap){
  int id = listDataMap['id'];
  if(appStateClass.globalLists[id] != null){
    ListDataClass listDataClass = appStateClass.globalLists[id]!.notifier.value;
    appStateClass.globalLists[id]!.notifier.value = listDataClass.fromMap(listDataMap);
  }else{
    appStateClass.globalLists[id] = ListDataNotifier(
      id,
      ValueNotifier(
        ListDataClass.generateNewInstance(id).fromMap(listDataMap)
      )
    );
  }
}

void updateListCreateData(Map listDataMap){
  int id = listDataMap['id'];
  appStateClass.globalLists[id] = ListDataNotifier(
    id,
    ValueNotifier(
      ListDataClass.generateNewInstance(id).fromMapCreate(listDataMap)
    )
  );
}