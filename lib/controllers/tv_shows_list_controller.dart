import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class TvShowsListController {
  final BuildContext context;
  final String urlParam;
  ValueNotifier<List<int>> tvShows = ValueNotifier([]);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  TvShowsListController(
    this.context,
    this.urlParam
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchTvShows(1);
  }

  void dispose(){
    tvShows.dispose();
    paginationStatus.dispose();
    totalResults.dispose();
    isLoading.dispose();
  }

  void fetchTvShows(int page) async{
    List<int> getRatedTvShows = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/tv/$urlParam?page=$page'
    );

    if(mounted){
      tvShows.value = [...tvShows.value, ...getRatedTvShows];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchTvShows(
          tvShows.value.length ~/ 20 + 1
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
      totalResults.value = min(maxViewResultsCount, res.data['total_results']);
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