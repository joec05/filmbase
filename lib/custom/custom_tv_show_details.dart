import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:filmbase/appdata/global_library.dart';
import 'package:filmbase/class/item_review_class.dart';
import 'package:filmbase/class/tv_series_data_class.dart';
import 'package:filmbase/custom/custom_basic_cover_display.dart';
import 'package:filmbase/custom/custom_basic_row_display.dart';
import 'package:filmbase/custom/custom_button.dart';
import 'package:filmbase/custom/custom_review_display.dart';
import 'package:filmbase/state/main.dart';
import 'package:filmbase/styles/app_styles.dart';
import 'package:filmbase/view_people_details.dart';
import 'package:filmbase/view_season_details.dart';
import 'package:filmbase/view_tv_show_details.dart';
import 'package:readmore/readmore.dart';

class CustomTvShowDetails extends StatefulWidget {
  final TvSeriesDataClass tvShowData;
  final bool skeletonMode;

  const CustomTvShowDetails({
    super.key,
    required this.tvShowData,
    required this.skeletonMode
  });

  @override
  State<CustomTvShowDetails> createState() => CustomTvShowDetailsState();
}

class CustomTvShowDetailsState extends State<CustomTvShowDetails>{
  late TvSeriesDataClass tvShowData;

  @override
  void initState(){
    super.initState();
    tvShowData = widget.tvShowData;
  }

  @override
  void dispose(){
    super.dispose();
  }

