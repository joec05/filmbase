import 'package:filmbase/global_files.dart';
import 'package:flutter/material.dart';

/// Returns the content of a snackbar in widget form. Typically contains text and sometimes an icon as well.
Widget snackbarContentTemplate(IconData? iconData, String text) => Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    iconData != null ? Icon(iconData, size: 17) : Container(),
    SizedBox(
      width: iconData != null ? getScreenWidth() * 0.035 : 0
    ),
    Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, textAlign: TextAlign.left, style: const TextStyle(
            fontWeight: FontWeight.bold
          ))
        ],
      ),
    )
  ],
);