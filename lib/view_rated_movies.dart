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
import 'package:filmbase/streams/update_rated_stream_class.dart';
import 'package:filmbase/styles/app_styles.dart';

class ViewRatedMovies extends StatelessWidget {
  const ViewRatedMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ViewRatedMoviesStateful();
  }
}

class _ViewRatedMoviesStateful extends StatefulWidget {
  const _ViewRatedMoviesStateful();

  @override
  State<_ViewRatedMoviesStateful> createState() => _ViewRatedMoviesStatefulState();
}

class _ViewRatedMoviesStatefulState extends State<_ViewRatedMoviesStateful> with AutomaticKeepAliveClientMixin{
  List<int> rated = [];
  late StreamSubscription updateRatedStreamClassSubscription;
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchRatedMovies(1);
    updateRatedStreamClassSubscription = UpdateRatedStreamClass().updateRatedStream.listen((RatedStreamControllerClass data) {
      if(mounted){
        if(data.dataType == UpdateStreamDataType.movie){
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

  void fetchRatedMovies(int page) async{
    List<int> getRatedMovies = await runFetchBasicMovieAPI(
      '$mainAPIUrl/account/${appStateClass.apiIdentifiers.userID}/rated/movies?page=$page&sort_by=created_at.desc'
    );

    if(mounted){
      setState(() {
        rated.addAll(getRatedMovies);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchRatedMovies(
          rated.length ~/ 20 + 1
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
                if(appStateClass.globalMovies[rated[i]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: appStateClass.globalMovies[rated[i]]!.notifier,
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