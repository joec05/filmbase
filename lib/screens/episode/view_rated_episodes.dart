import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewRatedEpisodes extends StatelessWidget {
  const ViewRatedEpisodes({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ViewRatedEpisodesStateful();
  }
}

class _ViewRatedEpisodesStateful extends StatefulWidget {
  const _ViewRatedEpisodesStateful();

  @override
  State<_ViewRatedEpisodesStateful> createState() => _ViewRatedEpisodesStatefulState();
}

class _ViewRatedEpisodesStatefulState extends State<_ViewRatedEpisodesStateful> with AutomaticKeepAliveClientMixin{
  late RatedEpisodesController controller;

  @override
  void initState(){
    super.initState();
    controller = RatedEpisodesController(context);
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
                    if(appStateRepo.globalEpisodes[rated[i]] == null){
                      return Container();
                    }
                    return ValueListenableBuilder(
                      valueListenable: appStateRepo.globalEpisodes[rated[i]]!.notifier, 
                      builder: (context, episodeData, child){
                        return CustomEpisodeDisplay(
                          episodeData: episodeData, 
                          skeletonMode: false,
                          key: UniqueKey()
                        );
                      });
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
                    CustomEpisodeDisplay(
                      episodeData: EpisodeDataClass.generateNewInstance(-1), 
                      skeletonMode: true,
                      key: UniqueKey()
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