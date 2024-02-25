import 'dart:math';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class SearchedMoviesController {
  final BuildContext context;
  final String searchedText;
  ValueNotifier<List<int>> movies = ValueNotifier([]);
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  SearchedMoviesController(
    this.context,
    this.searchedText
  );

  bool get mounted => context.mounted;

  void initializeController(){
    if(searchedText.isNotEmpty){
      isLoading.value = true;
      fetchSearchedMovies(1);
    }
  }

  void dispose(){
    movies.dispose();
    totalResults.dispose();
    paginationStatus.dispose();
    isLoading.dispose();
  }

  void fetchSearchedMovies(int page) async{
    List<int> getSearchedMovies = await runFetchBasicMovieAPI(
      '$mainAPIUrl/search/movie?query=${searchedText}&page=$page'
    );

    if(mounted){
      movies.value = [...movies.value, ...getSearchedMovies];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchSearchedMovies(
          movies.value.length ~/ 20 + 1
        );
      });
    }
  }

  Future<List<int>> runFetchBasicMovieAPI(String url) async{
    List<int> ids = [];
    var res = await dio.get(
      url,
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      totalResults.value = min(maxSearchedResultsCount, res.data['total_results']);
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