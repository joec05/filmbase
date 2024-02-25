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
  late MainPageController controller;

  @override void initState(){
    super.initState();
    controller = MainPageController(context);
    controller.initializeController();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controller.selectedIndexValue,
      builder: (BuildContext context, int selectedIndexValue, Widget? child) {
        return Scaffold(
          key: controller.scaffoldKey,
          drawerEdgeDragWidth: 0.85 * getScreenWidth(),
          onDrawerChanged: (isOpened) {
          },
          appBar: controller.setAppBar(selectedIndexValue),
          body: PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: controller.widgetOptions,
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
              controller.pageController.jumpToPage(index);
            })
          ),
          drawer: DrawerNavigator(key: UniqueKey(), parentContext: context)
        );
      }
    );
  }
}
