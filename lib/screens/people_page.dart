import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PeoplePageStateful();
  }
}

class _PeoplePageStateful extends StatefulWidget {
  const _PeoplePageStateful();

  @override
  State<_PeoplePageStateful> createState() => _PeoplePageStatefulState();
}

class _PeoplePageStatefulState extends State<_PeoplePageStateful> with AutomaticKeepAliveClientMixin{
  late PeopleController controller;
  
  @override
  void initState(){
    super.initState();
    controller = PeopleController(context);
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
        controller.popular,
        controller.paginationStatus,
        controller.totalResults
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        List<int> popular = controller.popular.value;
        int totalResults = controller.totalResults.value;
        PaginationStatus paginationStatus = controller.paginationStatus.value;
        if(!isLoading){
          return LoadMoreBottom(
            addBottomSpace: popular.length < totalResults,
            loadMore: () async{
              if(popular.length < totalResults){
                controller.paginate();
              }
            },
            status: paginationStatus,
            refresh: null,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverList(delegate: SliverChildBuilderDelegate(
                  childCount: popular.length, 
                  (c, i) {
                    if(appStateRepo.globalPeople[popular[i]] == null){
                      return Container();
                    }
                    return ValueListenableBuilder(
                      valueListenable: appStateRepo.globalPeople[popular[i]]!.notifier,
                      builder: (context, peopleData, child){
                        return CustomBasicPeopleDisplay(
                          peopleData: peopleData, 
                          skeletonMode: false
                        );
                      },
                    );
                  }
                ))
              ],
            ),
          );
        }else{
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverList(delegate: SliverChildBuilderDelegate(
                childCount: shimmerDefaultLength, 
                (c, i) {
                  return shimmerSkeletonWidget(
                    CustomBasicPeopleDisplay(
                      peopleData: PeopleDataClass.generateNewInstance(-1), 
                      skeletonMode: true
                    )
                  );
                }
              ))
            ],
          );
        }
      }
    );
  }


  @override
  bool get wantKeepAlive => true;
}