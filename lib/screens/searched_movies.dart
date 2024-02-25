import 'dart:math';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class SearchedMovies extends StatelessWidget {
  final String searchedText;

  const SearchedMovies({
    super.key,
    required this.searchedText
  });

  @override
  Widget build(BuildContext context) {
    return _SearchedMoviesStateful(
      searchedText: searchedText
    );
  }
}

class _SearchedMoviesStateful extends StatefulWidget {
  final String searchedText;

  const _SearchedMoviesStateful({
    required this.searchedText
  });

  @override
  State<_SearchedMoviesStateful> createState() => _SearchedMoviesStatefulState();
}

class _SearchedMoviesStatefulState extends State<_SearchedMoviesStateful> with AutomaticKeepAliveClientMixin{
  List<int> movies = [];
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    if(widget.searchedText.isNotEmpty){
      isLoading = true;
      fetchSearchedMovies(1);
    }
  }

  @override
  void dispose(){
    super.dispose();
  }

  void fetchSearchedMovies(int page) async{
    List<int> getSearchedMovies = await runFetchBasicMovieAPI(
      '$mainAPIUrl/search/movie?query=${widget.searchedText}&page=$page'
    );

    if(mounted){
      setState(() {
        movies.addAll(getSearchedMovies);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchSearchedMovies(
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
      totalResults = min(maxSearchedResultsCount, res.data['total_results']);
      var data = res.data['results'];
      for(int i = 0; i < data.length; i++){
        ids.add(data[i]['id']);
        updateMovieBasicData(data[i]);
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
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
            ),
            SliverList(delegate: SliverChildBuilderDelegate(
              childCount: movies.length, 
              (c, i) {
                if(appStateRepo.globalMovies[movies[i]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: appStateRepo.globalMovies[movies[i]]!.notifier,
                  builder: (context, movieData, child){
                    return CustomBasicMovieDisplay(
                      movieData: movieData, 
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
                CustomBasicMovieDisplay(
                  movieData: MovieDataClass.generateNewInstance(-1), 
                  skeletonMode: true
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