import 'dart:async';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class RatedMoviesController {
  final BuildContext context;
  ValueNotifier<List<int>> rated = ValueNotifier([]);
  late StreamSubscription updateRatedStreamClassSubscription;
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  RatedMoviesController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchRatedMovies(1);
    updateRatedStreamClassSubscription = UpdateRatedStreamClass().updateRatedStream.listen((RatedStreamControllerClass data) {
      if(mounted){
        if(data.dataType == UpdateStreamDataType.movie){
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

  void fetchRatedMovies(int page) async{
    List<int> getRatedMovies = await runFetchBasicMovieAPI(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/rated/movies?page=$page&sort_by=created_at.desc'
    );

    if(mounted){
      rated.value = [...rated.value, ...getRatedMovies];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchRatedMovies(
          rated.value.length ~/ 20 + 1
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
      totalResults.value = res.data['total_results'];
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