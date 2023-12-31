import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_functions.dart';
import 'package:filmbase/appdata/global_variables.dart';
import 'package:filmbase/appdata/state_actions.dart';
import 'package:filmbase/class/people_data_class.dart';
import 'package:filmbase/custom/custom_people_details.dart';
import 'package:filmbase/state/main.dart';
import 'package:filmbase/styles/app_styles.dart';

class ViewPeopleDetails extends StatelessWidget {
  final int personID;

  const ViewPeopleDetails({
    super.key,
    required this.personID
  });

  @override
  Widget build(BuildContext context) {
    return _ViewPeopleDetailsStateful(
      personID: personID
    );
  }
}

class _ViewPeopleDetailsStateful extends StatefulWidget {
  final int personID;
  
  const _ViewPeopleDetailsStateful({
    required this.personID
  });

  @override
  State<_ViewPeopleDetailsStateful> createState() => _ViewPeopleDetailsStatefulState();
}

class _ViewPeopleDetailsStatefulState extends State<_ViewPeopleDetailsStateful>{
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchPeopleDetails();
  }

  @override
  void dispose(){
    super.dispose();
  }

  void fetchPeopleDetails() async{
    var res = await dio.get(
      '$mainAPIUrl/person/${widget.personID}',
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      var data = res.data;
      var imagesReq = await dio.get(
        '$mainAPIUrl/person/${widget.personID}/images',
        options: defaultAPIOption
      );
      if(imagesReq.statusCode == 200){
        data['images'] = imagesReq.data['profiles'];
        var movieCreditsReq = await dio.get(
          '$mainAPIUrl/person/${widget.personID}/movie_credits',
          options: defaultAPIOption
        );
        if(movieCreditsReq.statusCode == 200){
          data['credits'] = {};
          data['credits']['movies_credits'] = {};
          data['credits']['movies_credits']['cast'] = movieCreditsReq.data['cast'];
          data['credits']['movies_credits']['crew'] = movieCreditsReq.data['crew'];
          var tvCreditsReq = await dio.get(
            '$mainAPIUrl/person/${widget.personID}/tv_credits',
            options: defaultAPIOption
          );
          if(tvCreditsReq.statusCode == 200){
            data['credits']['tv_shows_credits'] = {};
            data['credits']['tv_shows_credits']['cast'] = tvCreditsReq.data['cast'];
            data['credits']['tv_shows_credits']['crew'] = tvCreditsReq.data['crew'];
            if(mounted){
              setState((){
                updatePeopleData(data);
                isLoading = false;
              });
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
            'Error ${imagesReq.statusCode}. ${imagesReq.statusMessage}'
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
    if(!isLoading && appStateClass.globalPeople[widget.personID] != null){
      return Scaffold(
        appBar: AppBar(
          title: setAppBarTitle('People'),
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration
          ),
        ),
        body: ValueListenableBuilder(
          valueListenable: appStateClass.globalPeople[widget.personID]!.notifier,
          builder: (context, peopleData, child){
            return CustomPeopleDetails(
              peopleData: peopleData, 
              skeletonMode: false,
              key: UniqueKey()
            );
          },
        )
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          title: setAppBarTitle('People'),
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration
          ),
        ),
        body: shimmerSkeletonWidget(
          CustomPeopleDetails(
            peopleData: PeopleDataClass.generateNewInstance(-1), 
            skeletonMode: true,
            key: UniqueKey()
          ),
        )
      );
    }
  }
}