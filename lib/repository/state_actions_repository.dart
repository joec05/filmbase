import 'package:filmbase/global_files.dart';
import 'package:flutter/material.dart';

void updateMovieBasicData(Map movieDataMap){
  int id = movieDataMap['id'];
  if(appStateRepo.globalMovies[id] != null){
    MovieDataClass movieDataClass = appStateRepo.globalMovies[id]!.notifier.value;
    appStateRepo.globalMovies[id]!.notifier.value = movieDataClass.fromMapBasic(movieDataMap);
  }else{
    appStateRepo.globalMovies[id] = MovieDataNotifier(
      id,
      ValueNotifier(
        MovieDataClass.generateNewInstance(id).fromMapBasic(movieDataMap)
      )
    );
  }
}

void updateMovieData(Map movieDataMap){
  int id = movieDataMap['id'];
  if(appStateRepo.globalMovies[id] != null){
    MovieDataClass movieDataClass = appStateRepo.globalMovies[id]!.notifier.value;
    appStateRepo.globalMovies[id]!.notifier.value = movieDataClass.fromMap(movieDataMap);
  }else{
    appStateRepo.globalMovies[id] = MovieDataNotifier(
      id,
      ValueNotifier(
        MovieDataClass.generateNewInstance(id).fromMap(movieDataMap)
      )
    );
  }
}

void updateTvSeriesBasicData(Map movieDataMap){
  int id = movieDataMap['id'];
  if(appStateRepo.globalTvSeries[id] != null){
    TvSeriesDataClass tvSeriesDataClass = appStateRepo.globalTvSeries[id]!.notifier.value;
    appStateRepo.globalTvSeries[id]!.notifier.value = tvSeriesDataClass.fromMapBasic(movieDataMap);
  }else{
    appStateRepo.globalTvSeries[id] = TvSeriesDataNotifier(
      id,
      ValueNotifier(
        TvSeriesDataClass.generateNewInstance(id).fromMapBasic(movieDataMap)
      )
    );
  }
}

void updateTvSeriesData(Map tvSeriesDataMap){
  int id = tvSeriesDataMap['id'];
  if(appStateRepo.globalTvSeries[id] != null){
    TvSeriesDataClass tvSeriesDataClass = appStateRepo.globalTvSeries[id]!.notifier.value;
    appStateRepo.globalTvSeries[id]!.notifier.value = tvSeriesDataClass.fromMap(tvSeriesDataMap);
  }else{
    appStateRepo.globalTvSeries[id] = TvSeriesDataNotifier(
      id,
      ValueNotifier(
        TvSeriesDataClass.generateNewInstance(id).fromMap(tvSeriesDataMap)
      )
    );
  }
}

void updatePeopleData(Map peopleDataMap){
  int id = peopleDataMap['id'];
  if(appStateRepo.globalPeople[id] != null){
    PeopleDataClass peopleDataClass = appStateRepo.globalPeople[id]!.notifier.value;
    appStateRepo.globalPeople[id]!.notifier.value = peopleDataClass.fromMap(peopleDataMap);
  }else{
    appStateRepo.globalPeople[id] = PeopleDataNotifier(
      id,
      ValueNotifier(
        PeopleDataClass.generateNewInstance(id).fromMap(peopleDataMap)
      )
    );
  }
}

void updatePeopleBasicData(Map peopleDataMap){
  int id = peopleDataMap['id'];
  if(appStateRepo.globalPeople[id] != null){
    PeopleDataClass peopleDataClass = appStateRepo.globalPeople[id]!.notifier.value;
    appStateRepo.globalPeople[id]!.notifier.value = peopleDataClass.fromMapBasic(peopleDataMap);
  }else{
    appStateRepo.globalPeople[id] = PeopleDataNotifier(
      id,
      ValueNotifier(
        PeopleDataClass.generateNewInstance(id).fromMapBasic(peopleDataMap)
      )
    );
  }
}

void updateEpisodeBasicData(Map episodeDataMap){
  int id = episodeDataMap['id'];
  if(appStateRepo.globalEpisodes[id] != null){
    EpisodeDataClass episodeDataClass = appStateRepo.globalEpisodes[id]!.notifier.value;
    appStateRepo.globalEpisodes[id]!.notifier.value = episodeDataClass.fromMapBasic(episodeDataMap);
  }else{
    appStateRepo.globalEpisodes[id] = EpisodeDataNotifier(
      id,
      ValueNotifier(
        EpisodeDataClass.generateNewInstance(id).fromMapBasic(episodeDataMap)
      )
    );
  }
}

void updateEpisodeData(Map episodeDataMap){
  int id = episodeDataMap['id'];
  if(appStateRepo.globalEpisodes[id] != null){
    EpisodeDataClass episodeDataClass = appStateRepo.globalEpisodes[id]!.notifier.value;
    appStateRepo.globalEpisodes[id]!.notifier.value = episodeDataClass.fromMap(episodeDataMap);
  }else{
    appStateRepo.globalEpisodes[id] = EpisodeDataNotifier(
      id,
      ValueNotifier(
        EpisodeDataClass.generateNewInstance(id).fromMap(episodeDataMap)
      )
    );
  }
}

void updateListData(Map listDataMap){
  int id = listDataMap['id'];
  if(appStateRepo.globalLists[id] != null){
    ListDataClass listDataClass = appStateRepo.globalLists[id]!.notifier.value;
    appStateRepo.globalLists[id]!.notifier.value = listDataClass.fromMap(listDataMap);
  }else{
    appStateRepo.globalLists[id] = ListDataNotifier(
      id,
      ValueNotifier(
        ListDataClass.generateNewInstance(id).fromMap(listDataMap)
      )
    );
  }
}

void updateListCreateData(Map listDataMap){
  int id = listDataMap['id'];
  appStateRepo.globalLists[id] = ListDataNotifier(
    id,
    ValueNotifier(
      ListDataClass.generateNewInstance(id).fromMapCreate(listDataMap)
    )
  );
}