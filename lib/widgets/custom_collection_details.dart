import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';
import 'package:readmore/readmore.dart';

class CustomCollectionDetails extends StatefulWidget {
  final CollectionDataClass collectionData;
  final bool skeletonMode;

  const CustomCollectionDetails({
    super.key,
    required this.collectionData,
    required this.skeletonMode
  });

  @override
  State<CustomCollectionDetails> createState() => CustomCollectionDetailsState();
}

class CustomCollectionDetailsState extends State<CustomCollectionDetails>{
  late CollectionDataClass collectionData;

  @override
  void initState(){
    super.initState();
    collectionData = widget.collectionData;
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
                  child: generateCachedImage(collectionData.cover)
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
                                StringEllipsis.convertToEllipsis(collectionData.name), 
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
                        Text(
                          '${collectionData.movies.length} movies', 
                          style: TextStyle(
                            fontSize: defaultTextFontSize * 0.8,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${collectionData.tvShows.length} tv shows', 
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
              collectionData.overview,
              trimLines: 5,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'More',
              trimExpandedText: ' Less',
              moreStyle: const TextStyle(fontSize: 14, color: Colors.blue),
              lessStyle: const TextStyle(fontSize: 14, color: Colors.blue),
            ),
            collectionData.images.isEmpty ? Container() : Column(
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
                    itemCount: collectionData.images.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(collectionData.images[i].url),
                        text: '', 
                        onPressed: (){},
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            collectionData.movies.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Movies',
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
                    itemCount: collectionData.movies.length,
                    itemBuilder: (context, i){
                      MovieDataClass movieData = appStateRepo.globalMovies[collectionData.movies[i]]!.notifier.value;
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(movieData.cover),
                        text: movieData.title, 
                        onPressed: (){
                          router.pushNamed('view-movie-details', pathParameters: {'movieID': movieData.id.toString()});
                        },
                        skeletonMode: false
                      );
                    }
                  ),
                ),
                
              ],
            ),
            collectionData.tvShows.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Tv Shows',
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
                    itemCount: collectionData.tvShows.length,
                    itemBuilder: (context, i){
                      TvSeriesDataClass tvShowData = appStateRepo.globalTvSeries[collectionData.tvShows[i]]!.notifier.value;
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(tvShowData.cover),
                        text: tvShowData.title, 
                        onPressed: (){
                          router.pushNamed('view-tv-show-details', pathParameters: {'tvShowID': tvShowData.id.toString()});
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
            )
          ],
        ),
      );
    }
  }
}

