import 'package:filmbase/class/api_identifiers_class.dart';
import 'package:filmbase/class/episode_data_notifier.dart';
import 'package:filmbase/class/list_data_notifier.dart';
import 'package:filmbase/class/movie_data_notifier.dart';
import 'package:filmbase/class/people_data_notifier.dart';
import 'package:filmbase/class/tv_series_data_notifier.dart';
import 'package:filmbase/class/user_account_details_class.dart';
import 'package:filmbase/storage/main.dart';

class AppStateClass{
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

  AppStateClass(
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

final appStateClass = AppStateClass(
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