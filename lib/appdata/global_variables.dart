import 'package:dio/dio.dart';

var dio = Dio();

String mainAPIUrl = 'https://api.themoviedb.org/3';

String imageAccessUrl = 'https://image.tmdb.org/t/p/original';

String apiIdentifiersDataKey = 'api-identifiers';

int paginateDelayDuration = 250;

int maxSearchedResultsCount = 100;

int maxViewResultsCount = 100;

int shimmerDefaultLength = 5;