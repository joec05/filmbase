import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class SearchedTvShows extends StatelessWidget {
  final String searchedText;

  const SearchedTvShows({
    super.key,
    required this.searchedText
  });

  @override
  Widget build(BuildContext context) {
    return _SearchedTvShowsStateful(
      searchedText: searchedText
    );
  }
}

class _SearchedTvShowsStateful extends StatefulWidget {
  final String searchedText;

  const _SearchedTvShowsStateful({
    required this.searchedText
  });

  @override
  State<_SearchedTvShowsStateful> createState() => _SearchedTvShowsStatefulState();
}

class _SearchedTvShowsStatefulState extends State<_SearchedTvShowsStateful> with AutomaticKeepAliveClientMixin{
  late SearchedTvShowsController controller;

  @override
  void initState(){
    super.initState();
    controller = SearchedTvShowsController(context, widget.searchedText);
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
        controller.tvSeries,
        controller.paginationStatus,
        controller.totalResults
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        List<int> tvSeries = controller.tvSeries.value;
        int totalResults = controller.totalResults.value;
        PaginationStatus paginationStatus = controller.paginationStatus.value;
        if(!isLoading){
      return LoadMoreBottom(
        addBottomSpace: tvSeries.length < totalResults,
        loadMore: () async{
          if(tvSeries.length < totalResults){
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
              childCount: tvSeries.length, 
              (c, i) {
                if(appStateRepo.globalTvSeries[tvSeries[i]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: appStateRepo.globalTvSeries[tvSeries[i]]!.notifier,
                  builder: (context, tvSeriesData, child){
                    return CustomBasicTvSeriesDisplay(
                      tvSeriesData: tvSeriesData, 
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
                    CustomBasicTvSeriesDisplay(
                      tvSeriesData: TvSeriesDataClass.generateNewInstance(-1), 
                      skeletonMode: true
                    )
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