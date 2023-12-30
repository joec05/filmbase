import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_functions.dart';
import 'package:filmbase/appdata/global_variables.dart';
import 'package:filmbase/class/season_data_class.dart';
import 'package:filmbase/custom/custom_season_details.dart';
import 'package:filmbase/styles/app_styles.dart';

class ViewSeasonDetails extends StatelessWidget {
  final int showID;
  final int seasonNum;

  const ViewSeasonDetails({
    super.key,
    required this.showID,
    required this.seasonNum,
  });

  @override
  Widget build(BuildContext context) {
    return _ViewSeasonDetailsStateful(
      showID: showID,
      seasonNum: seasonNum,
    );
  }
}

class _ViewSeasonDetailsStateful extends StatefulWidget {
  final int showID;
  final int seasonNum;

  const _ViewSeasonDetailsStateful({
    required this.showID,
    required this.seasonNum,
  });

  @override
  State<_ViewSeasonDetailsStateful> createState() => _ViewSeasonDetailsStatefulState();
}

class _ViewSeasonDetailsStatefulState extends State<_ViewSeasonDetailsStateful>{
  SeasonDataClass? seasonData;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchSeasonDetails();
  }

  @override
  void dispose(){
    super.dispose();
  }

  void fetchSeasonDetails() async{
    var res = await dio.get(
      '$mainAPIUrl/tv/${widget.showID}/season/${widget.seasonNum}',
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      var data = res.data;
      var userSeasonStatusReq = await dio.get(
        '$mainAPIUrl/tv/${widget.showID}/season/${widget.seasonNum}/account_states',
        options: defaultAPIOption
      );
      if(userSeasonStatusReq.statusCode == 200){
        data['user_episodes_status'] = userSeasonStatusReq.data['results'];
        var creditsReq = await dio.get(
          '$mainAPIUrl/tv/${widget.showID}/season/${widget.seasonNum}/credits',
          options: defaultAPIOption
        );
        if(creditsReq.statusCode == 200){
          data['credits'] = {};
          data['credits']['cast'] = creditsReq.data['cast'];
          data['credits']['crew'] = creditsReq.data['crew'];
          var imagesReq = await dio.get(
            '$mainAPIUrl/tv/${widget.showID}/season/${widget.seasonNum}/images',
            options: defaultAPIOption
          );
          if(imagesReq.statusCode == 200){
            data['images'] = imagesReq.data['posters'];
            data['show_id'] = widget.showID;
            if(mounted){
              setState((){
                seasonData = SeasonDataClass.fromMap(data);
                isLoading = false;
              });
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
            'Error ${userSeasonStatusReq.statusCode}. ${userSeasonStatusReq.statusMessage}'
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
    if(!isLoading && seasonData != null){
      return Scaffold(
        appBar: AppBar(
          title: setAppBarTitle('Season Details'),
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration,
          ),
        ),
        body: CustomSeasonDetails(
          seasonData: seasonData!, 
          skeletonMode: false,
          key: UniqueKey()
        )
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          title: setAppBarTitle('Season Details'),
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration,
          ),
        ),
        body: shimmerSkeletonWidget(
          CustomSeasonDetails(
            seasonData: SeasonDataClass.generateNewInstance(-1), 
            skeletonMode: true,
            key: UniqueKey()
          ),
        )
      );
    }
  }
}