  void modifyUserTvSeriesData(){
    TextEditingController ratingController = TextEditingController(
      text: tvShowData.userTvSeriesStatus.score.toString()
    );
    bool favourite = tvShowData.userTvSeriesStatus.favourite;
    bool watchlist = tvShowData.userTvSeriesStatus.watchlisted;
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulBuilderContext, setState){
            return AlertDialog(
              titlePadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.015, horizontal: getScreenWidth() * 0.035),
              contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
              title: const Text('Edit', textAlign: TextAlign.center,),
              content: Padding(
                padding: EdgeInsets.symmetric(horizontal: getScreenWidth() * 0.035),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Score'),
                    TextField(
                      readOnly: true,
                      controller: ratingController,
                      maxLines: 1,
                      maxLength: 2,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        contentPadding: EdgeInsets.symmetric(vertical: getScreenHeight() * 0.02, horizontal: getScreenWidth() * 0.02),
                        fillColor: Colors.brown.withOpacity(0.35),
                        filled: true,
                        hintText: '',
                        prefixIcon: TextButton(
                          onPressed: (){
                            setState((){
                              ratingController.text = max(0, double.parse(ratingController.text) - 0.5).toString();
                            });
                          },
                          child: const Icon(
                            FontAwesomeIcons.minus, 
                            size: 17.5, 
                          )
                        ),
                        suffixIcon: TextButton(
                          onPressed: (){
                            setState((){
                              ratingController.text = min(10, double.parse(ratingController.text) + 0.5).toString();
                            });
                          },
                          child: const Icon(
                            FontAwesomeIcons.plus, 
                            size: 17.5, 
                          )
                        ),
                        constraints: BoxConstraints(
                          maxWidth: getScreenWidth() * 0.75,
                          maxHeight: getScreenHeight() * 0.07,
                        ),
                      )
                    ),
                    Row(
                      children: [
                        const Text('Favourite'),
                        Checkbox(
                          value: favourite, 
                          onChanged: (value) => setState(() => favourite = !favourite),
                        )
                      ]
                    ),
                    Row(
                      children: [
                        const Text('Watchlist'),
                        Checkbox(
                          value: watchlist, 
                          onChanged: (value) => setState(() => watchlist = !watchlist),
                        )
                      ]
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          width: getScreenWidth() * 0.65, 
                          height: getScreenHeight() * 0.065, 
                          buttonColor: Colors.orange,
                          buttonText: 'Update', 
                          onTapped: (){
                            updateUserTvSeriesData(
                              tvShowData.id, 
                              ratingController.text, 
                              favourite, 
                              watchlist
                            );
                            if(mounted){
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Successfully updated')
                              ));
                            }
                          },
                          setBorderRadius: true
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getScreenHeight() * 0.025
                    )
                  ]
                ),
              )
            );
          }
        );
      }
    );
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
            SizedBox(
              height: getScreenHeight() * 0.075,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    tvShowData.title, 
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
                    color: Colors.orange.withOpacity(0.4),
                    borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  child: Text(getTvShowStatus(tvShowData.status))
                ),
              ],
            ),
            SizedBox(height: getScreenHeight() * 0.02),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: detailDisplayCoverSize.width,
                  height: detailDisplayCoverSize.height,
                  child: generateCachedImage(tvShowData.cover),
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
                              tvShowData.voteAverage == null ? '? %' : '${(tvShowData.voteAverage! * 10).toInt()}%',
                              style: TextStyle(
                                fontSize: defaultTextFontSize * 1.75,
                                fontWeight: FontWeight.w700
                              )
                            ),
                            Text(
                              tvShowData.voteCount == null ? '? users' : ' from ${tvShowData.voteCount!} users',
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
                        InkWell(
                          splashFactory: InkRipple.splashFactory,
                          onTap: () => modifyUserTvSeriesData(),
                          child: Container(
                            padding: const EdgeInsets.all(7.5),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.8),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            child: const Icon(Icons.edit, size: 25)
                          ),
                        ),
                        SizedBox(
                          height: getScreenHeight() * 0.0175,
                        ),
                        Text(
                          '${tvShowData.seasonsNum} seasons / ${tvShowData.episodesNum} episodes',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: defaultTextFontSize * 0.9
                          )
                        )
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
              tvShowData.overview,
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
                  'Original Title',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                Text(
                  tvShowData.originalTitle,
                  style: TextStyle(
                    fontSize: defaultTextFontSize * 0.9,
                    fontWeight: FontWeight.w400
                  )
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Origin',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      SizedBox(
                        height: getScreenHeight() * 0.005,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for(int i = 0; i < tvShowData.originCountries.length; i++)
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                              horizontal: getScreenWidth() * 0.025,
                              vertical: getScreenHeight() * 0.0075,
                            ),
                            margin: EdgeInsets.only(
                              right: getScreenHeight() * 0.0075
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.4),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            child: Text(tvShowData.originCountries[i])
                          )
                        ]
                      )
                    ]
                  )
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Start Date',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                Text(
                  tvShowData.firstAirDate.isEmpty ? '?' : getFullDateDescription(tvShowData.firstAirDate),
                  style: TextStyle(
                    fontSize: defaultTextFontSize * 0.9,
                    fontWeight: FontWeight.w400
                  )
                ),
              ],
            ),
            getTvShowStatus(tvShowData.status) == 'Ongoing' ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getScreenHeight() * 0.035,
                  ),
                  Text(
                    'Latest Release Date',
                    style: TextStyle(
                      fontSize: defaultTextFontSize,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  SizedBox(
                    height: getScreenHeight() * 0.005,
                  ),
                  Text(
                    tvShowData.lastAirDate == null ? '?' : getFullDateDescription(tvShowData.lastAirDate!),
                    style: TextStyle(
                      fontSize: defaultTextFontSize * 0.9,
                      fontWeight: FontWeight.w400
                    )
                  ),
                ],
              )
            :
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getScreenHeight() * 0.035,
                  ),
                  Text(
                    'Last Episode Date',
                    style: TextStyle(
                      fontSize: defaultTextFontSize,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  SizedBox(
                    height: getScreenHeight() * 0.005,
                  ),
                  Text(
                    tvShowData.lastAirDate == null ? '?' : tvShowData.lastAirDate!.isNotEmpty ? getFullDateDescription(tvShowData.lastAirDate!) : '?',
                    style: TextStyle(
                      fontSize: defaultTextFontSize * 0.9,
                      fontWeight: FontWeight.w400
                    )
                  ),
                ],
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Runtime',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                Text(
                  '${tvShowData.episodeRunTime.isEmpty ? '?' : tvShowData.episodeRunTime[0]} minutes',
                  style: TextStyle(
                    fontSize: defaultTextFontSize * 0.9,
                    fontWeight: FontWeight.w400
                  )
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Ratings',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      SizedBox(
                        height: getScreenHeight() * 0.005,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for(int i = 0; i < tvShowData.ratings.length; i++)
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                              horizontal: getScreenWidth() * 0.025,
                              vertical: getScreenHeight() * 0.0075,
                            ),
                            margin: EdgeInsets.only(
                              right: getScreenHeight() * 0.0075
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.4),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            child: Text(tvShowData.ratings[i])
                          )
                        ]
                      )
                    ]
                  )
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Languages',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      SizedBox(
                        height: getScreenHeight() * 0.005,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for(int i = 0; i < tvShowData.spokenLanguages.length; i++)
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                              horizontal: getScreenWidth() * 0.025,
                              vertical: getScreenHeight() * 0.0075,
                            ),
                            margin: EdgeInsets.only(
                              right: getScreenHeight() * 0.0075
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.4),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            child: Text(tvShowData.spokenLanguages[i])
                          )
                        ]
                      )
                    ]
                  )
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Genres',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      SizedBox(
                        height: getScreenHeight() * 0.005,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for(int i = 0; i < tvShowData.genres.length; i++)
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                              horizontal: getScreenWidth() * 0.025,
                              vertical: getScreenHeight() * 0.0075,
                            ),
                            margin: EdgeInsets.only(
                              right: getScreenHeight() * 0.0075
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.4),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            child: Text(appStateClass.globalTvSeriesGenres[tvShowData.genres[i]] ?? 'null')
                          )
                        ]
                      ),
                    ],
                  )
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Keywords',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      SizedBox(
                        height: getScreenHeight() * 0.005,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for(int i = 0; i < tvShowData.keywords.length; i++)
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                              horizontal: getScreenWidth() * 0.025,
                              vertical: getScreenHeight() * 0.0075,
                            ),
                            margin: EdgeInsets.only(
                              right: getScreenHeight() * 0.0075
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.4),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            child: Text(tvShowData.keywords[i])
                          )
                        ]
                      ),
                    ],
                  )
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Networks',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      SizedBox(
                        height: getScreenHeight() * 0.005,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for(int i = 0; i < tvShowData.networks.length; i++)
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                              horizontal: getScreenWidth() * 0.025,
                              vertical: getScreenHeight() * 0.0075,
                            ),
                            margin: EdgeInsets.only(
                              right: getScreenHeight() * 0.0075
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.4),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            child: Text(tvShowData.networks[i].name)
                          )
                        ]
                      ),
                    ],
                  )
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Produced By',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      SizedBox(
                        height: getScreenHeight() * 0.005,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for(int i = 0; i < tvShowData.productionCompanies.length; i++)
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                              horizontal: getScreenWidth() * 0.025,
                              vertical: getScreenHeight() * 0.0075,
                            ),
                            margin: EdgeInsets.only(
                              right: getScreenHeight() * 0.0075
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.4),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            child: Text(tvShowData.productionCompanies[i].name)
                          )
                        ]
                      )
                    ]
                  )
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Produced At',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      SizedBox(
                        height: getScreenHeight() * 0.005,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for(int i = 0; i < tvShowData.productionCountries.length; i++)
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(
                              horizontal: getScreenWidth() * 0.025,
                              vertical: getScreenHeight() * 0.0075,
                            ),
                            margin: EdgeInsets.only(
                              right: getScreenHeight() * 0.0075
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.4),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            child: Text(tvShowData.productionCountries[i])
                          )
                        ]
                      )
                    ]
                  )
                )
              ],
            ),
            tvShowData.seasons.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Seasons',
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
                  height: tvShowData.seasons.length >= 5 ? basicRowDisplayWidgetSize.height * 5 : basicRowDisplayWidgetSize.height * tvShowData.seasons.length,
                  child: GridView(
                    scrollDirection: Axis.horizontal,
                    physics: const PageScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: getScreenWidth() * 0.025,
                      crossAxisSpacing: getScreenHeight() * 0.01,
                      crossAxisCount: min(tvShowData.seasons.length, 5),
                      childAspectRatio: 0.275
                    ),
                    children: [
                      for(int i = 0; i < tvShowData.seasons.length; i++)
                      CustomBasicRowDisplay(
                        image: generateCachedImage(tvShowData.seasons[i].cover),
                        text: tvShowData.seasons[i].name, 
                        onPressed: (){
                          delayNavigationPush(
                            context, 
                            ViewSeasonDetails(
                              showID: tvShowData.id,
                              seasonNum: tvShowData.seasons[i].seasonNum
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
            tvShowData.creators.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Created By',
                  style: TextStyle(
                    fontSize: defaultTextFontSize * 1.1,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.01,
                ),
                SizedBox(
                  height: basicCoverDisplayWidgetSize.height * 0.9,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tvShowData.creators.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(tvShowData.creators[i].cover),
                        text: tvShowData.creators[i].name, 
                        onPressed: (){
                          delayNavigationPush(
                            context, 
                            ViewPeopleDetails(
                              personID: tvShowData.creators[i].id
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
            tvShowData.credits.casts.isEmpty ? Container() : Column(
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
                    itemCount: tvShowData.credits.casts.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(tvShowData.credits.casts[i].cover),
                        text: tvShowData.credits.casts[i].name, 
                        description: tvShowData.credits.casts[i].character,
                        onPressed: (){
                          delayNavigationPush(
                            context, 
                            ViewPeopleDetails(
                              personID: tvShowData.credits.casts[i].id
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
            tvShowData.credits.crews.isEmpty ? Container() : Column(
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
                    itemCount: tvShowData.credits.crews.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(tvShowData.credits.crews[i].cover),
                        text: tvShowData.credits.crews[i].name, 
                        description: tvShowData.credits.crews[i].job,
                        onPressed: (){
                          delayNavigationPush(
                            context, 
                            ViewPeopleDetails(
                              personID: tvShowData.credits.crews[i].id
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
            tvShowData.images.backdrops.isEmpty ? Container() : Column(
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
                    itemCount: tvShowData.images.backdrops.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(tvShowData.images.backdrops[i].url),
                        text: '', 
                        onPressed: (){},
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            tvShowData.images.logos.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Logos',
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
                    itemCount: tvShowData.images.logos.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(tvShowData.images.logos[i].url),
                        text: '', 
                        onPressed: (){},
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            tvShowData.images.posters.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Posters',
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
                    itemCount: tvShowData.images.posters.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(tvShowData.images.posters[i].url),
                        text: '', 
                        onPressed: (){},
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            tvShowData.similar.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Similar',
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
                    itemCount: tvShowData.similar.length,
                    itemBuilder: (context, i){
                      TvSeriesDataClass data = appStateClass.globalTvSeries[tvShowData.similar[i]]!.notifier.value;
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(data.cover),
                        text: data.title, 
                        onPressed: (){
                          delayNavigationPush(
                            context, 
                            ViewTvShowDetails(
                              tvShowID: tvShowData.similar[i],
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
            tvShowData.recommendations.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Recommendations',
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
                    itemCount: tvShowData.recommendations.length,
                    itemBuilder: (context, i){
                      TvSeriesDataClass data = appStateClass.globalTvSeries[tvShowData.recommendations[i]]!.notifier.value;
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(data.cover),
                        text: data.title, 
                        onPressed: (){
                          delayNavigationPush(
                            context, 
                            ViewTvShowDetails(
                              tvShowID: tvShowData.recommendations[i],
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
            tvShowData.reviews.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: defaultTextFontSize * 1.1,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.01,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tvShowData.reviews.length,
                  itemBuilder: (context, i){
                    return CustomReviewDisplay(
                      reviewData: tvShowData.reviews[i],
                      skeletonMode: false
                    );
                  }
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
              ],
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

            for(int i = 0; i < 12; i++)
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

            for(int i = 0; i < 3; i++)
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

            for(int i = 0; i < 3; i++)
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
                  height: getScreenHeight() * 0.045,
                ),
                SizedBox(
                  height: getScreenHeight() * 0.01,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: shimmerDefaultLength,
                  itemBuilder: (context, i){
                    return CustomReviewDisplay(
                      reviewData: ItemReviewClass.generateNewInstance(),
                      skeletonMode: true
                    );
                  }
                ),
              ]
            ),
          ],
        ),
      );
    }
  }
}