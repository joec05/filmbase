import 'dart:convert';
import 'package:filmbase/global_files.dart';

class AuthenticationRepository {
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