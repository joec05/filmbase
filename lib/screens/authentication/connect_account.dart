import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:filmbase/global_files.dart';

class ConnectAccountPage extends StatefulWidget {
  final String url;

  const ConnectAccountPage({
    super.key, 
    required this.url,
  });

  @override
  ConnectAccountPageState createState() => ConnectAccountPageState();
}

class ConnectAccountPageState extends State<ConnectAccountPage> {
  final ValueNotifier<double> _progress = ValueNotifier(0);

  @override
  void initState(){
    super.initState();
  }
  
  @override
  void dispose(){
    super.dispose();
    _progress.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: setAppBarTitle('Connect Account')
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
            onProgressChanged: (controller, progress) {
              if(mounted){
                _progress.value = progress / 100;
              }
            },
          ),
        ]
      )
    );
  }
}