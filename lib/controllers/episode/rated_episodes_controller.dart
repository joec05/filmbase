import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class RatedEpisodesController {
  final BuildContext context;
  ValueNotifier<List<int>> rated = ValueNotifier([]);
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  RatedEpisodesController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchRatedEpisodes(1);
  }

  void dispose(){
    rated.dispose();
    totalResults.dispose();
    paginationStatus.dispose();
    isLoading.dispose();
  }

  void fetchRatedEpisodes(int page) async{
    List<int> getRatedEpisodes = await runFetchAPI(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/rated/tv/episodes?page=$page'
    );

    if(mounted){
      rated.value = [...rated.value, ...getRatedEpisodes];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchRatedEpisodes(
          rated.value.length ~/ 20 + 1
        );
      });
    }
  }

  Future<List<int>> runFetchAPI(String url) async{
    List<int> episodes = [];
    List<int> showsID = [];
    var res = await dio.get(
      url,
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      totalResults = res.data['total_results'];
      var data = res.data['results'];
      for(int i = 0; i < data.length; i++){
        if(!showsID.contains(data[i]['show_id'])){
          var getShowRes = await dio.get(
            '$mainAPIUrl/tv/${data[i]['show_id']}',
            options: defaultAPIOption
          );
          if(getShowRes.statusCode == 200){
            updateTvSeriesBasicData(getShowRes.data);
            updateEpisodeBasicData(data[i]);
            episodes.add(data[i]['id']);
          }
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
    return episodes;
  } 
}