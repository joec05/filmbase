import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class SearchedPeople extends StatelessWidget {
  final String searchedText;

  const SearchedPeople({
    super.key,
    required this.searchedText
  });

  @override
  Widget build(BuildContext context) {
    return _SearchedPeopleStateful(
      searchedText: searchedText
    );
  }
}

class _SearchedPeopleStateful extends StatefulWidget {
  final String searchedText;

  const _SearchedPeopleStateful({
    required this.searchedText
  });

  @override
  State<_SearchedPeopleStateful> createState() => _SearchedPeopleStatefulState();
}

class _SearchedPeopleStatefulState extends State<_SearchedPeopleStateful> with AutomaticKeepAliveClientMixin{
  late SearchedPeopleController controller;

  @override
  void initState(){
    super.initState();
    controller = SearchedPeopleController(context, widget.searchedText);
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
        controller.people,
        controller.paginationStatus,
        controller.totalResults
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        List<int> people = controller.people.value;
        int totalResults = controller.totalResults.value;
        PaginationStatus paginationStatus = controller.paginationStatus.value;
        
        if(!isLoading){
          return LoadMoreBottom(
            addBottomSpace: people.length < totalResults,
            loadMore: () async{
              if(people.length < totalResults){
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
                  childCount: people.length, 
                  (c, i) {
                    if(appStateRepo.globalPeople[people[i]] == null){
                      return Container();
                    }
                    return ValueListenableBuilder(
                      valueListenable: appStateRepo.globalPeople[people[i]]!.notifier,
                      builder: (context, peopleData, child){
                        return CustomBasicPeopleDisplay(
                          peopleData: peopleData, 
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
                      CustomBasicPeopleDisplay(
                        peopleData: PeopleDataClass.generateNewInstance(-1), 
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