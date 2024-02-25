import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:filmbase/global_files.dart';

class MainPageController {
  final BuildContext context;
  ValueNotifier<int> selectedIndexValue = ValueNotifier(0);
  final PageController pageController = PageController(initialPage: 0, keepPage: true);
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  MainPageController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController() {
    apiCallRepo.fetchMovieGenres();
    apiCallRepo.fetchTvSeriesGenres();
  }

  void resetBottomNavIndex(){
    pageController.jumpToPage(0);
  }

  void dispose(){
    selectedIndexValue.dispose();
    pageController.dispose();
  }

  void onPageChanged(newIndex){
    if(mounted){
      selectedIndexValue.value = newIndex;
    }
  }

  final List<Widget> widgetOptions = <Widget>[
    const MoviesPage(),
    const TvSeriesPage(),
    const PeoplePage()
  ];

  PreferredSizeWidget setAppBar(index){
    if(index == 0){
      return AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Movies'),
            InkWell(
              splashFactory: InkSplash.splashFactory,
              onTap: (){
                delayNavigationPush(
                  context,
                  const SearchPageWidget()
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.5),
                child: Icon(FontAwesomeIcons.magnifyingGlass, size: 22.5),
              ),
            ),
          ]
        ), 
        titleSpacing: defaultAppBarTitleSpacing,
      );
    }else if(index == 1){
      return AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('TV Shows'),
            InkWell(
              splashFactory: InkSplash.splashFactory,
              onTap: (){
                delayNavigationPush(
                  context,
                  const SearchPageWidget()
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.5),
                child: Icon(FontAwesomeIcons.magnifyingGlass, size: 22.5),
              ),
            ),
          ]
        ),
        titleSpacing: defaultAppBarTitleSpacing,
      );
    }else if(index == 2){
      return AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('People'),
            InkWell(
              splashFactory: InkSplash.splashFactory,
              onTap: (){
                delayNavigationPush(
                  context,
                  const SearchPageWidget()
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.5),
                child: Icon(FontAwesomeIcons.magnifyingGlass, size: 22.5),
              ),
            ),
          ]
        ),
        titleSpacing: defaultAppBarTitleSpacing,
      );
    }
    return AppBar();
  }
}