import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class CustomListDisplay extends StatefulWidget {
  final ListDataClass listData;
  final bool skeletonMode;

  const CustomListDisplay({
    super.key,
    required this.listData,
    required this.skeletonMode
  });

  @override
  State<CustomListDisplay> createState() => CustomListDisplayState();
}

class CustomListDisplayState extends State<CustomListDisplay>{
  late ListDataClass listData;

  @override
  void initState(){
    super.initState();
    listData = widget.listData;
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
            ViewListDetails(
              listID: listData.id
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
                child: generateCachedImage(listData.cover)
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
                              listData.name, 
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
                            '${listData.type[0].toUpperCase()}${listData.type.substring(1)}', 
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