import 'dart:convert';
import 'package:filmbase/global_files.dart';
import 'package:flutter/material.dart';

class AuthenticationRepository {
  Future<void> initialize(BuildContext context) async{
    bool mounted = context.mounted;
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

  Future<String?> generateRequestToken() async{
    var res = await dio.get(
      '$mainAPIUrl/authentication/token/new?api_key=${appStateRepo.apiIdentifiers.apiKey}',
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      String requestToken = res.data['request_token'];
      return requestToken;
    }
    return null;
  }

  Future<Map?> generateSessionID(String requestToken) async{
    var res = await dio.post(
      '$mainAPIUrl/authentication/session/new',
      data: jsonEncode({
        'request_token': requestToken
      }),
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      return res.data;
    }
    return null;
  }
}

final AuthenticationRepository authRepo = AuthenticationRepository();