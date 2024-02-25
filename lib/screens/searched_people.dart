import 'dart:math';
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
  List<int> people = [];
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    if(widget.searchedText.isNotEmpty){
      isLoading = true;
      fetchSearchedPeople(1);
    }
  }

  @override
  void dispose(){
    super.dispose();
  }

  void fetchSearchedPeople(int page) async{
    List<int> getSearchedPeople = await runFetchBasicPeopleAPI(
      '$mainAPIUrl/search/person?query=${widget.searchedText}&page=$page'
    );

    if(mounted){
      setState(() {
        people.addAll(getSearchedPeople);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchSearchedPeople(
          people.length ~/ 20 + 1
        );
      });
    }
  }

  Future<List<int>> runFetchBasicPeopleAPI(String url) async{
    List<int> ids = [];
    var res = await dio.get(
      url,
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      totalResults = min(maxSearchedResultsCount, res.data['total_results']);
      var data = res.data['results'];
      for(int i = 0; i < data.length; i++){
        var detailsReq = await dio.get(
          '$mainAPIUrl/person/${data[i]['id']}',
          options: defaultAPIOption
        );
        if(detailsReq.statusCode == 200){
          ids.add(data[i]['id']);
          updatePeopleBasicData(detailsReq.data);
        }
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
    return ids;
  }

  @override
  Widget build(BuildContext context){
    super.build(context);

    if(!isLoading){
      return LoadMoreBottom(
        addBottomSpace: people.length < totalResults,
        loadMore: () async{
          if(people.length < totalResults){
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
  
  @override
  bool get wantKeepAlive => true;
}