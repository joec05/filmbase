import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_library.dart';
import 'package:filmbase/class/people_data_class.dart';
import 'package:filmbase/custom/custom_basic_cover_display.dart';
import 'package:filmbase/extensions/string_ellipsis.dart';
import 'package:filmbase/styles/app_styles.dart';
import 'package:filmbase/view_movie_details.dart';
import 'package:filmbase/view_tv_show_details.dart';
import 'package:readmore/readmore.dart';

class CustomPeopleDetails extends StatefulWidget {
  final PeopleDataClass peopleData;
  final bool skeletonMode;

  const CustomPeopleDetails({
    super.key,
    required this.peopleData,
    required this.skeletonMode
  });

  @override
  State<CustomPeopleDetails> createState() => CustomPeopleDetailsState();
}

class CustomPeopleDetailsState extends State<CustomPeopleDetails>{
  late PeopleDataClass peopleData;

  @override
  void initState(){
    super.initState();
    peopleData = widget.peopleData;
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    if(!widget.skeletonMode){
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: defaultHorizontalPadding,
          vertical: defaultVerticalPadding
        ),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: detailDisplayCoverSize.width,
                  height: detailDisplayCoverSize.height,
                  child: generateCachedImage(peopleData.cover)
                ),
                SizedBox(
                  width: getScreenWidth() * 0.035
                ),
                Flexible(
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                StringEllipsis.convertToEllipsis(peopleData.name), 
                                style: TextStyle(
                                  fontSize: defaultTextFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getScreenHeight() * 0.0125,
                        ),
                        Row(
                          children: [
                            Text(
                              peopleData.knownForDepartment, 
                              style: TextStyle(
                                fontSize: defaultTextFontSize * 0.8,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              width: getScreenWidth() * 0.015
                            ),
                            const Text('/'),
                            SizedBox(
                              width: getScreenWidth() * 0.015
                            ),
                            Text(
                              getGender(peopleData.gender), 
                              style: TextStyle(
                                fontSize: defaultTextFontSize * 0.8,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),  
                          ]
                        ),
                        Row(
                          children: [
                            Text(
                              peopleData.birthday == null ? '? yrs' : '${getAge(peopleData.birthday!)} yrs', 
                              style: TextStyle(
                                fontSize: defaultTextFontSize * 0.8,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ), 
                            SizedBox(
                              width: getScreenWidth() * 0.015
                            ),
                            const Text('/'),
                            SizedBox(
                              width: getScreenWidth() * 0.015
                            ), 
                            Text(
                              peopleData.deathday != null ? 'Deceased' : 'Alive', 
                              style: TextStyle(
                                fontSize: defaultTextFontSize * 0.8,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ]
                        ),
                        SizedBox(
                          height: getScreenHeight() * 0.0175,
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
              peopleData.bio,
              trimLines: 5,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'More',
              trimExpandedText: ' Less',
              moreStyle: const TextStyle(fontSize: 14, color: Colors.blue),
              lessStyle: const TextStyle(fontSize: 14, color: Colors.blue),
            ),
            peopleData.images.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Images',
                  style: TextStyle(
                    fontSize: defaultTextFontSize * 1.1,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.01,
                ),
                SizedBox(
                  height: basicCoverDisplayImageSize.height,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: peopleData.images.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(peopleData.images[i].url),
                        text: '', 
                        onPressed: (){},
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            peopleData.credits.moviesCast.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Movies as Cast',
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
                    itemCount: peopleData.credits.moviesCast.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(peopleData.credits.moviesCast[i].cover),
                        text: peopleData.credits.moviesCast[i].title, 
                        description: peopleData.credits.moviesCast[i].character,
                        onPressed: (){
                          delayNavigationPush(
                            context, 
                            ViewMovieDetails(
                              movieID: peopleData.credits.moviesCast[i].id
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
            peopleData.credits.tvShowsCast.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'TV Shows as Cast',
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
                    itemCount: peopleData.credits.tvShowsCast.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(peopleData.credits.tvShowsCast[i].cover),
                        text: peopleData.credits.tvShowsCast[i].title, 
                        description: peopleData.credits.tvShowsCast[i].character,
                        onPressed: (){
                          delayNavigationPush(
                            context, 
                            ViewTvShowDetails(
                              tvShowID: peopleData.credits.tvShowsCast[i].id
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
            peopleData.credits.moviesCrew.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Movies as Crew',
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
                    itemCount: peopleData.credits.moviesCrew.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(peopleData.credits.moviesCrew[i].cover),
                        text: peopleData.credits.moviesCrew[i].title, 
                        description: peopleData.credits.moviesCrew[i].job,
                        onPressed: (){
                          delayNavigationPush(
                            context, 
                            ViewMovieDetails(
                              movieID: peopleData.credits.moviesCrew[i].id
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
            peopleData.credits.tvShowsCrew.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Tv Shows as Crew',
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
                    itemCount: peopleData.credits.tvShowsCrew.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(peopleData.credits.tvShowsCrew[i].cover),
                        text: peopleData.credits.tvShowsCrew[i].title, 
                        description: peopleData.credits.tvShowsCrew[i].job,
                        onPressed: (){
                          delayNavigationPush(
                            context, 
                            ViewMovieDetails(
                              movieID: peopleData.credits.tvShowsCrew[i].id
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                ),
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
                  height: getScreenHeight() * 0.35,
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
                  height: getScreenHeight() * 0.425,
                ),
              ]
            ),
          ],
        ),
      );
    }
  }
}