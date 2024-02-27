import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewRatedTvShows extends StatelessWidget {
  const ViewRatedTvShows({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ViewRatedTvShowsStateful();
  }
}

class _ViewRatedTvShowsStateful extends StatefulWidget {
  const _ViewRatedTvShowsStateful();

  @override
  State<_ViewRatedTvShowsStateful> createState() => _ViewRatedTvShowsStatefulState();
}

class _ViewRatedTvShowsStatefulState extends State<_ViewRatedTvShowsStateful> with AutomaticKeepAliveClientMixin{
  late RatedTvShowsController controller;

  @override
  void initState(){
    super.initState();
    controller = RatedTvShowsController(context);
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
                    if(appStateRepo.globalTvSeries[rated[i]] == null){
                      return Container();
                    }
                    return ValueListenableBuilder(
                      valueListenable: appStateRepo.globalTvSeries[rated[i]]!.notifier,
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