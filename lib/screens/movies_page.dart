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
  late MoviesController controller;

  @override
  void initState(){
    super.initState();
    controller = MoviesController(context);
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
        controller.trending,
        controller.nowPlaying,
        controller.popular,
        controller.topRated,
        controller.upcoming
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        List<String> labels = [
          '',
          'This Month',
          'Popular',
          'Top Rated',
          'Upcoming'
        ];
        List<List<int>> lists = [
          controller.trending.value,
          controller.nowPlaying.value,
          controller.popular.value,
          controller.topRated.value,
          controller.upcoming.value
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
                              ViewMoviesList(urlParam: controller.urlParams.value[i])
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}