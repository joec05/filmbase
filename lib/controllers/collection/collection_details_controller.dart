import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class CollectionDetailsController {
  final BuildContext context;
  final int collectionID;
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  ValueNotifier<CollectionDataClass?> collectionData = ValueNotifier(null);

  CollectionDetailsController(
    this.context,
    this.collectionID
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchCollectionDetails();
  }

  void dispose(){
    isLoading.dispose();
    collectionData.dispose();
  }

  void fetchCollectionDetails() async{
    var res = await dio.get(
      '$mainAPIUrl/collection/$collectionID',
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      var data = res.data;
      var items = data['parts'];
      List<int> movies = [];
      List<int> tvShows = [];
      for(int i = 0; i < items.length; i++){
        if(items[i]['media_type'] == 'movie'){
          updateMovieBasicData(items[i]);
          movies.add(items[i]['id']);
        }else if(items[i]['media_type'] == 'tv'){
          updateTvSeriesBasicData(items[i]);
          tvShows.add(items[i]['id']);
        }
      }
      data['movies'] = movies;
      data['tv_shows'] = tvShows;
      var imagesReq = await dio.get(
        '$mainAPIUrl/collection/$collectionID/images',
        options: defaultAPIOption
      );
      if(imagesReq.statusCode == 200){
        data['images'] = [...imagesReq.data['backdrops'], ...imagesReq.data['posters']];
        if(mounted){
          collectionData.value = CollectionDataClass.fromMap(data);
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
}