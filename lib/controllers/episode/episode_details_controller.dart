import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class EpisodeDetailsController {
  final BuildContext context;
  final int episodeID;
  final int showID;
  final int seasonNum;
  final int episodeNum;
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  EpisodeDetailsController(
    this.context,
    this.episodeID,
    this.showID,
    this.seasonNum,
    this.episodeNum
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchEpisodeDetails();
  }

  void dispose(){
    isLoading.dispose();
  }

  void fetchEpisodeDetails() async{
    var res = await dio.get(
      '$mainAPIUrl/tv/$showID/season/$seasonNum/episode/$episodeNum',
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      var data = res.data;
      var episodeStatusRes = await dio.get(
        '$mainAPIUrl/tv/$showID/season/$seasonNum/episode/$episodeNum/account_states',
        options: defaultAPIOption
      );
      if(episodeStatusRes.statusCode == 200){
        data['rating'] = episodeStatusRes.data['rated'] != false ? episodeStatusRes.data['rated']['value'] : 0.0;
        var creditsRes = await dio.get(
          '$mainAPIUrl/tv/$showID/season/$seasonNum/episode/$episodeNum/credits',
          options: defaultAPIOption
        );
        if(creditsRes.statusCode == 200){
          data['casts'] = creditsRes.data['cast'];
          data['crews'] = creditsRes.data['crew'];
          data['guest_stars'] = creditsRes.data['guest_stars'];
          var imagesRes = await dio.get(
            '$mainAPIUrl/tv/$showID/season/$seasonNum/episode/$episodeNum/images',
            options: defaultAPIOption
          );
          if(imagesRes.statusCode == 200){
            data['images'] = imagesRes.data['stills'];
            data['show_id'] = showID;
            if(mounted){
              updateEpisodeData(data);
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