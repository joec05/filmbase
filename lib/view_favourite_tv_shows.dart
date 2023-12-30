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
import 'package:filmbase/streams/update_favourite_stream_class.dart';
import 'package:filmbase/styles/app_styles.dart';

class ViewFavouriteTvShows extends StatelessWidget {
  const ViewFavouriteTvShows({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ViewFavouriteTvShowsStateful();
  }
}

class _ViewFavouriteTvShowsStateful extends StatefulWidget {
  const _ViewFavouriteTvShowsStateful();

  @override
  State<_ViewFavouriteTvShowsStateful> createState() => _ViewFavouriteTvShowsStatefulState();
}

class _ViewFavouriteTvShowsStatefulState extends State<_ViewFavouriteTvShowsStateful> with AutomaticKeepAliveClientMixin{
  List<int> favourites = [];
  late StreamSubscription updateFavouriteStreamClassSubscrition;
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchFavouriteTvShows(1);
    updateFavouriteStreamClassSubscrition = UpdateFavouriteStreamClass().updateFavouriteStream.listen((FavouriteStreamControllerClass data){
      if(mounted){
        if(data.dataType == UpdateStreamDataType.tvShow){
          if(data.actionType == UpdateStreamActionType.add){
            setState((){
              favourites.insert(0, data.id);
              favourites = favourites.toSet().toList();
            });
          }else if(data.actionType == UpdateStreamActionType.delete){
            setState((){
              favourites.remove(data.id);
            });
          }
        }
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    updateFavouriteStreamClassSubscrition.cancel();
  }
  
  void fetchFavouriteTvShows(int page) async{
    List<int> getFavouriteTvShows = await runFetchBasicTvSeriesAPI(
      '$mainAPIUrl/account/${appStateClass.apiIdentifiers.userID}/favorite/tv?page=$page&sort_by=created_at.desc'
    );

    if(mounted){
      setState(() {
        favourites.addAll(getFavouriteTvShows);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
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

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchFavouriteTvShows(
          favourites.length ~/ 20 + 1
        );
      });
    }
  }

  @override
  Widget build(BuildContext context){
    super.build(context);

    if(!isLoading){
      return LoadMoreBottom(
        addBottomSpace: favourites.length < totalResults,
        loadMore: () async{
          if(favourites.length < totalResults){
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
              childCount: favourites.length, 
              (c, i) {
                if(appStateClass.globalTvSeries[favourites[i]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: appStateClass.globalTvSeries[favourites[i]]!.notifier,
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