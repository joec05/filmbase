import 'package:dio/dio.dart';
import 'package:filmbase/global_files.dart';

String mainAPIUrl = 'https://api.themoviedb.org/3';

Options defaultAPIOption = Options(
  headers: {
    'Authorization': 'Bearer ${appStateRepo.apiIdentifiers.accessToken}'
  },
);