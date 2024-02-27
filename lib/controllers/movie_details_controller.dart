import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class MovieDetailsController {
  final BuildContext context;
  final int movieID;
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  MovieDetailsController(
    this.context,
    this.movieID
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchMovieComplete(movieID);
  }

  void dispose(){
    isLoading.dispose();
  }

  void fetchMovieComplete(int id) async{
    var detailsReq = await dio.get(
      '$mainAPIUrl/movie/$id?language=en-US',
      options: defaultAPIOption
    );
    if(detailsReq.statusCode == 200){
      var detailsData = detailsReq.data;
      var userMovieStatusReq = await dio.get(
        '$mainAPIUrl/movie/$id/account_states',
        options: defaultAPIOption
      );
      if(userMovieStatusReq.statusCode == 200){
        detailsData['user_movie_status'] = userMovieStatusReq.data;
        var creditsReq = await dio.get(
          '$mainAPIUrl/movie/$id/credits?language=en-US',
          options: defaultAPIOption
        );
        if(creditsReq.statusCode == 200){
          detailsData['credits'] = creditsReq.data;
          var imagesReq = await dio.get(
            '$mainAPIUrl/movie/$id/images',
            options: defaultAPIOption
          );
          if(imagesReq.statusCode == 200){
            detailsData['images'] = imagesReq.data;
            var keywordsReq = await dio.get(
              '$mainAPIUrl/movie/$id/keywords',
              options: defaultAPIOption
            );
            if(keywordsReq.statusCode == 200){
              detailsData['keywords'] = keywordsReq.data['keywords'];
              var listsReq = await dio.get(
                '$mainAPIUrl/movie/$id/lists?language=en-US&page=1',
                options: defaultAPIOption
              );
              if(listsReq.statusCode == 200){
                detailsData['lists'] = listsReq.data['results'];
                var recomsReq = await dio.get(
                  '$mainAPIUrl/movie/$id/recommendations?language=en-US&page=1',
                  options: defaultAPIOption
                );
                if(recomsReq.statusCode == 200){
                  detailsData['recommendations'] = recomsReq.data['results'];
                  for(int x = 0; x < recomsReq.data['results'].length; x++){
                    updateMovieBasicData(recomsReq.data['results'][x]);
                  }
                  var reviewsReq = await dio.get(
                    '$mainAPIUrl/movie/$id/reviews?language=en-US&page=1',
                    options: defaultAPIOption
                  );
                  if(reviewsReq.statusCode == 200){
                    detailsData['reviews'] = reviewsReq.data['results'];
                    var similarReq = await dio.get(
                      '$mainAPIUrl/movie/$id/similar?language=en-US&page=1',
                      options: defaultAPIOption
                    );
                    if(similarReq.statusCode == 200){
                      detailsData['similar'] = similarReq.data['results'];
                      for(int x = 0; x < similarReq.data['results'].length; x++){
                        updateMovieBasicData(similarReq.data['results'][x]);
                      }
                      if(mounted){
                        updateMovieData(detailsData);
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