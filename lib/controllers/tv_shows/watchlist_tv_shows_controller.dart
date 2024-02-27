import 'dart:async';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class WatchlistTvShowsController {
  final BuildContext context;
  ValueNotifier<List<int>> watchlists = ValueNotifier([]);
  late StreamSubscription updateWatchlistStreamClassSubscrition;
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  WatchlistTvShowsController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchWatchlistTvShows(1);
    updateWatchlistStreamClassSubscrition = UpdateWatchlistStreamClass().updateWatchlistStream.listen((WatchlistStreamControllerClass data){
      if(mounted){
        if(data.dataType == UpdateStreamDataType.tvShow){
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

  void fetchWatchlistTvShows(int page) async{
    List<int> getWatchlistTvShows = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/watchlist/tv?page=$page&sort_by=created_at.desc'
    );

    if(mounted){
      watchlists.value = [...watchlists.value, ...getWatchlistTvShows];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchWatchlistTvShows(
          watchlists.value.length ~/ 20 + 1
        );
      });
    }
  }

  Future<List<int>> runFetchBasicTvSeriesAPI(String url) async{
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
        updateTvSeriesBasicData(data[i]);
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