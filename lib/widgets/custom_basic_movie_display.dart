import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class CustomBasicMovieDisplay extends StatefulWidget {
  final MovieDataClass movieData;
  final bool skeletonMode;

  const CustomBasicMovieDisplay({
    super.key,
    required this.movieData,
    required this.skeletonMode
  });

  @override
  State<CustomBasicMovieDisplay> createState() => CustomBasicMovieDisplayState();
}

class CustomBasicMovieDisplayState extends State<CustomBasicMovieDisplay>{
  late MovieDataClass movieData;

  @override
  void initState(){
    super.initState();
    movieData = widget.movieData;
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
          delayNavigationPush(
            context, 
            ViewMovieDetails(movieID: movieData.id)
          );
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
                child: generateCachedImage(movieData.cover)
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
                              movieData.title, 
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
                            movieData.releaseDate != null ? movieData.releaseDate!.split('-')[0] : 'null', 
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
                              StringEllipsis.convertToEllipsis(movieData.genres.map((e) => appStateRepo.globalMovieGenres[e]).toList().join(', ')), 
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