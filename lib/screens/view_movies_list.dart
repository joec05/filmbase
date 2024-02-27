import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

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
  late MoviesListController controller;

  @override
  void initState(){
    super.initState();
    controller = MoviesListController(context, widget.urlParam);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context){
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
                  controller.paginate();
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
                      if(appStateRepo.globalMovies[movies[i]] == null){
                        return Container();
                      }
                      return ValueListenableBuilder(
                        valueListenable: appStateRepo.globalMovies[movies[i]]!.notifier,
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
    );
  }
}