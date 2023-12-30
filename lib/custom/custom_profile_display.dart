
import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_library.dart';
import 'package:filmbase/class/user_account_details_class.dart';
import 'package:filmbase/extensions/string_ellipsis.dart';
import 'package:filmbase/styles/app_styles.dart';

class CustomProfileDisplay extends StatefulWidget {
  final UserAccountDetailsClass userData;
  final bool skeletonMode;

  const CustomProfileDisplay({
    super.key,
    required this.userData,
    required this.skeletonMode
  });

  @override
  State<CustomProfileDisplay> createState() => CustomBasicMovieDisplayState();
}

class CustomBasicMovieDisplayState extends State<CustomProfileDisplay>{
  late UserAccountDetailsClass userData;

  @override
  void initState(){
    super.initState();
    userData = widget.userData;
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    if(!widget.skeletonMode){
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: getScreenWidth() * 0.125,
                height:  getScreenWidth() * 0.125,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                  image: userData.cover != null ? 
                    DecorationImage(
                      image: NetworkImage('$imageAccessUrl${userData.cover}'),
                      fit: BoxFit.fill,
                      onError: (exception, stackTrace) => itemNoImage,
                    )
                  :
                    const DecorationImage(
                      image: AssetImage('assets/images/unknown-item.png'), 
                      fit: BoxFit.fill
                    ),
                  color: userData.cover == null ? Colors.red : Colors.transparent
                ),
              ),
              SizedBox(
                width: getScreenWidth() * 0.04
              ),
              Text(
                StringEllipsis.convertToEllipsis(userData.username), 
                style: TextStyle(
                  fontSize: defaultTextFontSize * 0.9,
                  fontWeight: FontWeight.w500
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis
              )
            ],
          ),
        ]
      );
    }else{
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: (getScreenWidth() * 0.125) / 2,
                backgroundColor: Colors.grey,
              ),
              SizedBox(
                width: getScreenWidth() * 0.04
              ),
              Flexible(
                child: Container(
                  height:  getScreenWidth() * 0.1,
                  color: Colors.grey
                ),
              )
            ],
          ),
        ]
      );
    }
  }
}