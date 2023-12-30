import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_enums.dart';
import 'package:filmbase/appdata/global_functions.dart';
import 'package:filmbase/appdata/global_variables.dart';
import 'package:filmbase/appdata/state_actions.dart';
import 'package:filmbase/class/movie_data_class.dart';
import 'package:filmbase/custom/custom_basic_movie_display.dart';
import 'package:filmbase/custom/custom_pagination.dart';
import 'package:filmbase/state/main.dart';
import 'package:filmbase/styles/app_styles.dart';

class ViewMoviesList extends StatelessWidget {
  final String urlParam;

  const ViewMoviesList({
    super.key,
    required this.urlParam
  });

  @override
  Widget build(BuildContext context) {
    return _ViewMoviesListStateful(
      urlParam: urlParam,
    );
  }
}

class _ViewMoviesListStateful extends StatefulWidget {
  final String urlParam;

  const _ViewMoviesListStateful({
    required this.urlParam
  });

  @override
  State<_ViewMoviesListStateful> createState() => _ViewMoviesListStatefulState();
}

class _ViewMoviesListStatefulState extends State<_ViewMoviesListStateful>{
  List<int> movies = [];
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  int totalResults = 0;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchMovies(1);
  }

  @override
  void dispose(){
    super.dispose();
  }

  void fetchMovies(int page) async{
    List<int> getRatedMovies = await runFetchBasicMovieAPI(
      '${widget.urlParam}&page=$page'
    );
    
    if(mounted){
      setState(() {
        movies.addAll(getRatedMovies);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchMovies(
          movies.length ~/ 20 + 1
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
      totalResults = min(maxViewResultsCount, res.data['total_results']);
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
    if(!isLoading){
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration
          ),
          title: setAppBarTitle('Movies'),
        ),
        body: LoadMoreBottom(
          addBottomSpace: movies.length < totalResults,
          loadMore: () async{
            if(movies.length < totalResults){
              paginate();
            }
          },
          status: paginationStatus,
          refresh: null,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverList(delegate: SliverChildBuilderDelegate(
                childCount: movies.length, 
                (c, i) {
                  if(appStateClass.globalMovies[movies[i]] == null){
                    return Container();
                  }
                  return ValueListenableBuilder(
                    valueListenable: appStateClass.globalMovies[movies[i]]!.notifier,
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
        ),
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          title: setAppBarTitle('Movies'),
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
                  CustomBasicMovieDisplay(
                    movieData: MovieDataClass.generateNewInstance(-1), 
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