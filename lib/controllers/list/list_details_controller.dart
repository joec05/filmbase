import 'dart:async';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ListDetailsController {
  final BuildContext context;
  final int listID;
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  ListDetailsController(
    this.context,
    this.listID
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchListDetails(1);
  }

  void dispose(){
    totalResults.dispose();
    paginationStatus.dispose();
    isLoading.dispose();
  }

  void fetchListDetails(int page) async{
    var res = await dio.get(
      '$mainAPIUrl/list/$listID?page=$page',
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      var data = res.data;
      totalResults = res.data['item_count'];
      var items = res.data['items'];
      List<MediaItemClass> mediaItems = [];
      for(int i = 0; i < items.length; i++){
        items[i]['title'] = items[i]['name'] ?? items[i]['title'];
        items[i]['original_title'] = items[i]['original_name'] ?? items[i]['original_title'];
        if(items[i]['media_type'] == 'movie'){
          updateMovieBasicData(items[i]);
          mediaItems.add(MediaItemClass(
            MediaType.movie, 
            items[i]['id']
          ));
        }else{
          updateTvSeriesBasicData(items[i]);
          mediaItems.add(MediaItemClass(
            MediaType.tvShow, 
            items[i]['id']
          ));
        }
      }
      if(page > 1){
        data['media_items'] = {...appStateRepo.globalLists[listID]!.notifier.value.mediaItems, ...mediaItems}.toSet().toList();
      }else{
        data['media_items'] = mediaItems;
      }
      if(mounted){
        updateListData(data);
        paginationStatus.value = PaginationStatus.loaded;
        isLoading.value = false;
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
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchListDetails(
          appStateRepo.globalLists[listID]!.notifier.value.mediaItems.length ~/ 20 + 1
        );
      });
    }
  }
}