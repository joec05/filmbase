import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:filmbase/global_files.dart';

class DrawerNavigator extends StatelessWidget {
  final BuildContext parentContext;
  const DrawerNavigator({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return _DrawerNavigatorStateful(parentContext: parentContext);
  }
}

class _DrawerNavigatorStateful extends StatefulWidget {
  final BuildContext parentContext;
  const _DrawerNavigatorStateful({required this.parentContext});

  @override
  State<_DrawerNavigatorStateful> createState() => __DrawerNavigatorStatefulState();
}

class __DrawerNavigatorStatefulState extends State<_DrawerNavigatorStateful>{
  late BuildContext parentContext;

  @override
  void initState() {
    super.initState();
    parentContext = widget.parentContext;
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            title: SizedBox(
              width: 0.85 * getScreenWidth(),
              height: getScreenHeight() * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appStateRepo.currentUserData == null ?
                    shimmerSkeletonWidget(
                      CustomProfileDisplay(
                        userData: appStateRepo.currentUserData!, 
                        skeletonMode: true
                      )
                    )
                  :
                    CustomProfileDisplay(
                      userData: appStateRepo.currentUserData!, 
                      skeletonMode: false
                    )
                ]
              ),
            ),
            onTap: () {
            },
          ),
          ListTile(
            title: SizedBox(
              width:  0.85 * getScreenWidth(),
              height: getScreenHeight() * 0.07,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(FontAwesomeIcons.heart, size: 20),
                      SizedBox(width: getScreenWidth() * 0.05),
                      Text('Favourites', style: TextStyle(fontSize: defaultTextFontSize)),
                    ],
                  )
                ]
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 450), (){
                Navigator.push(
                  parentContext,
                  NavigationTransition(
                    page: const ViewFavourites(initialIndex: 0)
                  )
                );
              });
            },
          ),
          ListTile(
            title: SizedBox(
              width:  0.85 * getScreenWidth(),
              height: getScreenHeight() * 0.07,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.mobileScreen, size: 20),
                      SizedBox(width: getScreenWidth() * 0.05),
                      Text('Watchlist', style: TextStyle(fontSize: defaultTextFontSize)),
                    ],
                  )
                ]
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 450), (){
                Navigator.push(
                  parentContext,
                  NavigationTransition(
                    page: const ViewWatchlist(initialIndex: 0)
                  )
                );
              });
            },
          ),
          ListTile(
            title: SizedBox(
              width:  0.85 * getScreenWidth(),
              height: getScreenHeight() * 0.07,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.zero, size: 20),
                      SizedBox(width: getScreenWidth() * 0.05),
                      Text('Rated', style: TextStyle(fontSize: defaultTextFontSize)),
                    ],
                  )
                ]
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 450), (){
                Navigator.push(
                  parentContext,
                  NavigationTransition(
                    page: const ViewRated(initialIndex: 0)
                  )
                );
              });
            },
          ),
          ListTile(
            title: SizedBox(
              width:  0.85 * getScreenWidth(),
              height: getScreenHeight() * 0.07,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.list, size: 20),
                      SizedBox(width: getScreenWidth() * 0.05),
                      Text('Lists', style: TextStyle(fontSize: defaultTextFontSize)),
                    ],
                  )
                ]
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(const Duration(milliseconds: 450), (){
                Navigator.push(
                  parentContext,
                  NavigationTransition(
                    page: const ViewLists()
                  )
                );
              });
            },
          ),
          ListTile(
            title: SizedBox(
              width:  0.85 * getScreenWidth(),
              height: getScreenHeight() * 0.07,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.logout, size: 22.5),
                      SizedBox(width: getScreenWidth() * 0.05),
                      Text('Log Out', style: TextStyle(fontSize: defaultTextFontSize)),
                    ],
                  )
                ]
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              appStateRepo.appStorage.resetAPIIdentifiers();
              Future.delayed(const Duration(milliseconds: 450), (){
                Navigator.pushAndRemoveUntil(
                  parentContext,
                  NavigationTransition(
                    page: const MyApp(),
                  ),
                  (Route<dynamic> route) => false
                );
              });
            },
          ),
        ],
      ),
    );
  }
}