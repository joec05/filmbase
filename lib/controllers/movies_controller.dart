import 'package:filmbase/global_files.dart';
import 'package:flutter/material.dart';

class MoviesController {
  final BuildContext context;
  ValueNotifier<List<int>> nowPlaying = ValueNotifier([]);
  ValueNotifier<List<int>> popular = ValueNotifier([]);
  ValueNotifier<List<int>> topRated = ValueNotifier([]);
  ValueNotifier<List<int>> upcoming = ValueNotifier([]);
  ValueNotifier<List<int>> trending = ValueNotifier([]);
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  ValueNotifier<List<String>> urlParams = ValueNotifier([]);

  MoviesController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController() {
    urlParams.value = [
      '$mainAPIUrl/trending/movie/week?',
      '$mainAPIUrl/discover/movie?primary_release_date.gte=${getFirstDayOfMonth()}&primary_release_date.lte=${getLastDayOfMonth()}&sort_by=popularity.desc&',
      '$mainAPIUrl/discover/movie?sort_by=popularity.desc&',
      '$mainAPIUrl/movie/top_rated?',
      '$mainAPIUrl/discover/movie?primary_release_date.gte=${getFirstDayOfNextMonth()}&primary_release_date.lte=${getLastDayOfNextMonth()}&sort_by=popularity.desc&',
    ];
    fetchMovies();
  }

  void dispose() {
    nowPlaying.dispose();
    popular.dispose();
    topRated.dispose();
    upcoming.dispose();
    trending.dispose();
    isLoading.dispose();
    urlParams.dispose();
  }
  
  void fetchMovies() async{
    List<int> fetchTrending = await runFetchBasicMovieAPI(
      '${urlParams.value[0]}page=1'
    );
    List<int> fetchNowPlaying = await runFetchBasicMovieAPI(
      '${urlParams.value[1]}page=1'
    );
    List<int> fetchPopular = await runFetchBasicMovieAPI(
      '${urlParams.value[2]}page=1'
    );
    List<int> fetchTopRated = await runFetchBasicMovieAPI(
      '${urlParams.value[3]}page=1'
    );
    List<int> fetchUpcoming = await runFetchBasicMovieAPI(
      '${urlParams.value[4]}page=1'
    );

    if(mounted){
      trending.value = fetchTrending;
      nowPlaying.value = fetchNowPlaying;
      popular.value = fetchPopular;
      topRated.value = fetchTopRated;
      upcoming.value = fetchUpcoming;
      isLoading.value = false;
    }
  }

  Future<List<int>> runFetchBasicMovieAPI(String url) async{
    List<int> ids = [];
    var res = await dio.get(
      url,
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      var data = res.data['results'];
      for(int i = 0; i < data.length; i++){
        ids.add(data[i]['id']);
        updateMovieBasicData(data[i]);
      }
    }else{
      if(mounted){
        handler.displaySnackbar(
          context, 
          SnackbarType.error, 
          tErr.api
        );
      }
    }
    return ids;
  }
}