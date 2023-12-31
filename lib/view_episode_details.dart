import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_functions.dart';
import 'package:filmbase/appdata/global_variables.dart';
import 'package:filmbase/appdata/state_actions.dart';
import 'package:filmbase/class/episode_data_class.dart';
import 'package:filmbase/custom/custom_episode_details.dart';
import 'package:filmbase/state/main.dart';
import 'package:filmbase/styles/app_styles.dart';

class ViewEpisodeDetails extends StatelessWidget {
  final int episodeID;
  final int showID;
  final int seasonNum;
  final int episodeNum;

  const ViewEpisodeDetails({
    super.key,
    required this.episodeID,
    required this.showID,
    required this.seasonNum,
    required this.episodeNum,
  });

  @override
  Widget build(BuildContext context) {
    return _ViewEpisodeDetailsStateful(
      episodeID: episodeID,
      showID: showID,
      seasonNum: seasonNum,
      episodeNum: episodeNum
    );
  }
}

class _ViewEpisodeDetailsStateful extends StatefulWidget {
  final int episodeID;
  final int showID;
  final int seasonNum;
  final int episodeNum;

  const _ViewEpisodeDetailsStateful({
    required this.episodeID,
    required this.showID,
    required this.seasonNum,
    required this.episodeNum
  });

  @override
  State<_ViewEpisodeDetailsStateful> createState() => _ViewEpisodeDetailsStatefulState();
}

class _ViewEpisodeDetailsStatefulState extends State<_ViewEpisodeDetailsStateful>{
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchEpisodeDetails();
  }

  @override
  void dispose(){
    super.dispose();
  }

  void fetchEpisodeDetails() async{
    var res = await dio.get(
      '$mainAPIUrl/tv/${widget.showID}/season/${widget.seasonNum}/episode/${widget.episodeNum}',
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      var data = res.data;
      var episodeStatusRes = await dio.get(
        '$mainAPIUrl/tv/${widget.showID}/season/${widget.seasonNum}/episode/${widget.episodeNum}/account_states',
        options: defaultAPIOption
      );
      if(episodeStatusRes.statusCode == 200){
        data['rating'] = episodeStatusRes.data['rated'] != false ? episodeStatusRes.data['rated']['value'] : 0.0;
        var creditsRes = await dio.get(
          '$mainAPIUrl/tv/${widget.showID}/season/${widget.seasonNum}/episode/${widget.episodeNum}/credits',
          options: defaultAPIOption
        );
        if(creditsRes.statusCode == 200){
          data['casts'] = creditsRes.data['cast'];
          data['crews'] = creditsRes.data['crew'];
          data['guest_stars'] = creditsRes.data['guest_stars'];
          var imagesRes = await dio.get(
            '$mainAPIUrl/tv/${widget.showID}/season/${widget.seasonNum}/episode/${widget.episodeNum}/images',
            options: defaultAPIOption
          );
          if(imagesRes.statusCode == 200){
            data['images'] = imagesRes.data['stills'];
            data['show_id'] = widget.showID;
            if(mounted){
              setState((){
                updateEpisodeData(data);
                isLoading = false;
              });
            }
          }else{
            if(mounted){
              displayAlertDialog(
                context,
                'Error ${imagesRes.statusCode}. ${imagesRes.statusMessage}'
              );
            }
          }
        }else{
          if(mounted){
            displayAlertDialog(
              context,
              'Error ${creditsRes.statusCode}. ${creditsRes.statusMessage}'
            );
          }
        }
      }else{
        if(mounted){
          displayAlertDialog(
            context,
            'Error ${episodeStatusRes.statusCode}. ${episodeStatusRes.statusMessage}'
          );
        }
      }
    }else{
      if(mounted){
        displayAlertDialog(
          context,
          'Error ${res.statusCode}. ${res.statusMessage}'
        );
      }
    }
  }

  @override
  Widget build(BuildContext context){
    if(!isLoading && appStateClass.globalEpisodes[widget.episodeID] != null){
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration
          ),
          title: setAppBarTitle('Episode Details'),
        ),
        body: ValueListenableBuilder(
          valueListenable: appStateClass.globalEpisodes[widget.episodeID]!.notifier,
          builder: (context, episodeData, child){
            return CustomEpisodeDetails(
              episodeData: episodeData, 
              skeletonMode: false,
              key: UniqueKey()
            );
          },
        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration
          ),
          title: setAppBarTitle('Episode Details'),
        ),
        body: shimmerSkeletonWidget(
          CustomEpisodeDetails(
            episodeData: EpisodeDataClass.generateNewInstance(-1), 
            skeletonMode: true,
            key: UniqueKey()
          ),
        ),
      );
    }
  }
}