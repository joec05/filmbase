import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:filmbase/global_files.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  ByteData data = await PlatformAssetBundle().load('assets/certificate/ca.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filmbase',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Filmbase Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AssetImage assetImage = const AssetImage('assets/images/icon.jpg');

  @override
  void initState(){
    super.initState();
    Timer(const Duration(milliseconds: 1500), (){
      initialize();
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  void initialize() async{
    APIIdentifiersClass apiIdentifiersClass = await appStateRepo.appStorage.fetchAPIIdentifiers();
    if(apiIdentifiersClass.sessionID == null){
      String? requestToken = await authRepo.generateRequestToken();
      if(requestToken != null && mounted){
        await Navigator.push(
          context,
          NavigationTransition(
            page: ConnectAccountPage(
              url: 'https://www.themoviedb.org/authenticate/$requestToken'
            )
          )
        );
        var res = await authRepo.generateSessionID(requestToken);
        if(res != null){
          appStateRepo.apiIdentifiers.sessionID = res['session_id'];
          apiCallRepo.updateUserID();
          apiCallRepo.fetchUserData();
          if(mounted){
            Navigator.pushAndRemoveUntil(
              context,
              NavigationTransition(
                page: const MainPageWidget()
              ),
              (Route<dynamic> route) => false
            );
          }
        }
      }
    }else{
      appStateRepo.apiIdentifiers = apiIdentifiersClass;
      apiCallRepo.fetchUserData();
      if(mounted){
        Navigator.pushAndRemoveUntil(
          context,
          NavigationTransition(
            page: const MainPageWidget()
          ),
          (Route<dynamic> route) => false
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(assetImage, context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: defaultAppBarDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: assetImage,
              width: getScreenWidth() * 0.4, 
              height: getScreenWidth() * 0.4
            ),
          ],
        )
      )
    );
  }
}
