import 'dart:math';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class SearchedTvShowsController {
  final BuildContext context;
  final String searchedText;
  ValueNotifier<List<int>> tvSeries = ValueNotifier([]);
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  SearchedTvShowsController(
    this.context,
    this.searchedText
  );

  bool get mounted => context.mounted;

  void initializeController() {
    if(searchedText.isNotEmpty){
      isLoading.value = true;
      fetchSearchedTvShows(1);
    }
  }

  void dispose(){
    
  }

  void fetchSearchedTvShows(int page) async{
    List<int> getSearchedTvShows = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/search/tv?query=$searchedText&page=$page'
    );

    if(mounted){
      tvSeries.value = [...tvSeries.value, ...getSearchedTvShows];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchSearchedTvShows(
          tvSeries.value.length ~/ 20 + 1
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
      totalResults.value = min(maxSearchedResultsCount, res.data['total_results']);
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