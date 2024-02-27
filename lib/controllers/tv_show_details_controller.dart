import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class TvShowDetailsController {
  final BuildContext context;
  final int tvShowID;
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  TvShowDetailsController(
    this.context,
    this.tvShowID
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchTvSeriesComplete(tvShowID);
  }

  void dispose(){
    isLoading.dispose();
  }

  void fetchTvSeriesComplete(int id) async{
    var detailsReq = await dio.get(
      '$mainAPIUrl/tv/$id?language=en-US',
      options: defaultAPIOption
    );
    if(detailsReq.statusCode == 200){
      var detailsData = detailsReq.data;
      var userTvSeriesStatusReq = await dio.get(
        '$mainAPIUrl/tv/$id/account_states',
        options: defaultAPIOption
      );
      if(userTvSeriesStatusReq.statusCode == 200){
        detailsData['user_movie_status'] = userTvSeriesStatusReq.data;
        var ratingsReq = await dio.get(
          '$mainAPIUrl/tv/$id/content_ratings?language=en-US',
          options: defaultAPIOption
        );
        if(ratingsReq.statusCode == 200){
          detailsData['ratings'] = ratingsReq.data['results'];
          var creditsReq = await dio.get(
            '$mainAPIUrl/tv/$id/credits?language=en-US',
            options: defaultAPIOption
          );
          if(creditsReq.statusCode == 200){
            detailsData['credits'] = creditsReq.data;
            var imagesReq = await dio.get(
              '$mainAPIUrl/tv/$id/images',
              options: defaultAPIOption
            );
            if(imagesReq.statusCode == 200){
              detailsData['images'] = imagesReq.data;
              var keywordsReq = await dio.get(
                '$mainAPIUrl/tv/$id/keywords',
                options: defaultAPIOption
              );
              if(keywordsReq.statusCode == 200){
                detailsData['keywords'] = keywordsReq.data['results'];
                var recomsReq = await dio.get(
                  '$mainAPIUrl/tv/$id/recommendations?language=en-US&page=1',
                  options: defaultAPIOption
                );
                if(recomsReq.statusCode == 200){
                  detailsData['recommendations'] = recomsReq.data['results'];
                  for(int x = 0; x < recomsReq.data['results'].length; x++){
                    updateTvSeriesBasicData(recomsReq.data['results'][x]);
                  }
                  var reviewsReq = await dio.get(
                  '$mainAPIUrl/tv/$id/reviews?language=en-US&page=1',
                  options: defaultAPIOption
                );
                  if(reviewsReq.statusCode == 200){
                    detailsData['reviews'] = reviewsReq.data['results'];
                    var similarReq = await dio.get(
                      '$mainAPIUrl/tv/$id/similar?language=en-US&page=1',
                      options: defaultAPIOption
                    );
                    if(similarReq.statusCode == 200){
                      detailsData['similar'] = similarReq.data['results'];
                      for(int x = 0; x < similarReq.data['results'].length; x++){
                        updateTvSeriesBasicData(similarReq.data['results'][x]);
                      }
                      if(mounted){
                        updateTvSeriesData(detailsData);
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