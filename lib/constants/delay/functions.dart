import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

Future<void> delayNavigationPush(BuildContext context, Widget page) async{
  Future.delayed(const Duration(milliseconds: 400), (){
    Navigator.push(
      context,
      NavigationTransition(
        page: page
      )
    );
  });
}