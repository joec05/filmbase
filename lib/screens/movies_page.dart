import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MoviesPageStateful();
  }
}

class _MoviesPageStateful extends StatefulWidget {
  const _MoviesPageStateful();

  @override
  State<_MoviesPageStateful> createState() => _MoviesPageStatefulState();
}

class _MoviesPageStatefulState extends State<_MoviesPageStateful> with AutomaticKeepAliveClientMixin{
  List<int> nowPlaying = [];
  List<int> popular = [];
  List<int> topRated = [];
  List<int> upcoming = [];
  List<int> trending = [];
  bool isLoading = true;
  List<String> urlParams = [];

  @override
  void initState(){
    super.initState();
    urlParams = [
      '$mainAPIUrl/trending/movie/week?',
      '$mainAPIUrl/discover/movie?primary_release_date.gte=${getFirstDayOfMonth()}&primary_release_date.lte=${getLastDayOfMonth()}&sort_by=popularity.desc&',
      '$mainAPIUrl/discover/movie?sort_by=popularity.desc&',
      '$mainAPIUrl/movie/top_rated?',
      '$mainAPIUrl/discover/movie?primary_release_date.gte=${getFirstDayOfNextMonth()}&primary_release_date.lte=${getLastDayOfNextMonth()}&sort_by=popularity.desc&',
    ];
    fetchMovies();
  }

  @override
  void dispose(){
    super.dispose();
  }
  
  void fetchMovies() async{
    List<int> fetchTrending = await runFetchBasicMovieAPI(
      '${urlParams[0]}page=1'
    );
    List<int> fetchNowPlaying = await runFetchBasicMovieAPI(
      '${urlParams[1]}page=1'
    );
    List<int> fetchPopular = await runFetchBasicMovieAPI(
      '${urlParams[2]}page=1'
    );
    List<int> fetchTopRated = await runFetchBasicMovieAPI(
      '${urlParams[3]}page=1'
    );
    List<int> fetchUpcoming = await runFetchBasicMovieAPI(
      '${urlParams[4]}page=1'
    );

    if(mounted){
      setState((){
        trending = fetchTrending;
        nowPlaying = fetchNowPlaying;
        popular = fetchPopular;
        topRated = fetchTopRated;
        upcoming = fetchUpcoming;
        isLoading = false;
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
    List<List<int>> lists = [
      trending,
      nowPlaying,
      popular,
      topRated,
      upcoming
    ];

    List<String> labels = [
      '',
      'This Month',
      'Popular',
      'Top Rated',
      'Upcoming'
    ];

    if(!isLoading){
      return ListView.builder(
        itemCount: lists.length,
        itemBuilder: (context, i){
          if(i == 0){
            return SizedBox(
              height: getScreenHeight() * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: getScreenHeight() * 0.3, 
                      autoPlay: true, 
                      aspectRatio: 3 / 5,
                      autoPlayInterval: const Duration(milliseconds: 3000),
                      autoPlayAnimationDuration: const Duration(milliseconds: 500)
                    ),
                    items: [1, 2, 3, 4, 5].map((x) {
                      return Builder(
                        builder: (BuildContext context) {
                          MovieDataClass movieData = appStateRepo.globalMovies[lists[i][x]]!.notifier.value;
                          return InkWell(
                            splashFactory: InkSplash.splashFactory,
                            onTap: (){
                              delayNavigationPush(
                                context,
                                ViewMovieDetails(movieID: movieData.id)
                              );
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  generateCachedImageCarousel(movieData.backdropPath),
                                  SizedBox(
                                    height: getScreenHeight() * 0.01
                                  ),
                                  Text(
                                    movieData.title,
                                    style: TextStyle(
                                      fontSize: defaultTextFontSize * 0.9,
                                      fontWeight: FontWeight.w500
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ]
                              )
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ]
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: defaultHorizontalPadding,
                  right: defaultHorizontalPadding,
                  top: defaultVerticalPadding * 5,
                  bottom: defaultVerticalPadding / 4 
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(labels[i], style: TextStyle(
                      fontSize: defaultTextFontSize * 1.15,
                      fontWeight: FontWeight.w600
                    )),
                    InkWell(
                      splashFactory: InkRipple.splashFactory,
                      onTap: (){
                        delayNavigationPush(
                          context, 
                          ViewMoviesList(urlParam: urlParams[i])
                        );
                      },
                      child: const Icon(Icons.arrow_right, size: 35)
                    )
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: min(5, lists[i].length),
                itemBuilder: (context, x){
                  if(appStateRepo.globalMovies[lists[i][x]] == null){
                    return Container();
                  }
                  return ValueListenableBuilder(
                    valueListenable: appStateRepo.globalMovies[lists[i][x]]!.notifier,
                    builder: (context, movieData, child){
                      return CustomBasicMovieDisplay(
                        movieData: movieData, 
                        skeletonMode: false
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      );
    }else{
      return ListView.builder(
        itemCount: lists.length,
        itemBuilder: (context, i){
          if(i == 0){
            return shimmerSkeletonWidget(
              SizedBox(
                height: getScreenHeight() * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: getScreenHeight() * 0.3,
                      color: Colors.grey,
                      width: double.infinity
                    ),
                  ]
                ),
              )
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: defaultHorizontalPadding,
                  right: defaultHorizontalPadding,
                  top: defaultVerticalPadding * 5,
                  bottom: defaultVerticalPadding / 4 
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(labels[i], style: TextStyle(
                      fontSize: defaultTextFontSize * 1.15,
                      fontWeight: FontWeight.w600
                    )),
                    const Icon(Icons.arrow_right, size: 35)
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: shimmerDefaultLength,
                itemBuilder: (context, x){
                  return shimmerSkeletonWidget(
                    CustomBasicMovieDisplay(
                      movieData: MovieDataClass.generateNewInstance(0), 
                      skeletonMode: true
                    )
                  );
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}