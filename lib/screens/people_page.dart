import 'dart:math';
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
  List<int> popular = [];
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  bool isLoading = true;
  
  @override
  void initState(){
    super.initState();
    fetchPeople(1);
  }

  @override
  void dispose(){
    super.dispose();
  }

  void fetchPeople(int page) async{
    List<int> fetchPopular = await runFetchBasicMovieAPI(
      '$mainAPIUrl/person/popular?page=$page'
    );

    if(mounted){
      setState((){
        popular.addAll(fetchPopular);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchPeople(
          popular.length ~/ 20 + 1
        );
      });
    }
  }

  Future<List<int>> runFetchBasicMovieAPI(String url) async{
    List<int> ids = [];
    var res = await dio.get(
      url,
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      totalResults = min(maxViewResultsCount, res.data['total_results']);
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
        addBottomSpace: popular.length < totalResults,
        loadMore: () async{
          if(popular.length < totalResults){
            paginate();
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


  @override
  bool get wantKeepAlive => true;
}