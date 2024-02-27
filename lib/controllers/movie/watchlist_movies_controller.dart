import 'dart:async';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class WatchlistMoviesController {
  final BuildContext context;
  ValueNotifier<List<int>> watchlists = ValueNotifier([]);
  late StreamSubscription updateWatchlistStreamClassSubscrition;
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  WatchlistMoviesController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController(){
    fetchWatchlistMovies(1);
    updateWatchlistStreamClassSubscrition = UpdateWatchlistStreamClass().updateWatchlistStream.listen((WatchlistStreamControllerClass data){
      if(mounted){
        if(data.dataType == UpdateStreamDataType.movie){
          if(data.actionType == UpdateStreamActionType.add){
            watchlists.value.insert(0, data.id);
            watchlists.value = [...watchlists.value.toSet().toList()];
          }else if(data.actionType == UpdateStreamActionType.delete){
            watchlists.value.remove(data.id);
            watchlists.value = [...watchlists.value];
          }
        }
      }
    });
  }

  void dispose(){
    updateWatchlistStreamClassSubscrition.cancel();
    watchlists.dispose();
    totalResults.dispose();
    paginationStatus.dispose();
    isLoading.dispose();
  }

  void fetchWatchlistMovies(int page) async{
    List<int> getWatchlistMovies = await runFetchBasicMovieAPI(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/watchlist/movies?page=$page&sort_by=created_at.desc'
    );

    if(mounted){
      watchlists.value = [...watchlists.value, ...getWatchlistMovies];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchWatchlistMovies(
          watchlists.value.length ~/ 20 + 1
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
      totalResults = res.data['total_results'];
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