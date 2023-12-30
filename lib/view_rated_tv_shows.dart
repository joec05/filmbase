import 'dart:async';
import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_enums.dart';
import 'package:filmbase/appdata/global_functions.dart';
import 'package:filmbase/appdata/global_variables.dart';
import 'package:filmbase/appdata/state_actions.dart';
import 'package:filmbase/class/tv_series_data_class.dart';
import 'package:filmbase/custom/custom_basic_tv_series_display.dart';
import 'package:filmbase/custom/custom_pagination.dart';
import 'package:filmbase/state/main.dart';
import 'package:filmbase/streams/update_rated_stream_class.dart';
import 'package:filmbase/styles/app_styles.dart';

class ViewRatedTvShows extends StatelessWidget {
  const ViewRatedTvShows({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ViewRatedTvShowsStateful();
  }
}

class _ViewRatedTvShowsStateful extends StatefulWidget {
  const _ViewRatedTvShowsStateful();

  @override
  State<_ViewRatedTvShowsStateful> createState() => _ViewRatedTvShowsStatefulState();
}

class _ViewRatedTvShowsStatefulState extends State<_ViewRatedTvShowsStateful> with AutomaticKeepAliveClientMixin{
  List<int> rated = [];
  late StreamSubscription updateRatedStreamClassSubscription;
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchRatedTvShows(1);
    updateRatedStreamClassSubscription = UpdateRatedStreamClass().updateRatedStream.listen((RatedStreamControllerClass data) {
      if(mounted){
        if(data.dataType == UpdateStreamDataType.tvShow){
          if(rated.contains(data.id)){
            setState(() {
              rated.remove(data.id);
              rated.insert(0, data.id);
            });
          }else{
            setState(() {
              rated.insert(0, data.id);
              rated.removeLast();
            });
          }
        }
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    updateRatedStreamClassSubscription.cancel();
  }

  void fetchRatedTvShows(int page) async{
    List<int> getRatedTvShows = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/account/${appStateClass.apiIdentifiers.userID}/rated/tv?page=$page&sort_by=created_at.desc'
    );

    if(mounted){
      setState(() {
        rated.addAll(getRatedTvShows);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchRatedTvShows(
          rated.length ~/ 20 + 1
        );
      });
    }
  }

  Future<List<int>> runFetchBasicTvSeriesAPI(String url) async{
    List<int> ids = [];
    var res = await dio.get(
      url,
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      totalResults = res.data['total_results'];
      var data = res.data['results'];
      for(int i = 0; i < data.length; i++){
        ids.add(data[i]['id']);
        updateTvSeriesBasicData(data[i]);
      }
    }else{
      if(mounted){
        displayAlertDialog(
          context,
          'Error ${res.statusCode}. ${res.statusMessage}'
        );
      }
    }
    return ids;
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
                if(appStateClass.globalTvSeries[rated[i]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: appStateClass.globalTvSeries[rated[i]]!.notifier,
                  builder: (context, tvSeriesData, child){
                    return CustomBasicTvSeriesDisplay(
                      tvSeriesData: tvSeriesData, 
                      skeletonMode: false,
                      key: UniqueKey(),
                    );
                  },
                );
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
                CustomBasicTvSeriesDisplay(
                  tvSeriesData: TvSeriesDataClass.generateNewInstance(-1), 
                  skeletonMode: true,
                  key: UniqueKey(),
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