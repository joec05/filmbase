import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_library.dart';
import 'package:filmbase/class/people_data_class.dart';
import 'package:filmbase/styles/app_styles.dart';
import 'package:filmbase/view_people_details.dart';

class CustomBasicPeopleDisplay extends StatefulWidget {
  final PeopleDataClass peopleData;
  final bool skeletonMode;

  const CustomBasicPeopleDisplay({
    super.key,
    required this.peopleData,
    required this.skeletonMode
  });

  @override
  State<CustomBasicPeopleDisplay> createState() => CustomBasicPeopleDisplayState();
}

class CustomBasicPeopleDisplayState extends State<CustomBasicPeopleDisplay>{
  late PeopleDataClass peopleData;

  @override
  void initState(){
    super.initState();
    peopleData = widget.peopleData;
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
            ViewPeopleDetails(
              personID: peopleData.id
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
                child: generateCachedImage(peopleData.cover)
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
                              peopleData.name, 
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
                      Text(
                        peopleData.knownForDepartment, 
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