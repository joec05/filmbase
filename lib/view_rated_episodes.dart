import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_enums.dart';
import 'package:filmbase/appdata/global_functions.dart';
import 'package:filmbase/appdata/global_variables.dart';
import 'package:filmbase/appdata/state_actions.dart';
import 'package:filmbase/class/episode_data_class.dart';
import 'package:filmbase/custom/custom_episode_display.dart';
import 'package:filmbase/custom/custom_pagination.dart';
import 'package:filmbase/state/main.dart';
import 'package:filmbase/styles/app_styles.dart';

class ViewRatedEpisodes extends StatelessWidget {
  const ViewRatedEpisodes({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ViewRatedEpisodesStateful();
  }
}

class _ViewRatedEpisodesStateful extends StatefulWidget {
  const _ViewRatedEpisodesStateful();

  @override
  State<_ViewRatedEpisodesStateful> createState() => _ViewRatedEpisodesStatefulState();
}

class _ViewRatedEpisodesStatefulState extends State<_ViewRatedEpisodesStateful> with AutomaticKeepAliveClientMixin{
  List<int> rated = [];
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchRatedEpisodes(1);
  }

  @override
  void dispose(){
    super.dispose();
  }

  void fetchRatedEpisodes(int page) async{
    List<int> getRatedEpisodes = await runFetchAPI(
      '$mainAPIUrl/account/${appStateClass.apiIdentifiers.userID}/rated/tv/episodes?page=$page'
    );

    if(mounted){
      setState(() {
        rated.addAll(getRatedEpisodes);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchRatedEpisodes(
          rated.length ~/ 20 + 1
        );
      });
    }
  }

  Future<List<int>> runFetchAPI(String url) async{
    List<int> episodes = [];
    List<int> showsID = [];
    var res = await dio.get(
      url,
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      totalResults = res.data['total_results'];
      var data = res.data['results'];
      for(int i = 0; i < data.length; i++){
        if(!showsID.contains(data[i]['show_id'])){
          var getShowRes = await dio.get(
            '$mainAPIUrl/tv/${data[i]['show_id']}',
            options: defaultAPIOption
          );
          if(getShowRes.statusCode == 200){
            updateTvSeriesBasicData(getShowRes.data);
            updateEpisodeBasicData(data[i]);
            episodes.add(data[i]['id']);
          }
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
    return episodes;
  }

  @override
  Widget build(BuildContext context){
    super.build(context);

    if(!isLoading){
      return LoadMoreBottom(
        addBottomSpace: rated.length < totalResults,
        loadMore: () async{
          if(rated.length < totalResults){
            paginate();
          }
        },
        status: paginationStatus,
        refresh: null,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
            ),
            SliverList(delegate: SliverChildBuilderDelegate(
              childCount: rated.length, 
              (c, i) {
                if(appStateClass.globalEpisodes[rated[i]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: appStateClass.globalEpisodes[rated[i]]!.notifier, 
                  builder: (context, episodeData, child){
                    return CustomEpisodeDisplay(
                      episodeData: episodeData, 
                      skeletonMode: false,
                      key: UniqueKey()
                    );
                  });
              },
            )),
          ],
        ),
      );
    }else{
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
          ),
          SliverList(delegate: SliverChildBuilderDelegate(
            childCount: shimmerDefaultLength, 
            (c, i) {
              return shimmerSkeletonWidget(
                CustomEpisodeDisplay(
                  episodeData: EpisodeDataClass.generateNewInstance(-1), 
                  skeletonMode: true,
                  key: UniqueKey()
                ),
              );
            },
          )),
        ],
      );
    }
  }
  
  @override
  bool get wantKeepAlive => true;

}