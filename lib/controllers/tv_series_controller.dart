import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class TvSeriesController {
  final BuildContext context;
  ValueNotifier<List<int>> airingToday = ValueNotifier([]);
  ValueNotifier<List<int>> popular = ValueNotifier([]);
  ValueNotifier<List<int>> topRated = ValueNotifier([]);
  ValueNotifier<List<int>> onAir = ValueNotifier([]);
  ValueNotifier<List<int>> trending = ValueNotifier([]);
  bool isLoading = true;

  TvSeriesController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchTvSeries();
  }

  void dispose(){
  }

  void fetchTvSeries() async{
    List<int> fetchTrending = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/trending/tv/week?page=1',
    );
    List<int> fetchAiringToday = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/tv/airing_today?page=1'
    );
    List<int> fetchPopular = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/tv/popular?page=1'
    );
    List<int> fetchTopRated = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/tv/top_rated?page=1'
    );
    List<int> fetchOnAir = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/tv/on_the_air?page=1'
    );

    if(mounted){
      trending.value = [...fetchTrending];
      airingToday.value = [...fetchAiringToday];
      popular.value = [...fetchPopular];
      topRated.value = [...fetchTopRated];
      onAir.value = [...fetchOnAir];
      isLoading = false;
    }
  }

  Future<List<int>> runFetchBasicTvSeriesAPI(String url) async{
    List<int> ids = [];
    var res = await dio.get(
      url,
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
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