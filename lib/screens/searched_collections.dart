import 'dart:math';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class SearchedCollections extends StatelessWidget {
  final String searchedText;

  const SearchedCollections({
    super.key,
    required this.searchedText
  });

  @override
  Widget build(BuildContext context) {
    return _SearchedCollectionsStateful(
      searchedText: searchedText
    );
  }
}

class _SearchedCollectionsStateful extends StatefulWidget {
  final String searchedText;

  const _SearchedCollectionsStateful({
    required this.searchedText
  });

  @override
  State<_SearchedCollectionsStateful> createState() => _SearchedCollectionsStatefulState();
}

class _SearchedCollectionsStatefulState extends State<_SearchedCollectionsStateful> with AutomaticKeepAliveClientMixin{
  List<CollectionDataClass> collections = [];
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  bool isLoading = false;
  
  @override
  void initState(){
    super.initState();
    if(widget.searchedText.isNotEmpty){
      isLoading = true;
      fetchSearchedCollections(1);
    }
  }

  @override
  void dispose(){
    super.dispose();
  }

  void fetchSearchedCollections(int page) async{
    List<CollectionDataClass> getSearchedCollections = await runFetchCollectionAPI(
      '$mainAPIUrl/search/collection?query=${widget.searchedText}&page=$page'
    );

    if(mounted){
      setState(() {
        collections.addAll(getSearchedCollections);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchSearchedCollections(
          collections.length ~/ 20 + 1
        );
      });
    }
  }

  Future<List<CollectionDataClass>> runFetchCollectionAPI(String url) async{
    List<CollectionDataClass> collections = [];
    var res = await dio.get(
      url,
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      totalResults = min(maxSearchedResultsCount, res.data['total_results']);
      var data = res.data['results'];
      for(int i = 0; i < data.length; i++){
        collections.add(CollectionDataClass.fromMapBasic(data[i]));
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
    return collections;
  }

  @override
  Widget build(BuildContext context){
    super.build(context);

    if(!isLoading){
      return LoadMoreBottom(
        addBottomSpace: collections.length < totalResults,
        loadMore: () async{
          if(collections.length < totalResults){
            paginate();
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
              childCount: collections.length, 
              (c, i) {
                return CustomCollectionDisplay(
                  collectionData: collections[i],
                  skeletonMode: false,
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
                CustomCollectionDisplay(
                  collectionData: CollectionDataClass.generateNewInstance(),
                  skeletonMode: true,
                )
              );
            },
          )),
        ],
      );
    }
  }
  
  @override
  bool get wantKeepAlive => true;
}