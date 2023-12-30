import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_enums.dart';
import 'package:filmbase/appdata/global_functions.dart';
import 'package:filmbase/appdata/global_variables.dart';
import 'package:filmbase/appdata/state_actions.dart';
import 'package:filmbase/class/tv_series_data_class.dart';
import 'package:filmbase/custom/custom_basic_tv_series_display.dart';
import 'package:filmbase/custom/custom_pagination.dart';
import 'package:filmbase/state/main.dart';
import 'package:filmbase/styles/app_styles.dart';

class ViewTvShowsList extends StatelessWidget {
  final String urlParam;

  const ViewTvShowsList({
    super.key,
    required this.urlParam
  });

  @override
  Widget build(BuildContext context) {
    return _ViewTvShowsListStateful(
      urlParam: urlParam,
    );
  }
}

class _ViewTvShowsListStateful extends StatefulWidget {
  final String urlParam;

  const _ViewTvShowsListStateful({
    required this.urlParam
  });

  @override
  State<_ViewTvShowsListStateful> createState() => _ViewTvShowsListStatefulState();
}

class _ViewTvShowsListStatefulState extends State<_ViewTvShowsListStateful>{
  List<int> tvShows = [];
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  int totalResults = 0;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchTvShows(1);
  }

  @override
  void dispose(){
    super.dispose();
  }

  void fetchTvShows(int page) async{
    List<int> getRatedTvShows = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/tv/${widget.urlParam}?page=$page'
    );

    if(mounted){
      setState(() {
        tvShows.addAll(getRatedTvShows);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchTvShows(
          tvShows.length ~/ 20 + 1
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
      totalResults = min(maxViewResultsCount, res.data['total_results']);
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
    if(!isLoading){
      return Scaffold(
        appBar: AppBar(
          title: setAppBarTitle('TV Shows'),
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration
          ),
        ),
        body: LoadMoreBottom(
          addBottomSpace: tvShows.length < totalResults,
          loadMore: () async{
            if(tvShows.length < totalResults){
              paginate();
            }
          },
          status: paginationStatus,
          refresh: null,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverList(delegate: SliverChildBuilderDelegate(
                childCount: tvShows.length, 
                (c, i) {
                  if(appStateClass.globalTvSeries[tvShows[i]] == null){
                    return Container();
                  }
                  return ValueListenableBuilder(
                    valueListenable: appStateClass.globalTvSeries[tvShows[i]]!.notifier,
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
        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          title: setAppBarTitle('TV Shows'),
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration
          ),
        ),
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
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
        ),
      );
    }
  }
}