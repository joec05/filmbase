import 'dart:math';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class PeopleController {
  final BuildContext context;
  ValueNotifier<List<int>> popular = ValueNotifier([]);
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  PeopleController(
    this.context
  );

  bool get mounted => context.mounted;
  
  void initializeController() {
    fetchPeople(1);
  }

  void dispose(){
    popular.dispose();
    totalResults.dispose();
    paginationStatus.dispose();
    isLoading.dispose();
  }

  void fetchPeople(int page) async{
    List<int> fetchPopular = await runFetchBasicMovieAPI(
      '$mainAPIUrl/person/popular?page=$page'
    );

    if(mounted){
      popular.value = [...popular.value, ...fetchPopular];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchPeople(
          popular.value.length ~/ 20 + 1
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
        var detailsReq = await dio.get(
          '$mainAPIUrl/person/${data[i]['id']}',
          options: defaultAPIOption
        );
        if(detailsReq.statusCode == 200){
          ids.add(data[i]['id']);
          updatePeopleBasicData(detailsReq.data);
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
    return ids;
  }
}