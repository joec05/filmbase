import 'package:filmbase/global_files.dart';

class AppStateRepository{
  APIIdentifiersClass apiIdentifiers;
  AppStorageClass appStorage;
  UserAccountDetailsClass? currentUserData;
  Map<int, MovieDataNotifier> globalMovies;
  Map<int, TvSeriesDataNotifier> globalTvSeries;
  Map<int, PeopleDataNotifier> globalPeople;
  Map<int, EpisodeDataNotifier> globalEpisodes;
  Map<int, ListDataNotifier> globalLists;
  Map<int, String> globalMovieGenres;
  Map<int, String> globalTvSeriesGenres;

  AppStateRepository(
    this.apiIdentifiers,
    this.appStorage,
    this.currentUserData,
    this.globalMovies,
    this.globalTvSeries,
    this.globalPeople,
    this.globalEpisodes,
    this.globalLists,
    this.globalMovieGenres,
    this.globalTvSeriesGenres,
  );
}

final appStateRepo = AppStateRepository(
  apiIdentifiersClass,
  appStorageClass,
  null,
  {},
  {},
  {},
  {},
  {},
  {},
  {}
);