import 'package:filmbase/constants/private_data.dart';

class APIIdentifiersClass{
  String accessToken;
  String apiKey;
  String? sessionID;
  int userID;

  APIIdentifiersClass(
    this.accessToken,
    this.apiKey,
    this.sessionID,
    this.userID
  );

  factory APIIdentifiersClass.fromMap(Map map){
    return APIIdentifiersClass(
      map['access_token'],
      map['api_key'], 
      map['session_id'],
      map['user_id']
    );
  }

  Map toMap(){
    return {
      'access_token': accessToken,
      'api_key': apiKey,
      'session_id': sessionID,
      'user_id': userID
    };
  }
}

final apiIdentifiersClass = APIIdentifiersClass(
  accessToken,
  apiKey, 
  null,
  0
);