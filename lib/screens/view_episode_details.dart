import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

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
  late EpisodeDetailsController controller;

  @override
  void initState(){
    super.initState();
    controller = EpisodeDetailsController(
      context,
      widget.episodeID,
      widget.showID,
      widget.seasonNum,
      widget.episodeNum
    );
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
        if(!isLoading && appStateRepo.globalEpisodes[widget.episodeID] != null){
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: defaultAppBarDecoration
              ),
              title: setAppBarTitle('Episode Details'),
            ),
            body: ValueListenableBuilder(
              valueListenable: appStateRepo.globalEpisodes[widget.episodeID]!.notifier,
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
    );
  }
}