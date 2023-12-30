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

class SearchedTvShows extends StatelessWidget {
  final String searchedText;

  const SearchedTvShows({
    super.key,
    required this.searchedText
  });

  @override
  Widget build(BuildContext context) {
    return _SearchedTvShowsStateful(
      searchedText: searchedText
    );
  }
}

class _SearchedTvShowsStateful extends StatefulWidget {
  final String searchedText;

  const _SearchedTvShowsStateful({
    required this.searchedText
  });

  @override
  State<_SearchedTvShowsStateful> createState() => _SearchedTvShowsStatefulState();
}

class _SearchedTvShowsStatefulState extends State<_SearchedTvShowsStateful> with AutomaticKeepAliveClientMixin{
  List<int> tvSeries = [];
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    if(widget.searchedText.isNotEmpty){
      isLoading = true;
      fetchSearchedTvShows(1);
    }
  }

  @override
  void dispose(){
    super.dispose();
  }

  void fetchSearchedTvShows(int page) async{
    List<int> getSearchedTvShows = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/search/tv?query=${widget.searchedText}&page=$page'
    );

    if(mounted){
      setState(() {
        tvSeries.addAll(getSearchedTvShows);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchSearchedTvShows(
          tvSeries.length ~/ 20 + 1
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
      totalResults = min(maxSearchedResultsCount, res.data['total_results']);
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
        addBottomSpace: tvSeries.length < totalResults,
        loadMore: () async{
          if(tvSeries.length < totalResults){
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
              childCount: tvSeries.length, 
              (c, i) {
                if(appStateClass.globalTvSeries[tvSeries[i]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: appStateClass.globalTvSeries[tvSeries[i]]!.notifier,
                  builder: (context, tvSeriesData, child){
                    return CustomBasicTvSeriesDisplay(
                      tvSeriesData: tvSeriesData, 
                      skeletonMode: false
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
                  skeletonMode: true
                )
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