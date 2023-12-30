import 'dart:math';
import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_library.dart';
import 'package:filmbase/class/season_data_class.dart';
import 'package:filmbase/class/tv_series_data_class.dart';
import 'package:filmbase/custom/custom_basic_cover_display.dart';
import 'package:filmbase/custom/custom_basic_row_display.dart';
import 'package:filmbase/state/main.dart';
import 'package:filmbase/styles/app_styles.dart';
import 'package:filmbase/view_episode_details.dart';
import 'package:filmbase/view_people_details.dart';
import 'package:readmore/readmore.dart';

class CustomSeasonDetails extends StatefulWidget {
  final SeasonDataClass seasonData;
  final bool skeletonMode;

  const CustomSeasonDetails({
    super.key,
    required this.seasonData,
    required this.skeletonMode
  });

  @override
  State<CustomSeasonDetails> createState() => CustomSeasonDetailsState();
}

class CustomSeasonDetailsState extends State<CustomSeasonDetails>{
  late SeasonDataClass seasonData;

  @override
  void initState(){
    super.initState();
    seasonData = widget.seasonData;
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    if(!widget.skeletonMode){
      TvSeriesDataClass tvShowData = appStateClass.globalTvSeries[seasonData.showID]!.notifier.value;
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: defaultHorizontalPadding,
          vertical: defaultVerticalPadding
        ),
        child: ListView(
          children: [
            SizedBox(
              height: getScreenHeight() * 0.075,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    seasonData.name, 
                    style: TextStyle(
                      fontSize: defaultTextFontSize * 1.1,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center
                  )
                )
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                    horizontal: getScreenWidth() * 0.025,
                    vertical: getScreenHeight() * 0.0075,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lime.withOpacity(0.4),
                    borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  child: Text(
                    tvShowData.title
                  )
                )
              ]
            ),
            SizedBox(height: getScreenHeight() * 0.02),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: detailDisplayCoverSize.width,
                  height: detailDisplayCoverSize.height,
                  child: generateCachedImage(seasonData.cover)
                ),
                SizedBox(
                  width: getScreenWidth() * 0.035
                ),
                Flexible(
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              seasonData.voteAverage == null ? '? %' : '${(seasonData.voteAverage! * 10).toInt()}%',
                              style: TextStyle(
                                fontSize: defaultTextFontSize * 1.75,
                                fontWeight: FontWeight.w700
                              )
                            ),
                            Text(
                              ' on average',
                              style: TextStyle(
                                fontSize: defaultTextFontSize * 0.85,
                                fontWeight: FontWeight.w400
                              )
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getScreenHeight() * 0.0175,
                        ),
                        Text(
                          '${seasonData.episodesCount} episodes', 
                          style: TextStyle(
                            fontSize: defaultTextFontSize * 0.8,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getScreenHeight() * 0.025,
            ),
            ReadMoreText(
              seasonData.overview,
              trimLines: 5,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'More',
              trimExpandedText: ' Less',
              moreStyle: const TextStyle(fontSize: 14, color: Colors.blue),
              lessStyle: const TextStyle(fontSize: 14, color: Colors.blue),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Air Date',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                Text(
                  seasonData.airDate == null ? '?' : getFullDateDescription(seasonData.airDate!),
                  style: TextStyle(
                    fontSize: defaultTextFontSize * 0.9,
                    fontWeight: FontWeight.w400
                  )
                ),
              ],
            ),
            seasonData.episodes.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Episodes',
                  style: TextStyle(
                    fontSize: defaultTextFontSize * 1.1,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.01,
                ),
                SizedBox(
                  width: double.infinity,
                  height: seasonData.episodes.length >= 10 ? basicRowDisplayWidgetSize.height * 10 : basicRowDisplayWidgetSize.height * seasonData.episodes.length,
                  child: GridView(
                    scrollDirection: Axis.horizontal,
                    physics: const PageScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: getScreenWidth() * 0.025,
                      crossAxisSpacing: getScreenHeight() * 0.01,
                      crossAxisCount: min(seasonData.episodes.length, 10),
                      childAspectRatio: 0.275
                    ),
                    children: [
                      for(int i = 0; i < seasonData.episodes.length; i++)
                      CustomBasicRowDisplay(
                        image: generateCachedImage(seasonData.cover),
                        text: seasonData.episodes[i].name, 
                        description: 'Episode ${seasonData.episodes[i].episodeNum}', 
                        onPressed: (){
                          delayNavigationPush(
                            context, 
                            ViewEpisodeDetails(
                              episodeID: seasonData.episodes[i].id, 
                              showID: tvShowData.id, 
                              seasonNum: seasonData.seasonNum, 
                              episodeNum:seasonData.episodes[i].episodeNum
                            )
                          );
                        },
                        skeletonMode: false
                      )
                    ]
                  )
                )
              ],
            ),
            seasonData.credits.casts.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Casts',
                  style: TextStyle(
                    fontSize: defaultTextFontSize * 1.1,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.01,
                ),
                SizedBox(
                  height: basicCoverDisplayWidgetSize.height,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: seasonData.credits.casts.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(seasonData.credits.casts[i].cover),
                        text: seasonData.credits.casts[i].name, 
                        description: seasonData.credits.casts[i].character,
                        onPressed: (){
                          delayNavigationPush(
                            context, 
                            ViewPeopleDetails(
                              personID: seasonData.credits.casts[i].id
                            )
                          );
                        },
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            seasonData.credits.crews.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Crews',
                  style: TextStyle(
                    fontSize: defaultTextFontSize * 1.1,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.01,
                ),
                SizedBox(
                  height: basicCoverDisplayWidgetSize.height,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: seasonData.credits.crews.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(seasonData.credits.crews[i].cover),
                        text: seasonData.credits.crews[i].name, 
                        description: seasonData.credits.crews[i].job,
                        onPressed: (){
                          delayNavigationPush(
                            context, 
                            ViewPeopleDetails(
                              personID: seasonData.credits.crews[i].id
                            )
                          );
                        },
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            seasonData.images.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Backdrops',
                  style: TextStyle(
                    fontSize: defaultTextFontSize * 1.1,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.01,
                ),
                SizedBox(
                  height: basicCoverDisplayWidgetSize.height * 0.875,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: seasonData.images.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(seasonData.images[i].url),
                        text: '', 
                        onPressed: (){},
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }else{
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: defaultHorizontalPadding,
          vertical: defaultVerticalPadding
        ),
        child: ListView(
          children: [
            SizedBox(
              height: getScreenHeight() * 0.075,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: getScreenWidth() * 0.85,
                    height: getScreenHeight() * 0.05,
                    color: Colors.grey
                  )
                )
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: getScreenWidth() * 0.4,
                  height: getScreenHeight() * 0.04,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                    horizontal: getScreenWidth() * 0.025,
                    vertical: getScreenHeight() * 0.0075,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  )
                )
              ]
            ),
            SizedBox(height: getScreenHeight() * 0.02),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: detailDisplayCoverSize.width,
                  height: detailDisplayCoverSize.height,
                  color: Colors.grey
                ),
                SizedBox(
                  width: getScreenWidth() * 0.035
                ),
                Flexible(
                  child: Container(
                    height: detailDisplayCoverSize.height,
                    color: Colors.grey
                  ),
                )
              ],
            ),
            SizedBox(
              height: getScreenHeight() * 0.025,
            ),
            Container(
              height: getScreenHeight() * 0.15,
              color: Colors.grey,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Container(
                  color: Colors.grey,
                  height: getScreenHeight() * 0.1,
                ),
              ]
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Container(
                  color: Colors.grey,
                  height: getScreenHeight() * 0.045,
                ),
                SizedBox(
                  height: getScreenHeight() * 0.01,
                ),
                SizedBox(
                  width: double.infinity,
                  height: basicRowDisplayWidgetSize.height * shimmerDefaultLength,
                  child: GridView(
                    scrollDirection: Axis.horizontal,
                    physics: const PageScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: getScreenWidth() * 0.025,
                      crossAxisSpacing: getScreenHeight() * 0.01,
                      crossAxisCount: 5,
                      childAspectRatio: 0.275
                    ),
                    children: [
                      for(int i = 0; i < shimmerDefaultLength; i++)
                      CustomBasicRowDisplay(
                        image: Image.network(''),
                        text: '', 
                        onPressed: (){},
                        skeletonMode: true
                      )
                    ]
                  )
                )
              ],
            ),
            for(int i = 0; i < 2; i++)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Container(
                  color: Colors.grey,
                  height: getScreenHeight() * 0.425,
                ),
              ]
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Container(
                  color: Colors.grey,
                  height: getScreenHeight() * 0.35,
                ),
              ]
            ),
          ],
        ),
      );
    }
  }
}