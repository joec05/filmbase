import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:filmbase/global_files.dart';

class MainPageWidget extends StatelessWidget {
  const MainPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MainPageWidgetStateful();
  }
}

class _MainPageWidgetStateful extends StatefulWidget {
  const _MainPageWidgetStateful();

  @override
  State<_MainPageWidgetStateful> createState() => __MainPageWidgetStatefulState();
}

class __MainPageWidgetStatefulState extends State<_MainPageWidgetStateful>{
  ValueNotifier<int> selectedIndexValue = ValueNotifier(0);
  final PageController _pageController = PageController(initialPage: 0, keepPage: true, );
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override void initState(){
    super.initState();
    apiCallRepo.fetchMovieGenres();
    apiCallRepo.fetchTvSeriesGenres();
  }

  void resetBottomNavIndex(){
    _pageController.jumpToPage(0);
  }

  @override void dispose(){
    super.dispose();
    selectedIndexValue.dispose();
    _pageController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedIndexValue,
      builder: (BuildContext context, int selectedIndexValue, Widget? child) {
        return Scaffold(
          key: scaffoldKey,
          drawerEdgeDragWidth: 0.85 * getScreenWidth(),
          onDrawerChanged: (isOpened) {
          },
          appBar: setAppBar(selectedIndexValue),
          body: PageView(
            controller: _pageController,
            onPageChanged: onPageChanged,
            children: widgetOptions,
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 77, 127, 150).withOpacity(0.35),
            selectedItemColor: Colors.tealAccent,
            unselectedItemColor: Colors.grey,
            key: UniqueKey(),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.film, size: 25),
                label: 'Movies',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.tv, size: 25),
                label: 'TV Shows',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.users, size: 27.5),
                label: '  People',
              ),
            ],
            currentIndex: selectedIndexValue,
            onTap: ((index) {
              _pageController.jumpToPage(index);
            })
          ),
          drawer: DrawerNavigator(key: UniqueKey(), parentContext: context)
        );
      }
    );
  }
}
