import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

BoxDecoration defaultAppBarDecoration = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color.fromARGB(255, 100, 40, 21), Color.fromARGB(255, 173, 91, 43)
    ],
    stops: [
      0.25, 0.6
    ],
  ),
);

double defaultAppBarTitleSpacing = getScreenWidth() * 0.02;

double defaultHomeAppBarTitleSpacing = getScreenWidth() * 0.045;

Text setAppBarTitle(String text){
  return Text(
    text
  );
}