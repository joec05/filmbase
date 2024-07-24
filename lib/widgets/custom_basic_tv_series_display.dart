import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class CustomBasicTvSeriesDisplay extends StatefulWidget {
  final TvSeriesDataClass tvSeriesData;
  final bool skeletonMode;

  const CustomBasicTvSeriesDisplay({
    super.key,
    required this.tvSeriesData,
    required this.skeletonMode
  });

  @override
  State<CustomBasicTvSeriesDisplay> createState() => CustomBasicTvSeriesDisplayState();
}

class CustomBasicTvSeriesDisplayState extends State<CustomBasicTvSeriesDisplay>{
  late TvSeriesDataClass tvSeriesData;

  @override
  void initState(){
    super.initState();
    tvSeriesData = widget.tvSeriesData;
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    if(!widget.skeletonMode){
      return InkWell(
        splashFactory: InkRipple.splashFactory,
        onTap: (){
          router.pushNamed('view-tv-show-details', pathParameters: {'tvShowID': tvSeriesData.id.toString()});
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
                child: generateCachedImage(tvSeriesData.cover)
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
                              tvSeriesData.title, 
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
                            tvSeriesData.firstAirDate.split('-')[0], 
                            style: TextStyle(
                              fontSize: defaultTextFontSize * 0.75,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            width: getScreenWidth() * 0.015
                          ),
                          const Text('-'),
                          SizedBox(
                            width: getScreenWidth() * 0.015
                          ),
                          Flexible(
                            child: Text(
                              StringEllipsis.convertToEllipsis(tvSeriesData.genres.map((e) => appStateRepo.globalTvSeriesGenres[e]).toList().join(', ')), 
                              style: TextStyle(
                                fontSize: defaultTextFontSize * 0.75,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueGrey
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis
                            ),
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