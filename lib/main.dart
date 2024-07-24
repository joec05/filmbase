import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filmbase/global_files.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

final talker = Talker();
final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  ByteData data = await PlatformAssetBundle().load('assets/certificate/ca.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  runApp(const MyApp());
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MyHomePage(),
      routes: [
        GoRoute(
          name: 'main',
          path: 'main',
          builder: (context, state) => const MyHomePage()
        ),
        GoRoute(
          name: 'connect-account',
          path: 'connect-account/:url',
          builder: (context, state) => ConnectAccountPage(url: state.pathParameters['url']!)
        ),
        GoRoute(
          name: 'main-page',
          path: 'main-page',
          builder: (context, state) => const MainPageWidget()
        ),
        GoRoute(
          name: 'view-favourites',
          path: 'view-favourites/:initialIndex',
          builder: (context, state) => ViewFavourites(initialIndex: int.parse(state.pathParameters['initialIndex']!))
        ),
        GoRoute(
          name: 'view-watchlist',
          path: 'view-watchlist/:initialIndex',
          builder: (context, state) => ViewWatchlist(initialIndex: int.parse(state.pathParameters['initialIndex']!))
        ),
        GoRoute(
          name: 'view-rated',
          path: 'view-rated/:initialIndex',
          builder: (context, state) => ViewRated(initialIndex: int.parse(state.pathParameters['initialIndex']!))
        ),
        GoRoute(
          name: 'view-lists',
          path: 'view-lists',
          builder: (context, state) => const ViewLists()
        ),
        GoRoute(
          name: 'search-page',
          path: 'search-page',
          builder: (context, state) => const SearchPageWidget()
        ),
        GoRoute(
          name: 'view-movie-details',
          path: 'view-movie-details/:movieID',
          builder: (context, state) => ViewMovieDetails(movieID: int.parse(state.pathParameters['movieID']!))
        ),
        GoRoute(
          name: 'view-movies-list',
          path: 'view-movies-list/:urlParam',
          builder: (context, state) => ViewMoviesList(urlParam: state.pathParameters['urlParam']!)
        ),
        GoRoute(
          name: 'view-tv-show-details',
          path: 'view-tv-show-details/:tvShowID',
          builder: (context, state) => ViewTvShowDetails(tvShowID: int.parse(state.pathParameters['tvShowID']!))
        ),
        GoRoute(
          name: 'view-tv-shows-list',
          path: 'view-tv-shows-list/:urlParam',
          builder: (context, state) => ViewTvShowsList(urlParam: state.pathParameters['urlParam']!)
        ),
        GoRoute(
          name: 'view-people-details',
          path: 'view-people-details/:personID',
          builder: (context, state) => ViewPeopleDetails(personID: int.parse(state.pathParameters['personID']!))
        ),
        GoRoute(
          name: 'view-collection-details',
          path: 'view-collection-details/:collectionID',
          builder: (context, state) => ViewCollectionDetails(collectionID: int.parse(state.pathParameters['collectionID']!))
        ),
        GoRoute(
          name: 'view-episode-details',
          path: 'view-episode-details/:showID/:episodeID/:seasonNum/:episodeNum',
          builder: (context, state) => ViewEpisodeDetails(
            episodeID: int.parse(state.pathParameters['episodeID']!), 
            showID: int.parse(state.pathParameters['showID']!),
            seasonNum: int.parse(state.pathParameters['seasonNum']!),
            episodeNum: int.parse(state.pathParameters['episodeNum']!)
          )
        ),
        GoRoute(
          name: 'view-list-details',
          path: 'view-list-details/:listID',
          builder: (context, state) => ViewListDetails(listID: int.parse(state.pathParameters['listID']!))
        ),
        GoRoute(
          name: 'view-season-details',
          path: 'view-season-details/:showID/:seasonNum',
          builder: (context, state) => ViewSeasonDetails(
            showID: int.parse(state.pathParameters['showID']!),
            seasonNum: int.parse(state.pathParameters['seasonNum']!)
          )
        ),
      ]
    )
  ]
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: navigatorKey,
      scaffoldMessengerKey: scaffoldKey,
      theme: globalTheme.dark,
      routerConfig: router
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  void initState(){
    super.initState();
    authRepo.initialize(context);
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: defaultAppBarDecoration
      )
    );
  }
}
