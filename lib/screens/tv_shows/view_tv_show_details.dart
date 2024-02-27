import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

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
  late TvShowDetailsController controller;
  
  @override
  void initState(){
    super.initState();
    controller = TvShowDetailsController(context, widget.tvShowID);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: controller.isLoading,
      builder: (context, isLoading, child) {
        if(!isLoading && appStateRepo.globalTvSeries[widget.tvShowID] != null){
          return Scaffold(
            appBar: AppBar(
              title: setAppBarTitle('TV Show Details'),
              flexibleSpace: Container(
                decoration: defaultAppBarDecoration
              ),
            ),
            body: ValueListenableBuilder(
              valueListenable: appStateRepo.globalTvSeries[widget.tvShowID]!.notifier, 
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
    );
  }
}