import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewMovieDetails extends StatelessWidget {
  final int movieID;

  const ViewMovieDetails({
    super.key,
    required this.movieID
  });

  @override
  Widget build(BuildContext context) {
    return _ViewMovieDetailsStateful(
      movieID: movieID
    );
  }
}

class _ViewMovieDetailsStateful extends StatefulWidget {
  final int movieID;
  
 const _ViewMovieDetailsStateful({
    required this.movieID
  });

  @override
  State<_ViewMovieDetailsStateful> createState() => _ViewMovieDetailsStatefulState();
}

class _ViewMovieDetailsStatefulState extends State<_ViewMovieDetailsStateful>{
  late MovieDetailsController controller;

  @override
  void initState(){
    super.initState();
    controller = MovieDetailsController(context, widget.movieID);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: controller.isLoading,
      builder: (context, isLoading, child) {
        if(!isLoading && appStateRepo.globalMovies[widget.movieID] != null){
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: defaultAppBarDecoration
              ),
              title: setAppBarTitle('Movie Details'),
            ),
            body: ValueListenableBuilder(
              valueListenable: appStateRepo.globalMovies[widget.movieID]!.notifier, 
              builder: (context, movieData, child){
                return CustomMovieDetails(
                  movieData: movieData,
                  key: UniqueKey(),
                  skeletonMode: false
                );
              }
            ),
          );
        }else{
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: defaultAppBarDecoration
              ),
              title: setAppBarTitle('Movie Details'),
            ),
            body: shimmerSkeletonWidget(
              CustomMovieDetails(
                movieData: MovieDataClass.generateNewInstance(-1),
                key: UniqueKey(),
                skeletonMode: true
              ),
            ),
          );
        }
      }
    );
  }
}