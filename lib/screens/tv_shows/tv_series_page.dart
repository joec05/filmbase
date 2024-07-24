import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class TvSeriesPage extends StatelessWidget {
  const TvSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TvSeriesPageStateful();
  }
}

class _TvSeriesPageStateful extends StatefulWidget {
  const _TvSeriesPageStateful();

  @override
  State<_TvSeriesPageStateful> createState() => _TvSeriesPageStatefulState();
}

class _TvSeriesPageStatefulState extends State<_TvSeriesPageStateful> with AutomaticKeepAliveClientMixin{
  late TvSeriesController controller;

  @override
  void initState(){
    super.initState();
    controller = TvSeriesController(context);
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
        controller.airingToday,
        controller.popular,
        controller.topRated,
        controller.onAir
      ]),
      builder: (context, child) {
        
        List<List<int>> lists = [
          controller.trending.value,
          controller.airingToday.value,
          controller.popular.value,
          controller.topRated.value,
          controller.onAir.value
        ];
        List<String> labels = [
          '',
          'Airing Today',
          'Popular',
          'Top Rated',
          'On Air'
        ];
        List urlParams = [
          '',
          'airing_today',
          'popular',
          'top_rated',
          'on_the_air'
        ];
        bool isLoading = controller.isLoading.value;

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
                              TvSeriesDataClass tvShowData = appStateRepo.globalTvSeries[lists[i][x]]!.notifier.value;
                              return InkWell(
                                splashFactory: InkSplash.splashFactory,
                                onTap: (){
                                  router.pushNamed('view-tv-show-details', pathParameters: {'tvShowID': tvShowData.id.toString()});
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      generateCachedImageCarousel(tvShowData.backdropPath),
                                      SizedBox(
                                        height: getScreenHeight() * 0.01
                                      ),
                                      Text(
                                        tvShowData.title,
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
                            router.pushNamed('view-tv-shows-list', pathParameters: {'urlParam': urlParams[i]});
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
                      if(appStateRepo.globalTvSeries[lists[i][x]] == null){
                        return Container();
                      }
                      return ValueListenableBuilder(
                        valueListenable: appStateRepo.globalTvSeries[lists[i][x]]!.notifier,
                        builder: (context, tvSeriesData, child){
                          return CustomBasicTvSeriesDisplay(
                            tvSeriesData: tvSeriesData, 
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
                        )
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
                        CustomBasicTvSeriesDisplay(
                          tvSeriesData: TvSeriesDataClass.generateNewInstance(-1), 
                          skeletonMode: true
                        ),
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