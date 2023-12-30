import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:filmbase/appdata/global_variables.dart';
import 'package:filmbase/class/api_identifiers_class.dart';
import 'package:filmbase/state/main.dart';

class AppStorageClass{
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );

  void updateAPIIdentifiers() async{
    storage.write(key: apiIdentifiersDataKey, value: jsonEncode(appStateClass.apiIdentifiers.toMap()));
  }

  void resetAPIIdentifiers() async{
    storage.write(key: apiIdentifiersDataKey, value: null);
  }

  Future<APIIdentifiersClass> fetchAPIIdentifiers() async{
    String? apiIdentifiersEncoded = await storage.read(key: apiIdentifiersDataKey); 
    if(apiIdentifiersEncoded == null){
      return apiIdentifiersClass;
    }else{
      return APIIdentifiersClass.fromMap(jsonDecode(apiIdentifiersEncoded));
    }
  }
}

final appStorageClass = AppStorageClass();