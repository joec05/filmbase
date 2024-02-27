import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class PeopleDetailsController {
  final BuildContext context;
  final int personID;
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  PeopleDetailsController(
    this.context,
    this.personID
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchPeopleDetails();
  }

  void dispose(){
    isLoading.dispose();
  }

  void fetchPeopleDetails() async{
    var res = await dio.get(
      '$mainAPIUrl/person/$personID',
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      var data = res.data;
      var imagesReq = await dio.get(
        '$mainAPIUrl/person/$personID/images',
        options: defaultAPIOption
      );
      if(imagesReq.statusCode == 200){
        data['images'] = imagesReq.data['profiles'];
        var movieCreditsReq = await dio.get(
          '$mainAPIUrl/person/$personID/movie_credits',
          options: defaultAPIOption
        );
        if(movieCreditsReq.statusCode == 200){
          data['credits'] = {};
          data['credits']['movies_credits'] = {};
          data['credits']['movies_credits']['cast'] = movieCreditsReq.data['cast'];
          data['credits']['movies_credits']['crew'] = movieCreditsReq.data['crew'];
          var tvCreditsReq = await dio.get(
            '$mainAPIUrl/person/$personID/tv_credits',
            options: defaultAPIOption
          );
          if(tvCreditsReq.statusCode == 200){
            data['credits']['tv_shows_credits'] = {};
            data['credits']['tv_shows_credits']['cast'] = tvCreditsReq.data['cast'];
            data['credits']['tv_shows_credits']['crew'] = tvCreditsReq.data['crew'];
            if(mounted){
              updatePeopleData(data);
              isLoading.value = false;
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