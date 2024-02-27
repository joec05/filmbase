import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewListDetails extends StatelessWidget {
  final int listID;

  const ViewListDetails({
    super.key,
    required this.listID,
  });

  @override
  Widget build(BuildContext context) {
    return _ViewListDetailsStateful(
      listID: listID,
    );
  }
}

class _ViewListDetailsStateful extends StatefulWidget {
  final int listID;

  const _ViewListDetailsStateful({
    required this.listID,
  });

  @override
  State<_ViewListDetailsStateful> createState() => _ViewListDetailsStatefulState();
}

class _ViewListDetailsStatefulState extends State<_ViewListDetailsStateful>{
  late ListDetailsController controller;

  @override
  void initState(){
    super.initState();
    controller = ListDetailsController(context, widget.listID);
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
        controller.paginationStatus,
        controller.totalResults
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        int totalResults = controller.totalResults.value;
        PaginationStatus paginationStatus = controller.paginationStatus.value;

        if(!isLoading && appStateRepo.globalLists[widget.listID] != null){
          return Scaffold(
            appBar: AppBar(
              title: setAppBarTitle('List Details'),
              flexibleSpace: Container(
                decoration: defaultAppBarDecoration,
              ),
            ),
            body: ValueListenableBuilder(
              valueListenable: appStateRepo.globalLists[widget.listID]!.notifier,
              builder: (context, listData, child){
                return LoadMoreBottom(
                  addBottomSpace: listData.mediaItems.length < totalResults,
                  loadMore: () async{
                    if(listData.mediaItems.length < totalResults){
                      controller.paginate();
                    }
                  },
                  status: paginationStatus,
                  refresh: null,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: <Widget>[
                      SliverToBoxAdapter(
                        child: CustomListDetails(
                          listData: listData, 
                          skeletonMode: false,
                          key: UniqueKey()
                        )
                      ),
                      SliverList(delegate: SliverChildBuilderDelegate(
                        childCount: listData.mediaItems.length, 
                        (c, i) {
                          if(listData.mediaItems[i].mediaType == MediaType.movie){
                            MovieDataClass movieData = appStateRepo.globalMovies[listData.mediaItems[i].id]!.notifier.value;
                            return CustomBasicMovieDisplay(
                              movieData: movieData,
                              skeletonMode: false,
                              key: UniqueKey()
                            );
                          }else if(listData.mediaItems[i].mediaType == MediaType.tvShow){
                            TvSeriesDataClass tvShowData = appStateRepo.globalTvSeries[listData.mediaItems[i].id]!.notifier.value;
                            return CustomBasicTvSeriesDisplay(
                              tvSeriesData: tvShowData,
                              skeletonMode: false,
                              key: UniqueKey()
                            );
                          }
                          return Container();
                        }
                      ))
                    ]
                  )
                );
              },
            ),
          );
        }else{
          return Scaffold(
            appBar: AppBar(
              title: setAppBarTitle('List Details'),
              flexibleSpace: Container(
                decoration: defaultAppBarDecoration,
              ),
            ),
            body: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: shimmerSkeletonWidget(
                    CustomListDetails(
                      listData: ListDataClass.generateNewInstance(-1), 
                      skeletonMode: true,
                      key: UniqueKey()
                    ),
                  )
                ),
                SliverList(delegate: SliverChildBuilderDelegate(
                  childCount: shimmerDefaultLength, 
                  (c, i) {
                    return shimmerSkeletonWidget(
                      CustomBasicMovieDisplay(
                        movieData: MovieDataClass.generateNewInstance(-1),
                        skeletonMode: true,
                        key: UniqueKey()
                      ),
                    );
                  }
                ))
              ]
            ),
          );
        }
      }
    );
  }
}