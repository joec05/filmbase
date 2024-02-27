import 'dart:math';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class SearchedPeopleController {
  final BuildContext context;
  final String searchedText;
  ValueNotifier<List<int>> people = ValueNotifier([]);
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  SearchedPeopleController(
    this.context,
    this.searchedText
  );

  bool get mounted => context.mounted;

  void initializeController() {
    if(searchedText.isNotEmpty){
      isLoading.value = true;
      fetchSearchedPeople(1);
    }
  }

  void dispose(){
    people.dispose();
    totalResults.dispose();
    paginationStatus.dispose();
    isLoading.dispose();
  }

  void fetchSearchedPeople(int page) async{
    List<int> getSearchedPeople = await runFetchBasicPeopleAPI(
      '$mainAPIUrl/search/person?query=$searchedText&page=$page'
    );

    if(mounted){
      people.value = [...people.value, ...getSearchedPeople];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchSearchedPeople(
          people.value.length ~/ 20 + 1
        );
      });
    }
  }

  Future<List<int>> runFetchBasicPeopleAPI(String url) async{
    List<int> ids = [];
    var res = await dio.get(
      url,
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      totalResults.value = min(maxSearchedResultsCount, res.data['total_results']);
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