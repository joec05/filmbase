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
  late SearchedMoviesController controller;

  @override
  void initState(){
    super.initState();
    controller = SearchedMoviesController(context, widget.searchedText);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context){
    super.build(context);

    return ListenableBuilder(
      listenable: Listenable.merge([
        controller.isLoading,
        controller.movies,
        controller.paginationStatus,
        controller.totalResults
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        List<int> movies = controller.movies.value;
        int totalResults = controller.totalResults.value;
        PaginationStatus paginationStatus = controller.paginationStatus.value;
        if(!isLoading){
          return LoadMoreBottom(
            addBottomSpace: movies.length < totalResults,
            loadMore: () async{
              if(movies.length < totalResults){
                controller.paginate();
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
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}