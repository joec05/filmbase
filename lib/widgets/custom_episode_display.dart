import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:filmbase/global_files.dart';

class CustomEpisodeDisplay extends StatefulWidget {
  final EpisodeDataClass episodeData;
  final bool skeletonMode;

  const CustomEpisodeDisplay({
    super.key,
    required this.episodeData,
    required this.skeletonMode
  });

  @override
  State<CustomEpisodeDisplay> createState() => CustomEpisodeDisplayState();
}

class CustomEpisodeDisplayState extends State<CustomEpisodeDisplay>{
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
      return InkWell(
        splashFactory: InkRipple.splashFactory,
        onTap: (){
          router.pushNamed('view-episode-details', pathParameters: {
            'episodeID': episodeData.id.toString(), 
            'showID': episodeData.showID.toString(), 
            'seasonNum': episodeData.seasonNum.toString(),
            'episodeNum': episodeData.episodeNum.toString()
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: defaultHorizontalPadding,
            vertical: defaultVerticalPadding
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: mediaGridDisplayCoverSize.width,
                height: mediaGridDisplayCoverSize.height,
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
                        children: [
                          Flexible(
                            child: Text(
                              episodeData.name, 
                              style: TextStyle(
                                fontSize: defaultTextFontSize * 0.85,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getScreenHeight() * 0.0075,
                      ),
                      Row(
                        children: [
                          Text(
                            '${tvShowData.title} S${episodeData.seasonNum} Ep${episodeData.episodeNum}', 
                            style: TextStyle(
                              fontSize: defaultTextFontSize * 0.75,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }else{
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: defaultHorizontalPadding,
          vertical: defaultVerticalPadding
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: mediaGridDisplayCoverSize.width,
              height: mediaGridDisplayCoverSize.height,
              color: Colors.grey
            ),
            SizedBox(
              width: getScreenWidth() * 0.035
            ),
            Flexible(
              child: Container(
                height: mediaGridDisplayCoverSize.height,
                color: Colors.grey
              ),
            )
          ],
        ),
      );
    }
  }
}