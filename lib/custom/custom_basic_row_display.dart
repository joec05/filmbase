
import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_library.dart';
import 'package:filmbase/styles/app_styles.dart';

class CustomBasicRowDisplay extends StatefulWidget {
  final Widget image;
  final String text;
  final Function() onPressed;
  final dynamic description;
  final bool skeletonMode;

  const CustomBasicRowDisplay({
    super.key,
    required this.image,
    required this.text,
    required this.onPressed,
    this.description,
    required this.skeletonMode
  });

  @override
  State<CustomBasicRowDisplay> createState() => CustomBasicRowDisplayState();
}

class CustomBasicRowDisplayState extends State<CustomBasicRowDisplay>{
  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    if(!widget.skeletonMode){
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.6),
          borderRadius: const BorderRadius.all(Radius.circular(12.5))
        ),
        width: basicRowDisplayWidgetSize.width,
        height: basicRowDisplayWidgetSize.height,
        padding: EdgeInsets.only(
          right: defaultHorizontalPadding,
        ),
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          onTap: widget.onPressed,
          child: Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.5),
                    bottomLeft: Radius.circular(12.5)
                  )
                ),
                width: basicRowDisplayImageSize.width,
                height: basicRowDisplayImageSize.height,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.5),
                    bottomLeft: Radius.circular(12.5)
                  ),
                  child: widget.image
                )
              ),
              SizedBox(
                width: getScreenWidth() * 0.035
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.text.isEmpty ?
                      Container()
                    :
                      Flexible(
                        child: Text(
                          widget.text, 
                          style: TextStyle(
                            fontSize: defaultTextFontSize * 0.8,
                            fontWeight: FontWeight.w600
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ) ,
                    widget.description == null ?
                      Container()
                    :
                      Flexible(
                        child: Text(
                          widget.description, 
                          style: TextStyle(
                            fontSize: defaultTextFontSize * 0.75,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ) 
            ],
          )
        ),
      );
    }else{
      return Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12.5))
        ),
        width: basicRowDisplayWidgetSize.width,
        height: basicRowDisplayWidgetSize.height,
        padding: EdgeInsets.only(
          right: defaultHorizontalPadding,
        ),
      );
    }
  }
}