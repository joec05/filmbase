import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

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
  late FavouriteTvShowsController controller;

  @override
  void initState(){
    super.initState();
    controller = FavouriteTvShowsController(context);
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
                    if(appStateRepo.globalTvSeries[favourites[i]] == null){
                      return Container();
                    }
                    return ValueListenableBuilder(
                      valueListenable: appStateRepo.globalTvSeries[favourites[i]]!.notifier,
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
    );
  }
  
  @override
  bool get wantKeepAlive => true;

}