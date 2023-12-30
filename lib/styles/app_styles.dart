import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_library.dart';
import 'package:shimmer/shimmer.dart';

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

void displayAlertDialog(BuildContext context, String text){
  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Alert', textAlign: TextAlign.center),
        titlePadding: EdgeInsets.only(top: getScreenHeight() * 0.025),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style: const TextStyle(
              fontSize: 17
            )),
            SizedBox(
              height: getScreenHeight() * 0.025
            ),
          ]
        )
      );
    }
  );
}

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

Widget shimmerSkeletonWidget(Widget child){
  return Shimmer.fromColors(
    baseColor: Colors.grey.withOpacity(0.5),
    highlightColor: const Color.fromARGB(179, 167, 155, 155),
    child: child
  );
}

Image itemNoImage = Image.asset(
  'assets/images/unknown-item.png',
  fit: BoxFit.cover
);

Text setAppBarTitle(String text){
  return Text(
    text,
  );
}

Widget generateCachedImage(String? url){
  if(url == null){
    return itemNoImage;
  }

  return CachedNetworkImage(
    imageUrl: '$imageAccessUrl$url', 
    fit: BoxFit.cover,
    errorWidget: (context, error, stackTrace) => itemNoImage,
    fadeInDuration: const Duration(milliseconds: 250)
  );
}

Widget generateCachedImageCarousel(String? url){
  if(url == null){
    return Image.asset(
      'assets/images/unknown-item.png',
      height: getScreenHeight() * 0.25, 
      fit: BoxFit.fitWidth,
    );
  }

  return CachedNetworkImage(
    imageUrl: '$imageAccessUrl$url', 
    fit: BoxFit.fitWidth,
    height: getScreenHeight() * 0.25, 
    errorWidget: (context, error, stackTrace){
      return Image.asset(
        'assets/images/unknown-item.png',
        height: getScreenHeight() * 0.25, 
        fit: BoxFit.fitWidth,
      );
    },
    fadeInDuration: const Duration(milliseconds: 250)
  );
}