import 'dart:async';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class RatedTvShowsController {
  final BuildContext context;
  ValueNotifier<List<int>> rated = ValueNotifier([]);
  late StreamSubscription updateRatedStreamClassSubscription;
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  RatedTvShowsController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchRatedTvShows(1);
    updateRatedStreamClassSubscription = UpdateRatedStreamClass().updateRatedStream.listen((RatedStreamControllerClass data) {
      if(mounted){
        if(data.dataType == UpdateStreamDataType.tvShow){
          if(rated.value.contains(data.id)){
            rated.value.remove(data.id);
            rated.value.insert(0, data.id);
            rated.value = [...rated.value];
          }else{
            rated.value.insert(0, data.id);
            rated.value.removeLast();
            rated.value = [...rated.value];
          }
        }
      }
    });
  }

  void dispose(){
    updateRatedStreamClassSubscription.cancel();
    rated.dispose();
    totalResults.dispose();
    paginationStatus.dispose();
    isLoading.dispose();
  }

  void fetchRatedTvShows(int page) async{
    List<int> getRatedTvShows = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/rated/tv?page=$page&sort_by=created_at.desc'
    );

    if(mounted){
      rated.value = [...rated.value, ...getRatedTvShows];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchRatedTvShows(
          rated.value.length ~/ 20 + 1
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