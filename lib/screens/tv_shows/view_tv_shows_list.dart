import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewTvShowsList extends StatelessWidget {
  final String urlParam;

  const ViewTvShowsList({
    super.key,
    required this.urlParam
  });

  @override
  Widget build(BuildContext context) {
    return _ViewTvShowsListStateful(
      urlParam: urlParam,
    );
  }
}

class _ViewTvShowsListStateful extends StatefulWidget {
  final String urlParam;

  const _ViewTvShowsListStateful({
    required this.urlParam
  });

  @override
  State<_ViewTvShowsListStateful> createState() => _ViewTvShowsListStatefulState();
}

class _ViewTvShowsListStatefulState extends State<_ViewTvShowsListStateful>{
  late TvShowsListController controller;

  @override
  void initState(){
    super.initState();
    controller = TvShowsListController(context, widget.urlParam);
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
        controller.tvShows,
        controller.paginationStatus,
        controller.totalResults
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        List<int> tvShows = controller.tvShows.value;
        int totalResults = controller.totalResults.value;
        PaginationStatus paginationStatus = controller.paginationStatus.value;
        
        if(!isLoading){
          return Scaffold(
            appBar: AppBar(
              title: setAppBarTitle('TV Shows'),
              flexibleSpace: Container(
                decoration: defaultAppBarDecoration
              ),
            ),
            body: LoadMoreBottom(
              addBottomSpace: tvShows.length < totalResults,
              loadMore: () async{
                if(tvShows.length < totalResults){
                  controller.paginate();
                }
              },
              status: paginationStatus,
              refresh: null,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  SliverList(delegate: SliverChildBuilderDelegate(
                    childCount: tvShows.length, 
                    (c, i) {
                      if(appStateRepo.globalTvSeries[tvShows[i]] == null){
                        return Container();
                      }
                      return ValueListenableBuilder(
                        valueListenable: appStateRepo.globalTvSeries[tvShows[i]]!.notifier,
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
            ),
          );
        }else{
          return Scaffold(
            appBar: AppBar(
              title: setAppBarTitle('TV Shows'),
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
                      CustomBasicTvSeriesDisplay(
                        tvSeriesData: TvSeriesDataClass.generateNewInstance(-1), 
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