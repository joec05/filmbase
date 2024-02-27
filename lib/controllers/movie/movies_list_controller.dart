import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class MoviesListController {
  final BuildContext context;
  final String urlParam;
  ValueNotifier<List<int>> movies = ValueNotifier([]);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  MoviesListController(
    this.context,
    this.urlParam
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchMovies(1);
  }

  void dispose() {
  }

  void fetchMovies(int page) async{
    List<int> getRatedMovies = await runFetchBasicMovieAPI(
      '$urlParam&page=$page'
    );
    
    if(mounted){
      movies.value = [...movies.value, ...getRatedMovies];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchMovies(
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
      totalResults.value = min(maxViewResultsCount, res.data['total_results']);
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