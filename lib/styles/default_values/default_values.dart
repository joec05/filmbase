import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

Size mediaGridDisplayWidgetSize = Size(
  getScreenWidth(),
  getScreenHeight() * 0.165,
);

Size listDisplayWidgetSize = Size(
  getScreenWidth() * 0.6,
  getScreenHeight() * 0.45,
);

Size mediaGridDisplayCoverSize = Size(
  getScreenWidth() * 0.2,
  getScreenHeight() * 0.15,
);

Size basicCoverDisplayWidgetSize = Size(
  getScreenWidth() * 0.35,
  getScreenHeight() * 0.375,
);

Size basicCoverDisplayImageSize = Size(
  getScreenWidth() * 0.35,
  getScreenHeight() * 0.3,
);

Size basicRowDisplayWidgetSize = Size(
  getScreenWidth() * 0.9,
  getScreenHeight() * 0.15,
);

Size basicRowDisplayImageSize = Size(
  getScreenWidth() * 0.225,
  getScreenHeight() * 0.15,
);

Size peopleDisplayCoverSize = Size(
  getScreenWidth() * 0.225,
  getScreenHeight() * 0.175,
);

Size mediaDisplayCoverSize = Size(
  getScreenWidth() * 0.325,
  getScreenHeight() * 0.25,
);

Size detailDisplayCoverSize = Size(
  getScreenWidth() * 0.3,
  getScreenHeight() * 0.25,
);

double defaultTextFontSize = 16.5;

double defaultHorizontalPadding = getScreenWidth() * 0.02;

double defaultVerticalPadding = getScreenHeight() * 0.01;

Widget defaultLeadingWidget(BuildContext context){
  return InkWell(
    splashFactory: InkRipple.splashFactory,
    onTap: () => context.mounted ? Navigator.pop(context) : (){},
    child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white)
  );
}