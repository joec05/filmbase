import 'dart:math';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class SearchedCollectionsController {
  final BuildContext context;
  final String searchedText;
  ValueNotifier<List<CollectionDataClass>> collections = ValueNotifier([]);
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  SearchedCollectionsController(
    this.context,
    this.searchedText
  );

  bool get mounted => context.mounted;
  
  void initializeController() {
    if(searchedText.isNotEmpty){
      isLoading.value = true;
      fetchSearchedCollections(1);
    }
  }

  void dispose() {
  }

  void fetchSearchedCollections(int page) async{
    List<CollectionDataClass> getSearchedCollections = await runFetchCollectionAPI(
      '$mainAPIUrl/search/collection?query=$searchedText&page=$page'
    );

    if(mounted){
      collections.value = [...collections.value, ...getSearchedCollections];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchSearchedCollections(
          collections.value.length ~/ 20 + 1
        );
      });
    }
  }

  Future<List<CollectionDataClass>> runFetchCollectionAPI(String url) async{
    List<CollectionDataClass> collections = [];
    var res = await dio.get(
      url,
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      totalResults.value = min(maxSearchedResultsCount, res.data['total_results']);
      var data = res.data['results'];
      for(int i = 0; i < data.length; i++){
        collections.add(CollectionDataClass.fromMapBasic(data[i]));
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
    return collections;
  }
}