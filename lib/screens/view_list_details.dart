import 'dart:async';
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
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchListDetails(1);
  }

  @override
  void dispose(){
    super.dispose();
  }

  void fetchListDetails(int page) async{
    var res = await dio.get(
      '$mainAPIUrl/list/${widget.listID}?page=$page',
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      var data = res.data;
      totalResults = res.data['item_count'];
      var items = res.data['items'];
      List<MediaItemClass> mediaItems = [];
      for(int i = 0; i < items.length; i++){
        items[i]['title'] = items[i]['name'] ?? items[i]['title'];
        items[i]['original_title'] = items[i]['original_name'] ?? items[i]['original_title'];
        if(items[i]['media_type'] == 'movie'){
          updateMovieBasicData(items[i]);
          mediaItems.add(MediaItemClass(
            MediaType.movie, 
            items[i]['id']
          ));
        }else{
          updateTvSeriesBasicData(items[i]);
          mediaItems.add(MediaItemClass(
            MediaType.tvShow, 
            items[i]['id']
          ));
        }
      }
      if(page > 1){
        data['media_items'] = {...appStateRepo.globalLists[widget.listID]!.notifier.value.mediaItems, ...mediaItems}.toSet().toList();
      }else{
        data['media_items'] = mediaItems;
      }
      if(mounted){
        setState(() {
          updateListData(data);
          paginationStatus = PaginationStatus.loaded;
          isLoading = false;
        });
      }
    }else{
      if(mounted){
        handler.displaySnackbar(
          context, 
          SnackbarType.error, 
          tErr.api
        );
      }
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchListDetails(
          appStateRepo.globalLists[widget.listID]!.notifier.value.mediaItems.length ~/ 20 + 1
        );
      });
    }
  }

  @override
  Widget build(BuildContext context){
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
                  paginate();
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
}