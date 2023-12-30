import 'package:flutter/material.dart';
import 'package:filmbase/styles/app_styles.dart';

class CustomBasicCoverDisplay extends StatefulWidget {
  final Widget image;
  final String text;
  final Function() onPressed;
  final dynamic description;
  final bool skeletonMode;

  const CustomBasicCoverDisplay({
    super.key,
    required this.image,
    required this.text,
    required this.onPressed,
    this.description,
    required this.skeletonMode
  });

  @override
  State<CustomBasicCoverDisplay> createState() => CustomBasicCoverDisplayState();
}

class CustomBasicCoverDisplayState extends State<CustomBasicCoverDisplay>{
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
        width: basicCoverDisplayWidgetSize.width,
        padding: EdgeInsets.only(
          right: defaultHorizontalPadding
        ),
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          onTap: widget.onPressed,
          child: Column(
            children: [
              SizedBox(
                width: basicCoverDisplayImageSize.width,
                height: basicCoverDisplayImageSize.height,
                child: widget.image
              ),
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
                ) 
            ],
          )
        ),
      );
    }else{
      return Container(
        width: basicCoverDisplayWidgetSize.width,
        margin: EdgeInsets.only(
          right: defaultHorizontalPadding
        ),
        color: Colors.grey
      );
    }
  }
}