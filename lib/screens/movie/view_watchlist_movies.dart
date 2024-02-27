import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

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
  late WatchlistMoviesController controller;

  @override
  void initState(){
    super.initState();
    controller = WatchlistMoviesController(context);
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
        controller.watchlists,
        controller.paginationStatus,
        controller.totalResults
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        List<int> watchlists = controller.watchlists.value;
        int totalResults = controller.totalResults.value;
        PaginationStatus paginationStatus = controller.paginationStatus.value;
        
        if(!isLoading){
          return LoadMoreBottom(
            addBottomSpace: watchlists.length < totalResults,
            loadMore: () async{
              if(watchlists.length < totalResults){
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
                  childCount: watchlists.length, 
                  (c, i) {
                    if(appStateRepo.globalMovies[watchlists[i]] == null){
                      return Container();
                    }
                    return ValueListenableBuilder(
                      valueListenable: appStateRepo.globalMovies[watchlists[i]]!.notifier,
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
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}