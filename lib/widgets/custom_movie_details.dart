import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:filmbase/global_files.dart';
import 'package:readmore/readmore.dart';

class CustomMovieDetails extends StatefulWidget {
  final MovieDataClass movieData;
  final bool skeletonMode;

  const CustomMovieDetails({
    super.key,
    required this.movieData,
    required this.skeletonMode
  });

  @override
  State<CustomMovieDetails> createState() => CustomMovieDetailsState();
}

class CustomMovieDetailsState extends State<CustomMovieDetails>{
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

  void modifyUserMovieData(){
    TextEditingController ratingController = TextEditingController(
      text: max(0.5, movieData.userMovieStatus.score).toString()
    );
    bool favourite = movieData.userMovieStatus.favourite;
    bool watchlist = movieData.userMovieStatus.watchlisted;
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
                            apiCallRepo.updateUserMovieData(
                              movieData.id, 
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
            Column(
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.075,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        movieData.title, 
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
                      child: Text(movieData.status)
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  movieData.voteAverage == null ? '? %' : '${(movieData.voteAverage! * 10).toInt()}%',
                                  style: TextStyle(
                                    fontSize: defaultTextFontSize * 1.75,
                                    fontWeight: FontWeight.w700
                                  )
                                ),
                                Text(
                                  movieData.voteCount == null ? '? users' : ' from ${movieData.voteCount!} users',
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
                              onTap: () => modifyUserMovieData(),
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
              ],
            ),
            ReadMoreText(
              movieData.overview,
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
                  movieData.originalTitle,
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
                  'Release Date',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                Text(
                  movieData.releaseDate == null ? '?' : getFullDateDescription(movieData.releaseDate!),
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
                  '${movieData.runtime} minutes',
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
                          for(int i = 0; i < movieData.spokenLanguages.length; i++)
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
                            child: Text(movieData.spokenLanguages[i])
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
                  'Budget',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                Text(
                  '${(movieData.budget / 1000000).toStringAsFixed(1)} million',
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
                  'Revenue',
                  style: TextStyle(
                    fontSize: defaultTextFontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
                SizedBox(
                  height: getScreenHeight() * 0.005,
                ),
                Text(
                  '${(movieData.revenue / 1000000).toStringAsFixed(1)} million',
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
                          for(int i = 0; i < movieData.genres.length; i++)
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
                            child: Text(appStateRepo.globalMovieGenres[movieData.genres[i]] ?? 'null')
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
                          for(int i = 0; i < movieData.keywords.length; i++)
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
                            child: Text(movieData.keywords[i])
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
                          for(int i = 0; i < movieData.productionCompanies.length; i++)
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
                            child: Text(movieData.productionCompanies[i].name)
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
                          for(int i = 0; i < movieData.productionCountries.length; i++)
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
                            child: Text(movieData.productionCountries[i])
                          )
                        ]
                      )
                    ]
                  )
                )
              ],
            ),
            movieData.credits.casts.isEmpty ? Container() : Column(
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
                    itemCount: movieData.credits.casts.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(movieData.credits.casts[i].cover),
                        text: movieData.credits.casts[i].name, 
                        description: movieData.credits.casts[i].character,
                        onPressed: (){
                          router.pushNamed('view-people-details', pathParameters: {'personID': movieData.credits.casts[i].toString()});
                        },
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            movieData.credits.crews.isEmpty ? Container() : Column(
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
                    itemCount: movieData.credits.crews.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(movieData.credits.crews[i].cover),
                        text: movieData.credits.crews[i].name, 
                        description: movieData.credits.crews[i].job,
                        onPressed: (){
                          router.pushNamed('view-people-details', pathParameters: {'personID': movieData.credits.crews[i].id.toString()});
                        },
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            movieData.images.backdrops.isEmpty ? Container() : Column(
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
                    itemCount: movieData.images.backdrops.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(movieData.images.backdrops[i].url),
                        text: '', 
                        onPressed: (){},
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            movieData.images.logos.isEmpty ? Container() : Column(
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
                    itemCount: movieData.images.logos.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(movieData.images.logos[i].url),
                        text: '', 
                        onPressed: (){},
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            movieData.images.posters.isEmpty ? Container() : Column(
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
                    itemCount: movieData.images.posters.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(movieData.images.posters[i].url),
                        text: '', 
                        onPressed: (){},
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            movieData.collection == null ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Collection',
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
                  child: CustomBasicCoverDisplay(
                    image: generateCachedImage(movieData.collection!.cover),
                    text: movieData.collection!.name, 
                    onPressed: (){
                      router.pushNamed('view-collection-details', pathParameters: {'collectionID': movieData.collection!.id.toString()});
                    },
                    skeletonMode: false
                  )
                ),
              ],
            ),
            movieData.lists.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: getScreenHeight() * 0.035,
                ),
                Text(
                  'Lists',
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
                    itemCount: movieData.lists.length,
                    itemBuilder: (context, i){
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(movieData.lists[i].cover),
                        text: movieData.lists[i].name,
                        onPressed: (){
                          router.pushNamed('view-list-details', pathParameters: {'listID': movieData.lists[i].id.toString()});
                        },
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            movieData.similar.isEmpty ? Container() : Column(
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
                    itemCount: movieData.similar.length,
                    itemBuilder: (context, i){
                      MovieDataClass data = appStateRepo.globalMovies[movieData.similar[i]]!.notifier.value;
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(data.cover),
                        text: data.title, 
                        onPressed: (){
                          router.pushNamed('view-movie-details', pathParameters: {'movieID': movieData.similar[i].toString()});
                        },
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            movieData.recommendations.isEmpty ? Container() : Column(
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
                    itemCount: movieData.recommendations.length,
                    itemBuilder: (context, i){
                      MovieDataClass data = appStateRepo.globalMovies[movieData.recommendations[i]]!.notifier.value;
                      return CustomBasicCoverDisplay(
                        image: generateCachedImage(data.cover),
                        text: data.title, 
                        onPressed: (){
                          router.pushNamed('view-movie-details', pathParameters: {'movieID': movieData.recommendations[i].toString()});
                        },
                        skeletonMode: false
                      );
                    }
                  ),
                ),
              ],
            ),
            movieData.reviews.isEmpty ? Container() : Column(
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
                  itemCount: movieData.reviews.length,
                  itemBuilder: (context, i){
                    return CustomReviewDisplay(
                      reviewData: movieData.reviews[i],
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
            
            for(int i = 0; i < 10; i++)
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
            
            for(int i = 0; i < 4; i++)
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