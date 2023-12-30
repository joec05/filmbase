import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_library.dart';
import 'package:filmbase/class/collection_data_class.dart';
import 'package:filmbase/styles/app_styles.dart';
import 'package:filmbase/view_collection_details.dart';

class CustomCollectionDisplay extends StatefulWidget {
  final CollectionDataClass collectionData;
  final bool skeletonMode;

  const CustomCollectionDisplay({
    super.key,
    required this.collectionData,
    required this.skeletonMode
  });

  @override
  State<CustomCollectionDisplay> createState() => CustomCollectionDisplayState();
}

class CustomCollectionDisplayState extends State<CustomCollectionDisplay>{
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
      return InkWell(
        splashFactory: InkRipple.splashFactory,
        onTap: (){
          delayNavigationPush(
            context, 
            ViewCollectionDetails(
              collectionID: collectionData.id
            )
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
                child: generateCachedImage(collectionData.cover)
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
                              collectionData.name, 
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