
import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:filmbase/class/media_item_class.dart';
import 'package:flutter/material.dart';
import 'package:filmbase/appdata/global_library.dart';
import 'package:filmbase/class/episode_data_class.dart';
import 'package:filmbase/class/list_data_class.dart';
import 'package:filmbase/class/movie_data_class.dart';
import 'package:filmbase/class/tv_series_data_class.dart';
import 'package:filmbase/class/user_account_details_class.dart';
import 'package:filmbase/state/main.dart';
import 'package:filmbase/streams/update_favourite_stream_class.dart';
import 'package:filmbase/streams/update_lists_stream_class.dart';
import 'package:filmbase/streams/update_rated_stream_class.dart';
import 'package:filmbase/streams/update_watchlist_stream_class.dart';
import 'package:filmbase/transition/navigation_transition.dart';

double getScreenHeight(){
  return PlatformDispatcher.instance.views.first.physicalSize.height / PlatformDispatcher.instance.views.first.devicePixelRatio;
}

double getScreenWidth(){
  return PlatformDispatcher.instance.views.first.physicalSize.width / PlatformDispatcher.instance.views.first.devicePixelRatio;
}

Options defaultAPIOption = Options(
  headers: {
    'Authorization': 'Bearer ${appStateClass.apiIdentifiers.accessToken}'
  },
);

