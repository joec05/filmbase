import 'dart:async';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class FavouriteTvShowsController {
  final BuildContext context;
  ValueNotifier<List<int>> favourites = ValueNotifier([]);
  late StreamSubscription updateFavouriteStreamClassSubscrition;
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  FavouriteTvShowsController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController(){
    fetchFavouriteTvShows(1);
    updateFavouriteStreamClassSubscrition = UpdateFavouriteStreamClass().updateFavouriteStream.listen((FavouriteStreamControllerClass data){
      if(mounted){
        if(data.dataType == UpdateStreamDataType.tvShow){
          if(data.actionType == UpdateStreamActionType.add){
            favourites.value.insert(0, data.id);
            favourites.value = [...favourites.value.toSet().toList()];
          }else if(data.actionType == UpdateStreamActionType.delete){
            favourites.value.remove(data.id);
            favourites.value = [...favourites.value];
          }
        }
      }
    });
  }

  void dispose(){
    updateFavouriteStreamClassSubscrition.cancel();
    favourites.dispose();
    totalResults.dispose();
    paginationStatus.dispose();
    isLoading.dispose();
  }
  
  void fetchFavouriteTvShows(int page) async{
    List<int> getFavouriteTvShows = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/favorite/tv?page=$page&sort_by=created_at.desc'
    );

    if(mounted){
      favourites.value = [...favourites.value, ...getFavouriteTvShows];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  Future<List<int>> runFetchBasicTvSeriesAPI(String url) async{
    List<int> ids = [];
    var res = await dio.get(
      url,
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      totalResults.value = res.data['total_results'];
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

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchFavouriteTvShows(
          favourites.value.length ~/ 20 + 1
        );
      });
    }
  }
}