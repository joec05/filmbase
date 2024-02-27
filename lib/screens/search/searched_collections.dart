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
  late SearchedCollectionsController controller;
  
  @override
  void initState(){
    super.initState();
    controller = SearchedCollectionsController(context, widget.searchedText);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    super.build(context);

    return ListenableBuilder(
      listenable: Listenable.merge([
        controller.isLoading,
        controller.collections,
        controller.paginationStatus,
        controller.totalResults
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        List<CollectionDataClass> collections = controller.collections.value;
        int totalResults = controller.totalResults.value;
        PaginationStatus paginationStatus = controller.paginationStatus.value;
        if(!isLoading){
          return LoadMoreBottom(
            addBottomSpace: collections.length < totalResults,
            loadMore: () async{
              if(collections.length < totalResults){
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
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}