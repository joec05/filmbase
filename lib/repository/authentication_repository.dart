import 'dart:convert';
import 'package:filmbase/global_files.dart';
import 'package:flutter/material.dart';

class AuthenticationRepository {
  Future<void> initialize(BuildContext context) async{
    bool mounted = context.mounted;
    APIIdentifiersClass? apiIdentifiersClass = await appStateRepo.appStorage.fetchAPIIdentifiers();
    if(apiIdentifiersClass == null){
      String? requestToken = await authRepo.generateRequestToken();
      if(requestToken != null && mounted){
        await router.pushNamed('connect-account', pathParameters: {'url': 'https://www.themoviedb.org/authenticate/$requestToken'});
        var res = await authRepo.generateSessionID(requestToken);
        if(res != null){
          appStateRepo.apiIdentifiers.sessionID = res['session_id'];
          apiCallRepo.updateUserID();
          apiCallRepo.fetchUserData();
          if(mounted){
            while(router.canPop()) {
              router.pop();
            }
            router.push('/main-page');
          }
        }
      }
    }else{
      appStateRepo.apiIdentifiers = apiIdentifiersClass;
      apiCallRepo.fetchUserData();
      if(mounted){
        while(router.canPop()) {
          router.pop();
        }
        router.push('/main-page');
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