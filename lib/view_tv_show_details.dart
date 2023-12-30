import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_functions.dart';
import 'package:filmbase/appdata/global_variables.dart';
import 'package:filmbase/appdata/state_actions.dart';
import 'package:filmbase/class/tv_series_data_class.dart';
import 'package:filmbase/custom/custom_tv_show_details.dart';
import 'package:filmbase/state/main.dart';
import 'package:filmbase/styles/app_styles.dart';

class ViewTvShowDetails extends StatelessWidget {
  final int tvShowID;

  const ViewTvShowDetails({
    super.key,
    required this.tvShowID
  });

  @override
  Widget build(BuildContext context) {
    return _ViewTvShowDetailsStateful(
      tvShowID: tvShowID
    );
  }
}

class _ViewTvShowDetailsStateful extends StatefulWidget {
  final int tvShowID;
  
  const _ViewTvShowDetailsStateful({
    required this.tvShowID
  });

  @override
  State<_ViewTvShowDetailsStateful> createState() => _ViewTvShowDetailsStatefulState();
}

class _ViewTvShowDetailsStatefulState extends State<_ViewTvShowDetailsStateful>{
  bool isLoading = true;
  
  @override
  void initState(){
    super.initState();
    fetchTvSeriesComplete(widget.tvShowID);
  }

  @override
  void dispose(){
    super.dispose();
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
                        setState((){
                          updateTvSeriesData(detailsData);
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
              'Error ${ratingsReq.statusCode}. ${ratingsReq.statusMessage}'
            );
          }
        }
      }else{
        if(mounted){
          displayAlertDialog(
            context,
            'Error ${userTvSeriesStatusReq.statusCode}. ${userTvSeriesStatusReq.statusMessage}'
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
    if(!isLoading && appStateClass.globalTvSeries[widget.tvShowID] != null){
      return Scaffold(
        appBar: AppBar(
          title: setAppBarTitle('TV Show Details'),
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: appStateClass.globalTvSeries[widget.tvShowID]!.notifier, 
          builder: (context, tvShowData, child){
            return CustomTvShowDetails(
              tvShowData: tvShowData,
              key: UniqueKey(),
              skeletonMode: false
            );
          }
        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          title: setAppBarTitle('TV Show Details'),
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration
          ),
        ),
        body: shimmerSkeletonWidget(
          CustomTvShowDetails(
            tvShowData: TvSeriesDataClass.generateNewInstance(-1),
            key: UniqueKey(),
            skeletonMode: true
          ),
        ),
      );
    }
  }
}