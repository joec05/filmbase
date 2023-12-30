import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_functions.dart';
import 'package:filmbase/appdata/global_variables.dart';
import 'package:filmbase/appdata/state_actions.dart';
import 'package:filmbase/class/movie_data_class.dart';
import 'package:filmbase/custom/custom_movie_details.dart';
import 'package:filmbase/state/main.dart';
import 'package:filmbase/styles/app_styles.dart';

class ViewMovieDetails extends StatelessWidget {
  final int movieID;

  const ViewMovieDetails({
    super.key,
    required this.movieID
  });

  @override
  Widget build(BuildContext context) {
    return _ViewMovieDetailsStateful(
      movieID: movieID
    );
  }
}

class _ViewMovieDetailsStateful extends StatefulWidget {
  final int movieID;
  
 const _ViewMovieDetailsStateful({
    required this.movieID
  });

  @override
  State<_ViewMovieDetailsStateful> createState() => _ViewMovieDetailsStatefulState();
}

class _ViewMovieDetailsStatefulState extends State<_ViewMovieDetailsStateful>{
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchMovieComplete(widget.movieID);
  }

  @override
  void dispose(){
    super.dispose();
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
                        setState((){
                          updateMovieData(detailsData);
                          isLoading = false;
                        });
                      }
                    }else{
                      if(mounted){
                        displayAlertDialog(
                          context,
                          'Error ${similarReq.statusCode}. ${similarReq.statusMessage}'
                        );
                      }
                    }
                  }else{
                    if(mounted){
                      displayAlertDialog(
                        context,
                        'Error ${reviewsReq.statusCode}. ${reviewsReq.statusMessage}'
                      );  
                    }
                  }
                }else{
                  if(mounted){
                    displayAlertDialog(
                      context,
                      'Error ${recomsReq.statusCode}. ${recomsReq.statusMessage}'
                    );
                  }
                }
              }else{
                if(mounted){
                  displayAlertDialog(
                    context,
                    'Error ${listsReq.statusCode}. ${listsReq.statusMessage}'
                  );
                }
              }
            }else{
              if(mounted){
                displayAlertDialog(
                  context,
                  'Error ${keywordsReq.statusCode}. ${keywordsReq.statusMessage}'
                );
              }
            }  
          }else{
            if(mounted){
              displayAlertDialog(
                context,
                'Error ${imagesReq.statusCode}. ${imagesReq.statusMessage}'
              );
            }
          }
        }else{
          if(mounted){
            displayAlertDialog(
              context,
              'Error ${creditsReq.statusCode}. ${creditsReq.statusMessage}'
            );
          }
        }
      }else{
        if(mounted){
          displayAlertDialog(
            context,
            'Error ${userMovieStatusReq.statusCode}. ${userMovieStatusReq.statusMessage}'
          );
        }
      }
    }else{
      if(mounted){
        displayAlertDialog(
          context,
          'Error ${detailsReq.statusCode}. ${detailsReq.statusMessage}'
        ); 
      }
    }
  }

  @override
  Widget build(BuildContext context){
    if(!isLoading && appStateClass.globalMovies[widget.movieID] != null){
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration
          ),
          title: setAppBarTitle('Movie Details'),
        ),
        body: ValueListenableBuilder(
          valueListenable: appStateClass.globalMovies[widget.movieID]!.notifier, 
          builder: (context, movieData, child){
            return CustomMovieDetails(
              movieData: movieData,
              key: UniqueKey(),
              skeletonMode: false
            );
          }
        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration
          ),
          title: setAppBarTitle('Movie Details'),
        ),
        body: shimmerSkeletonWidget(
          CustomMovieDetails(
            movieData: MovieDataClass.generateNewInstance(-1),
            key: UniqueKey(),
            skeletonMode: true
          ),
        ),
      );
    }
  }
}