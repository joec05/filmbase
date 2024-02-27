import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

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
  late RatedMoviesController controller;

  @override
  void initState(){
    super.initState();
    controller = RatedMoviesController(context);
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
        controller.rated,
        controller.paginationStatus,
        controller.totalResults
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        List<int> rated = controller.rated.value;
        int totalResults = controller.totalResults.value;
        PaginationStatus paginationStatus = controller.paginationStatus.value;

        if(!isLoading){
          return LoadMoreBottom(
            addBottomSpace: rated.length < totalResults,
            loadMore: () async{
              if(rated.length < totalResults){
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
                  childCount: rated.length, 
                  (c, i) {
                    if(appStateRepo.globalMovies[rated[i]] == null){
                      return Container();
                    }
                    return ValueListenableBuilder(
                      valueListenable: appStateRepo.globalMovies[rated[i]]!.notifier,
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