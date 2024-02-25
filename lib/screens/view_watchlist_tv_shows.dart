import 'dart:async';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewWatchlistTvShows extends StatelessWidget {
  const ViewWatchlistTvShows({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ViewWatchlistTvShowsStateful();
  }
}

class _ViewWatchlistTvShowsStateful extends StatefulWidget {
  const _ViewWatchlistTvShowsStateful();

  @override
  State<_ViewWatchlistTvShowsStateful> createState() => _ViewWatchlistTvShowsStatefulState();
}

class _ViewWatchlistTvShowsStatefulState extends State<_ViewWatchlistTvShowsStateful> with AutomaticKeepAliveClientMixin{
  List<int> watchlists = [];
  late StreamSubscription updateWatchlistStreamClassSubscrition;
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchWatchlistTvShows(1);
    updateWatchlistStreamClassSubscrition = UpdateWatchlistStreamClass().updateWatchlistStream.listen((WatchlistStreamControllerClass data){
      if(mounted){
        if(data.dataType == UpdateStreamDataType.tvShow){
          if(data.actionType == UpdateStreamActionType.add){
            setState((){
              watchlists.insert(0, data.id);
              watchlists = watchlists.toSet().toList();
            });
          }else if(data.actionType == UpdateStreamActionType.delete){
            setState((){
              watchlists.remove(data.id);
            });
          }
        }
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    updateWatchlistStreamClassSubscrition.cancel();
  }

  void fetchWatchlistTvShows(int page) async{
    List<int> getWatchlistTvShows = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/watchlist/tv?page=$page&sort_by=created_at.desc'
    );

    if(mounted){
      setState(() {
        watchlists.addAll(getWatchlistTvShows);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchWatchlistTvShows(
          watchlists.length ~/ 20 + 1
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
        handler.displaySnackbar(
          context, 
          SnackbarType.error, 
          tErr.api
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
        addBottomSpace: watchlists.length < totalResults,
        loadMore: () async{
          if(watchlists.length < totalResults){
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
              childCount: watchlists.length, 
              (c, i) {
                if(appStateRepo.globalTvSeries[watchlists[i]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: appStateRepo.globalTvSeries[watchlists[i]]!.notifier,
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