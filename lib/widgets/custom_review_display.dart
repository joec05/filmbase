import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class CustomReviewDisplay extends StatefulWidget {
  final ItemReviewClass reviewData;
  final bool skeletonMode;

  const CustomReviewDisplay({
    super.key,
    required this.reviewData,
    required this.skeletonMode
  });

  @override
  State<CustomReviewDisplay> createState() => CustomReviewDisplayState();
}

class CustomReviewDisplayState extends State<CustomReviewDisplay>{
  late ItemReviewClass reviewData;

  @override
  void initState(){
    super.initState();
    reviewData = widget.reviewData;
  }

  @override
  void dispose(){
    super.dispose();
  }

  void openReviewInFull(){
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulBuilderContext, setState){
            return AlertDialog(
              titlePadding: EdgeInsets.only(top: getScreenHeight() * 0.025),
              contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
              content: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding * 1.5,
                  vertical: defaultVerticalPadding * 2
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: getScreenWidth() * 0.125,
                            height: getScreenWidth() * 0.125,
                            child: generateCachedImage(reviewData.cover)
                          ),
                          SizedBox(
                            width: getScreenWidth() * 0.035
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reviewData.username, 
                                style: TextStyle(
                                  fontSize: defaultTextFontSize * 0.925,
                                  fontWeight: FontWeight.w600
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 20),
                                  Text(
                                    '${reviewData.score ?? '?'}',
                                    style: TextStyle(
                                      fontSize: defaultTextFontSize * 0.85
                                    )
                                  ),
                                  SizedBox(
                                    width: getScreenWidth() * 0.015
                                  ),
                                  const Text('-'),
                                  SizedBox(
                                    width: getScreenWidth() * 0.015
                                  ),
                                  Text(
                                    getTimeDifference(reviewData.creationTime),
                                    style: TextStyle(
                                      fontSize: defaultTextFontSize * 0.825,
                                    )
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getScreenHeight() * 0.01
                      ),
                      const Divider(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: getScreenHeight() * 0.01
                        ),
                        child: Text(
                          reviewData.content, 
                          style: TextStyle(
                            fontSize: defaultTextFontSize * 0.85,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        height: getScreenHeight() * 0.01
                      ),
                      Text(
                        'Last edited ${getTimeDifference(reviewData.updatedTime)}',
                        style: TextStyle(
                          fontSize: defaultTextFontSize * 0.825,
                          color: Colors.blueGrey
                        )
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context){
    if(!widget.skeletonMode){
      return InkWell(
        splashFactory: InkSplash.splashFactory,
        onTap: (){
          Future.delayed(const Duration(milliseconds: 300), (){
            openReviewInFull();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.45),
            borderRadius: const BorderRadius.all(Radius.circular(10))
          ),
          margin: EdgeInsets.symmetric(
            vertical: defaultVerticalPadding,
          ),
          padding: EdgeInsets.symmetric(
            vertical: defaultVerticalPadding,
            horizontal: defaultHorizontalPadding
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: getScreenWidth() * 0.125,
                height: getScreenWidth() * 0.125,
                child: generateCachedImage(reviewData.cover)
              ),
              SizedBox(
                width: getScreenWidth() * 0.035
              ),
              SizedBox(
                width: getScreenWidth() * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewData.username, 
                      style: TextStyle(
                        fontSize: defaultTextFontSize * 0.925,
                        fontWeight: FontWeight.w600
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 20),
                        Text(
                          '${reviewData.score ?? '?'}',
                          style: TextStyle(
                            fontSize: defaultTextFontSize * 0.85
                          )
                        ),
                        SizedBox(
                          width: getScreenWidth() * 0.015
                        ),
                        const Text('-'),
                        SizedBox(
                          width: getScreenWidth() * 0.015
                        ),
                        Text(
                          getTimeDifference(reviewData.creationTime),
                          style: TextStyle(
                            fontSize: defaultTextFontSize * 0.825,
                          )
                        )
                      ],
                    ),
                    SizedBox(
                      height: getScreenHeight() * 0.02
                    ),
                    Text(
                      reviewData.content, 
                      style: TextStyle(
                        fontSize: defaultTextFontSize * 0.85,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }else{
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.65),
          borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        margin: EdgeInsets.symmetric(
          vertical: defaultVerticalPadding,
        ),
        padding: EdgeInsets.symmetric(
          vertical: defaultVerticalPadding,
          horizontal: defaultHorizontalPadding
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: getScreenWidth() * 0.125,
              height: getScreenWidth() * 0.125,
              color: Colors.grey
            ),
            SizedBox(
              width: getScreenWidth() * 0.035
            ),
            Container(
              width: getScreenWidth() * 0.75,
              height: getScreenHeight() * 0.2,
              color: Colors.grey
            ),
          ],
        ),
      );
    }
  }
}