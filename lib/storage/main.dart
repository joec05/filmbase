import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:filmbase/global_files.dart';

class AppStorageClass{
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    )
  );
  String apiIdentifiersDataKey = 'api-identifiers';

  void updateAPIIdentifiers() async{
    storage.write(key: apiIdentifiersDataKey, value: jsonEncode(appStateRepo.apiIdentifiers.toMap()));
  }

  void resetAPIIdentifiers() async{
    storage.write(key: apiIdentifiersDataKey, value: null);
  }

  Future<APIIdentifiersClass?> fetchAPIIdentifiers() async{
    String? apiIdentifiersEncoded = await storage.read(key: apiIdentifiersDataKey); 
    if(apiIdentifiersEncoded == null) {
      return null;
    }
    return APIIdentifiersClass.fromMap(jsonDecode(apiIdentifiersEncoded));
    }
}

final appStorageClass = AppStorageClass();