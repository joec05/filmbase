import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewFavouriteMovies extends StatelessWidget {
  const ViewFavouriteMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ViewFavouriteMoviesStateful();
  }
}

class _ViewFavouriteMoviesStateful extends StatefulWidget {
  const _ViewFavouriteMoviesStateful();

  @override
  State<_ViewFavouriteMoviesStateful> createState() => _ViewFavouriteMoviesStatefulState();
}

class _ViewFavouriteMoviesStatefulState extends State<_ViewFavouriteMoviesStateful> with AutomaticKeepAliveClientMixin{
  late FavouriteMoviesController controller;

  @override
  void initState(){
    super.initState();
    controller = FavouriteMoviesController(context);
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
        controller.favourites,
        controller.paginationStatus,
        controller.totalResults
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        List<int> favourites = controller.favourites.value;
        int totalResults = controller.totalResults.value;
        PaginationStatus paginationStatus = controller.paginationStatus.value;

        if(!isLoading){
          return LoadMoreBottom(
            addBottomSpace: favourites.length < totalResults,
            loadMore: () async{
              if(favourites.length < totalResults){
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
                  childCount: favourites.length, 
                  (c, i) {
                    if(appStateRepo.globalMovies[favourites[i]] == null){
                      return Container();
                    }
                    return ValueListenableBuilder(
                      valueListenable: appStateRepo.globalMovies[favourites[i]]!.notifier,
                      builder: (context, movieData, child){
                        return CustomBasicMovieDisplay(
                          movieData: movieData, 
                          skeletonMode: false,
                          key: UniqueKey(),
                        );
                      },
                    );
                  }
                ))
              ]
            )
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
                }
              ))
            ]
          );
        }
      }
    );
  }
  
  @override
  bool get wantKeepAlive => true;

}