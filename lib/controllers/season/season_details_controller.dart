import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class SeasonDetailsController {
  final BuildContext context;
  final int showID;
  final int seasonNum;
  ValueNotifier<SeasonDataClass?> seasonData = ValueNotifier(null);
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  SeasonDetailsController(
    this.context,
    this.showID,
    this.seasonNum
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchSeasonDetails();
  }

  void dispose(){
    seasonData.dispose();
    isLoading.dispose();
  }

  void fetchSeasonDetails() async{
    var res = await dio.get(
      '$mainAPIUrl/tv/$showID/season/$seasonNum',
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      var data = res.data;
      var userSeasonStatusReq = await dio.get(
        '$mainAPIUrl/tv/$showID/season/$seasonNum/account_states',
        options: defaultAPIOption
      );
      if(userSeasonStatusReq.statusCode == 200){
        data['user_episodes_status'] = userSeasonStatusReq.data['results'];
        var creditsReq = await dio.get(
          '$mainAPIUrl/tv/$showID/season/$seasonNum/credits',
          options: defaultAPIOption
        );
        if(creditsReq.statusCode == 200){
          data['credits'] = {};
          data['credits']['cast'] = creditsReq.data['cast'];
          data['credits']['crew'] = creditsReq.data['crew'];
          var imagesReq = await dio.get(
            '$mainAPIUrl/tv/$showID/season/$seasonNum/images',
            options: defaultAPIOption
          );
          if(imagesReq.statusCode == 200){
            data['images'] = imagesReq.data['posters'];
            data['show_id'] = showID;
            if(mounted){
              seasonData.value = SeasonDataClass.fromMap(data);
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