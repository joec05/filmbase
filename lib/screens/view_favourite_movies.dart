import 'dart:async';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewFavouriteMovies extends StatelessWidget {
  const ViewFavouriteMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ViewFavouriteMoviesStateful();
  }
}

class _ViewFavouriteMoviesStateful extends StatefulWidget {
  const _ViewFavouriteMoviesStateful();

  @override
  State<_ViewFavouriteMoviesStateful> createState() => _ViewFavouriteMoviesStatefulState();
}

class _ViewFavouriteMoviesStatefulState extends State<_ViewFavouriteMoviesStateful> with AutomaticKeepAliveClientMixin{
  List<int> favourites = [];
  late StreamSubscription updateFavouriteStreamClassSubscrition;
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchFavouriteMovies(1);
    updateFavouriteStreamClassSubscrition = UpdateFavouriteStreamClass().updateFavouriteStream.listen((FavouriteStreamControllerClass data){
      if(mounted){
        if(data.dataType == UpdateStreamDataType.movie){
          if(data.actionType == UpdateStreamActionType.add){
            setState((){
              favourites.insert(0, data.id);
              favourites = favourites.toSet().toList();
            });
          }else if(data.actionType == UpdateStreamActionType.delete){
            setState((){
              favourites.remove(data.id);
            });
          }
        }
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    updateFavouriteStreamClassSubscrition.cancel();
  }

  void fetchFavouriteMovies(int page) async{
    List<int> getFavouriteMovies = await runFetchBasicMovieAPI(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/favorite/movies?page=$page&sort_by=created_at.desc'
    );

    if(mounted){
      setState(() {
        favourites.addAll(getFavouriteMovies);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchFavouriteMovies(
          favourites.length ~/ 20 + 1
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
      totalResults = res.data['total_results'];
      var data = res.data['results'];
      for(int i = 0; i < data.length; i++){
        ids.add(data[i]['id']);
        updateMovieBasicData(data[i]);
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
        addBottomSpace: favourites.length < totalResults,
        loadMore: () async{
          if(favourites.length < totalResults){
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
              childCount: favourites.length, 
              (c, i) {
                if(appStateRepo.globalMovies[favourites[i]] == null){
                  return Container();
                }
                return ValueListenableBuilder(
                  valueListenable: appStateRepo.globalMovies[favourites[i]]!.notifier,
                  builder: (context, movieData, child){
                    return CustomBasicMovieDisplay(
                      movieData: movieData, 
                      skeletonMode: false,
                      key: UniqueKey(),
                    );
                  },
                );
              }
            ))
          ]
        )
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
                CustomBasicMovieDisplay(
                  movieData: MovieDataClass.generateNewInstance(-1), 
                  skeletonMode: true,
                  key: UniqueKey(),
                ),
              );
            }
          ))
        ]
      );
    }
  }
  
  @override
  bool get wantKeepAlive => true;

}