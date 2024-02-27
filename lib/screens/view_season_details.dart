import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

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
  late SeasonDetailsController controller;

  @override
  void initState(){
    super.initState();
    controller = SeasonDetailsController(context, widget.showID, widget.seasonNum);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context){
    return ListenableBuilder(
      listenable: Listenable.merge([
        controller.isLoading,
        controller.seasonData
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        SeasonDataClass? seasonData = controller.seasonData.value;

        if(!isLoading && seasonData != null){
          return Scaffold(
            appBar: AppBar(
              title: setAppBarTitle('Season Details'),
              flexibleSpace: Container(
                decoration: defaultAppBarDecoration,
              ),
            ),
            body: CustomSeasonDetails(
              seasonData: seasonData, 
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
    );
  }
}