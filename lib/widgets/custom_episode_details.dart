import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:filmbase/global_files.dart';
import 'package:readmore/readmore.dart';

class CustomEpisodeDetails extends StatefulWidget {
  final EpisodeDataClass episodeData;
  final bool skeletonMode;

  const CustomEpisodeDetails({
    super.key,
    required this.episodeData,
    required this.skeletonMode
  });

  @override
  State<CustomEpisodeDetails> createState() => CustomEpisodeDetailsState();
}

class CustomEpisodeDetailsState extends State<CustomEpisodeDetails>{
  late EpisodeDataClass episodeData;

  @override
  void initState(){
    super.initState();
    episodeData = widget.episodeData;
  }

  @override
  void dispose(){
    super.dispose();
  }

  void modifyUserEpisodeData(){
    TextEditingController ratingController = TextEditingController(
      text: max(0.5, episodeData.rating).toString()
    );
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulBuilderContext, setState){
            return AlertDialog(
              titlePadding: EdgeInsets.only(top: getScreenHeight() * 0.025),
              contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
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
                              ratingController.text = max(0.5, double.parse(ratingController.text) - 0.5).toString();
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
                    SizedBox(
                      height: getScreenHeight() * 0.02
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
                            apiCallRepo.updateUserEpisodeData(
                              episodeData.showID, 
                              episodeData.seasonNum, 
                              episodeData.id,
                              episodeData.episodeNum, 
                              ratingController.text
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
      if(appStateRepo.globalTvSeries[episodeData.showID] == null){
        return Container();
      }
      TvSeriesDataClass tvShowData = appStateRepo.globalTvSeries[episodeData.showID]!.notifier.value;
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
                    episodeData.name, 
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
                  child: generateCachedImage(tvShowData.cover)
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
                              episodeData.voteAverage == null ? '? %' : '${(episodeData.voteAverage! * 10).toInt()}%',
                              style: TextStyle(
                                fontSize: defaultTextFontSize * 1.75,
                                fontWeight: FontWeight.w700
                              )
                            ),
                            Text(
                              episodeData.voteCount == null ? '? users' : ' from ${episodeData.voteCount!} users',
                              style: TextStyle(
                                fontSize: defaultTextFontSize * 0.85,
                                fontWeight: FontWeight.w400
                              )
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getScreenHeight() * 0.0125,
                        ),
                        Text(
                          'Season ${episodeData.seasonNum}, Episode ${episodeData.episodeNum}', 
                          style: TextStyle(
                            fontSize: defaultTextFontSize * 0.8,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            Text(
                              episodeData.airDate.split('-')[0], 
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
                              '${episodeData.runtime ?? '? '}m', 
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
                        InkWell(
                          splashFactory: InkRipple.splashFactory,
                          onTap: () => modifyUserEpisodeData(),
                          child: Container(
                            padding: const EdgeInsets.all(7.5),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.8),
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                            ),
                            child: const Icon(Icons.edit, size: 25)
                          ),
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
              episodeData.overview,
              trimLines: 5,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'More',
              trimExpandedText: ' Less',
              moreStyle: const TextStyle(fontSize: 14, color: Colors.blue),
              lessStyle: const TextStyle(fontSize: 14, color: Colors.blue),
            ),
            episodeData.images.isEmpty ? Container() : Column(
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
                    itemCount: episodeData.images.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(episodeData.images[i].url),
                        text: '', 
                        onPressed: (){},
                        skeletonMode: false,
                      );
                    }
                  ),
                ),
              ],
            ),
            episodeData.casts.isEmpty ? Container() : Column(
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
                    itemCount: episodeData.casts.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(episodeData.casts[i].cover),
                        text: episodeData.casts[i].name, 
                        onPressed: (){
                          router.pushNamed('view-people-details', pathParameters: {'personID': episodeData.casts[i].toString()});
                        },
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            episodeData.crews.isEmpty ? Container() : Column(
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
                    itemCount: episodeData.crews.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(episodeData.crews[i].cover),
                        text: episodeData.crews[i].name, 
                        onPressed: (){
                          router.pushNamed('view-people-details', pathParameters: {'personID': episodeData.crews[i].toString()});
                        },
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            episodeData.guestStars.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Guest stars',
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
                    itemCount: episodeData.guestStars.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(episodeData.guestStars[i].cover),
                        text: episodeData.guestStars[i].name, 
                        onPressed: (){
                          router.pushNamed('view-people-details', pathParameters: {'personID': episodeData.guestStars[i].toString()});
                        },
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            )
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
                  width: getScreenWidth() * 0.55,
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
          ],
        ),
      );
    }
  }
}