Future<String?> generateRequestToken() async{
  var res = await dio.get(
    '$mainAPIUrl/authentication/token/new?api_key=${appStateClass.apiIdentifiers.apiKey}',
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

void fetchUserData() async{
  var res = await dio.get(
    '$mainAPIUrl/account?session_id=${appStateClass.apiIdentifiers.sessionID}',
    options: defaultAPIOption
  );
  if(res.statusCode == 200){
    var data = res.data;
    appStateClass.currentUserData = UserAccountDetailsClass.fromMap(data);
  }
}

void fetchMovieGenres() async{
  Map<int, String> genresMap = {};
  var res = await dio.get(
    '$mainAPIUrl/genre/movie/list?language=en',
    options: defaultAPIOption
  );
  if(res.statusCode == 200){
    var data = res.data['genres'];
    for(int i = 0; i < data.length; i++){
      genresMap[data[i]['id']] = data[i]['name'];
    }
  }
  appStateClass.globalMovieGenres = genresMap;
}

void fetchTvSeriesGenres() async{
  Map<int, String> genresMap = {};
  var res = await dio.get(
    '$mainAPIUrl/genre/tv/list?language=en',
    options: defaultAPIOption
  );
  if(res.statusCode == 200){
    var data = res.data['genres'];
    for(int i = 0; i < data.length; i++){
      genresMap[data[i]['id']] = data[i]['name'];
    }
  }
  appStateClass.globalTvSeriesGenres = genresMap;
}

void updateUserID() async{
  var res = await dio.get(
    '$mainAPIUrl/account?session_id=${appStateClass.apiIdentifiers.sessionID}',
    options: defaultAPIOption
  );
  if(res.statusCode == 200){
    var data = res.data;
    int userID = data['id'];
    appStateClass.apiIdentifiers.userID = userID;
    appStateClass.appStorage.updateAPIIdentifiers();
  }
}

void updateUserMovieData(int movieID, String ratingText, bool favourite, bool watchlisted) async{
  MovieDataClass updatedMovieData = appStateClass.globalMovies[movieID]!.notifier.value.createDuplicate();
  updatedMovieData.userMovieStatus.score = double.parse(ratingText);
  updatedMovieData.userMovieStatus.favourite = favourite;
  updatedMovieData.userMovieStatus.watchlisted = watchlisted;
  appStateClass.globalMovies[movieID]!.notifier.value = updatedMovieData;
  UpdateRatedStreamClass().emitData(
    RatedStreamControllerClass(
      movieID,
      UpdateStreamDataType.movie,
    )
  );
  UpdateFavouriteStreamClass().emitData(
    FavouriteStreamControllerClass(
      movieID,
      UpdateStreamDataType.movie,
      favourite ? UpdateStreamActionType.add : UpdateStreamActionType.delete,
    )
  );
  UpdateWatchlistStreamClass().emitData(
    WatchlistStreamControllerClass(
      movieID,
      UpdateStreamDataType.movie,
      watchlisted ? UpdateStreamActionType.add : UpdateStreamActionType.delete,
    )
  );

  await dio.post(
    '$mainAPIUrl/movie/$movieID/rating',
    data: jsonEncode({
      'value': double.parse(ratingText)
    }),
    queryParameters: {
      'session_id': appStateClass.apiIdentifiers.sessionID
    },
    options: defaultAPIOption
  );

  await dio.post(
    '$mainAPIUrl/account/${appStateClass.apiIdentifiers.userID}/favorite',
    queryParameters: {
      'session_id': appStateClass.apiIdentifiers.sessionID
    },
    data: jsonEncode({
      'media_type': 'movie',
      'media_id': movieID,
      'favorite': favourite
    }),
    options: defaultAPIOption
  );

  await dio.post(
    '$mainAPIUrl/account/${appStateClass.apiIdentifiers.userID}/watchlist',
    queryParameters: {
      'session_id': appStateClass.apiIdentifiers.sessionID
    },
    data: jsonEncode({
      'media_type': 'movie',
      'media_id': movieID,
      'watchlist': watchlisted
    }),
    options: defaultAPIOption
  );
}

void updateUserTvSeriesData(int tvShowID, String ratingText, bool favourite, bool watchlisted) async{
  TvSeriesDataClass updatedTvSeriesData = appStateClass.globalTvSeries[tvShowID]!.notifier.value.createDuplicate();
  updatedTvSeriesData.userTvSeriesStatus.score = double.parse(ratingText);
  updatedTvSeriesData.userTvSeriesStatus.favourite = favourite;
  updatedTvSeriesData.userTvSeriesStatus.watchlisted = watchlisted;
  appStateClass.globalTvSeries[tvShowID]!.notifier.value = updatedTvSeriesData;
  UpdateRatedStreamClass().emitData(
    RatedStreamControllerClass(
      tvShowID,
      UpdateStreamDataType.tvShow,
    )
  );
  UpdateFavouriteStreamClass().emitData(
    FavouriteStreamControllerClass(
      tvShowID,
      UpdateStreamDataType.tvShow,
      favourite ? UpdateStreamActionType.add : UpdateStreamActionType.delete,
    )
  );
  UpdateWatchlistStreamClass().emitData(
    WatchlistStreamControllerClass(
      tvShowID,
      UpdateStreamDataType.tvShow,
      watchlisted ? UpdateStreamActionType.add : UpdateStreamActionType.delete,
    )
  );

  await dio.post(
    '$mainAPIUrl/tv/$tvShowID/rating',
    data: jsonEncode({
      'value': double.parse(ratingText)
    }),
    queryParameters: {
      'session_id': appStateClass.apiIdentifiers.sessionID
    },
    options: defaultAPIOption
  );

  await dio.post(
    '$mainAPIUrl/account/${appStateClass.apiIdentifiers.userID}/favorite',
    queryParameters: {
      'session_id': appStateClass.apiIdentifiers.sessionID
    },
    data: jsonEncode({
      'media_type': 'tvShow',
      'media_id': tvShowID,
      'favorite': favourite
    }),
    options: defaultAPIOption
  );

  await dio.post(
    '$mainAPIUrl/account/${appStateClass.apiIdentifiers.userID}/watchlist',
    queryParameters: {
      'session_id': appStateClass.apiIdentifiers.sessionID
    },
    data: jsonEncode({
      'media_type': 'tvShow',
      'media_id': tvShowID,
      'watchlist': watchlisted
    }),
    options: defaultAPIOption
  );
}

String getGender(int code){
  if(code == 1){
    return 'Female';
  }else if(code == 2){
    return 'Male';
  }
  return 'Unknown';
}

void updateUserItemsList(int listID, List<MediaItemClass> includedItemsOriginal, List<MediaItemClass> includedItems) async{
  ListDataClass updatedListData = appStateClass.globalLists[listID]!.notifier.value.createDuplicate();
  for(int i = 0; i < includedItemsOriginal.length; i++){
    if(!includedItems.contains(includedItemsOriginal[i])){
      if(includedItemsOriginal[i].mediaType == MediaType.movie){
        updatedListData.itemCount--;
        updatedListData.mediaItems.removeWhere((e) => e.id == includedItemsOriginal[i].id);
      }
    }
  }
  appStateClass.globalLists[listID]!.notifier.value = updatedListData;
  for(int i = 0; i < includedItemsOriginal.length; i++){
    if(!includedItems.contains(includedItemsOriginal[i])){
      if(includedItemsOriginal[i].mediaType == MediaType.movie){
        await dio.post(
          'https://api.themoviedb.org/3/list/$listID/remove_item',
          options: defaultAPIOption,
          data: jsonEncode({
            'media_type': 'movie',
            'media_id': includedItemsOriginal[i].id
          })
        );
      }else if(includedItemsOriginal[i].mediaType == MediaType.tvShow){
      }
    }
  }
}

void updateUserAddItemsList(int listID, List<MediaItemClass> selectedItems) async{
  ListDataClass updatedListData = appStateClass.globalLists[listID]!.notifier.value.createDuplicate();
  updatedListData.mediaItems = <MediaItemClass>{...updatedListData.mediaItems, ...selectedItems}.toList();
  updatedListData.itemCount = updatedListData.mediaItems.length;
  appStateClass.globalLists[listID]!.notifier.value = updatedListData;
  List<Map> rawBodyList = selectedItems.map((e) => {
    'media_type': e.mediaType == MediaType.movie ? 'movie' : 'tv',
    'media_id': e.id
  }).toList();
  for(int i = 0; i < rawBodyList.length; i++){
    await dio.post(
      'https://api.themoviedb.org/3/list/$listID/add_item',
      options: defaultAPIOption,
      data: jsonEncode(rawBodyList[i])
    );
  }
}

void createUserList(String name, String description) async{
  var res = await dio.post(
    '$mainAPIUrl/list',
    options: defaultAPIOption,
    data: jsonEncode({
      "name": name,
      "description": description,
      "language": "en"
    })
  );
  if(res.statusCode == 201){
    updateListCreateData({
      'id': res.data['list_id'],
      'name': name,
      'type': 'movie',
      'description': description
    });
    UpdateListsStreamClass().emitData(ListsStreamControllerClass(
      UpdateStreamActionType.add, res.data['list_id']
    ));  
  }
}

void deleteList(int listID) async{
  UpdateListsStreamClass().emitData(ListsStreamControllerClass(
    UpdateStreamActionType.delete, listID
  ));
  await dio.delete(
    '$mainAPIUrl/list/$listID',
    options: defaultAPIOption,
  );
}

void updateUserEpisodeData(int showID, int seasonNum, int episodeID, int episodeNum, String ratingText) async{
  EpisodeDataClass updatedEpisodeData = appStateClass.globalEpisodes[episodeID]!.notifier.value.createDuplicate();
  updatedEpisodeData.rating = double.parse(ratingText);
  appStateClass.globalEpisodes[episodeID]!.notifier.value = updatedEpisodeData;
  await dio.post(
    '$mainAPIUrl/tv/$showID/season/$seasonNum/episode/$episodeNum/rating',
    options: defaultAPIOption,
    data: jsonEncode({
      'value': double.parse(ratingText)
    })
  );
}

int getAge(String birthDate){
  List<String> birthDateList = birthDate.split('-');
  int getDifference = DateTime.now().difference(DateTime(int.parse(birthDateList[0]), int.parse(birthDateList[1]), int.parse(birthDateList[2]))).inDays;
  return (getDifference / 365).floor();
}

String getFullDateDescription(String date){
  List<String> dates = date.split('-');
  List<String> months = [
    '', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December'
  ];

  return '${dates[2]} ${months[int.parse(dates[1])]} ${dates[0]}';
}

String getTvShowStatus(String status){
  if(status == 'Returning Series'){
    return 'Ongoing';
  }else{
    return status;
  }
}

String getTimeDifference(String time){
  DateTime parse = DateTime.parse(time);
  Duration difference = DateTime.now().difference(parse);
  int inSeconds = difference.inSeconds;
  int inMinutes = difference.inMinutes;
  int inHours = difference.inHours;
  int inDays = difference.inDays;
  if(inDays > 365){
    int year = (inDays / 365).floor();
    return year <= 1 ? '1 year ago' : '$year years ago';
  }else if(inDays > 30){
    int month = (inDays / 30).floor();
    return month <= -1 ? '1 month ago' : '$month months ago';
  }else if(inDays >= 1){
    return inDays < -1 ? '1 day ago' : '$inDays days ago';
  }else if(inHours >= 1){
    return inHours < -1 ? '1 hour ago' : '$inHours hour ago';
  }else if(inMinutes >= 1){
    return inMinutes < -1 ? '1 minute ago' : '$inMinutes minutes ago';
  }else{
    return inSeconds < -1 ? '1 second ago' : '$inSeconds seconds ago';
  }
}

Future<void> delayNavigationPush(BuildContext context, Widget page) async{
  Future.delayed(const Duration(milliseconds: 400), (){
    Navigator.push(
      context,
      NavigationTransition(
        page: page
      )
    );
  });
}

String getLastDayOfMonth(){
  DateTime nextMonth = DateTime.now().add(const Duration(days: 30));
  DateTime lastDayOfThisMonth = DateTime(nextMonth.year, nextMonth.month, 1).subtract(const Duration(seconds: 1));
  String stringified = lastDayOfThisMonth.toString();
  return stringified.split(' ')[0];
}

String getFirstDayOfMonth(){
  DateTime thisMonth = DateTime.now();
  DateTime firstDayOfThisMonth = DateTime(thisMonth.year, thisMonth.month, 1);
  String stringified = firstDayOfThisMonth.toString();
  return stringified.split(' ')[0];
}

String getLastDayOfNextMonth(){
  DateTime nextTwoMonths = DateTime.now().add(const Duration(days: 60));
  DateTime lastDayOfNextMonth = DateTime(nextTwoMonths.year, nextTwoMonths.month, 1).subtract(const Duration(seconds: 1));
  String stringified = lastDayOfNextMonth.toString();
  return stringified.split(' ')[0];
}

String getFirstDayOfNextMonth(){
  DateTime nextMonth = DateTime.now().add(const Duration(days: 30));
  DateTime firstDayOfNextMonth = DateTime(nextMonth.year, nextMonth.month, 1);
  String stringified = firstDayOfNextMonth.toString();
  return stringified.split(' ')[0];
}