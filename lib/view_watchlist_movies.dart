import 'dart:async';
import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_enums.dart';
import 'package:filmbase/appdata/global_functions.dart';
import 'package:filmbase/appdata/global_variables.dart';
import 'package:filmbase/appdata/state_actions.dart';
import 'package:filmbase/class/movie_data_class.dart';
import 'package:filmbase/custom/custom_basic_movie_display.dart';
import 'package:filmbase/custom/custom_pagination.dart';
import 'package:filmbase/state/main.dart';
import 'package:filmbase/streams/update_watchlist_stream_class.dart';
import 'package:filmbase/styles/app_styles.dart';

class ViewWatchlistMovies extends StatelessWidget {
  const ViewWatchlistMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ViewWatchlistMoviesStateful();
  }
}

class _ViewWatchlistMoviesStateful extends StatefulWidget {
  const _ViewWatchlistMoviesStateful();

  @override
  State<_ViewWatchlistMoviesStateful> createState() => _ViewWatchlistMoviesStatefulState();
}

class _ViewWatchlistMoviesStatefulState extends State<_ViewWatchlistMoviesStateful> with AutomaticKeepAliveClientMixin{
  List<int> watchlists = [];
  late StreamSubscription updateWatchlistStreamClassSubscrition;
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchWatchlistMovies(1);
    updateWatchlistStreamClassSubscrition = UpdateWatchlistStreamClass().updateWatchlistStream.listen((WatchlistStreamControllerClass data){
      if(mounted){
        if(data.dataType == UpdateStreamDataType.movie){
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

  void fetchWatchlistMovies(int page) async{
    List<int> getWatchlistMovies = await runFetchBasicMovieAPI(
      '$mainAPIUrl/account/${appStateClass.apiIdentifiers.userID}/watchlist/movies?page=$page&sort_by=created_at.desc'
    );

    if(mounted){
      setState(() {
        watchlists.addAll(getWatchlistMovies);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchWatchlistMovies(
          watchlists.length ~/ 20 + 1
        );
      });
    }
  }

  Future<List<int>> runFetchBasicMovieAPI(String url) async{
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
        updateMovieBasicData(data[i]);
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
                if(appStateClass.globalMovies[watchlists[i]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: appStateClass.globalMovies[watchlists[i]]!.notifier,
                  builder: (context, movieData, child){
                    return CustomBasicMovieDisplay(
                      movieData: movieData, 
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
                CustomBasicMovieDisplay(
                  movieData: MovieDataClass.generateNewInstance(-1), 
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