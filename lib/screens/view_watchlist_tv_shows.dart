import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewWatchlistTvShows extends StatelessWidget {
  const ViewWatchlistTvShows({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ViewWatchlistTvShowsStateful();
  }
}

class _ViewWatchlistTvShowsStateful extends StatefulWidget {
  const _ViewWatchlistTvShowsStateful();

  @override
  State<_ViewWatchlistTvShowsStateful> createState() => _ViewWatchlistTvShowsStatefulState();
}

class _ViewWatchlistTvShowsStatefulState extends State<_ViewWatchlistTvShowsStateful> with AutomaticKeepAliveClientMixin{
  late WatchlistTvShowsController controller;

  @override
  void initState(){
    super.initState();
    controller = WatchlistTvShowsController(context);
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
                    if(appStateRepo.globalTvSeries[watchlists[i]] == null){
                      return Container();
                    }
                    return ValueListenableBuilder(
                      valueListenable: appStateRepo.globalTvSeries[watchlists[i]]!.notifier,
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