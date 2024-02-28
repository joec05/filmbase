import 'dart:convert';

import 'package:filmbase/global_files.dart';
import 'package:dio/dio.dart';

var dio = Dio();

class ApiCallRepository {
  void fetchUserData() async{
    var res = await dio.get(
      '$mainAPIUrl/account?session_id=${appStateRepo.apiIdentifiers.sessionID}',
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      var data = res.data;
      appStateRepo.currentUserData = UserAccountDetailsClass.fromMap(data);
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
    appStateRepo.globalMovieGenres = genresMap;
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
    appStateRepo.globalTvSeriesGenres = genresMap;
  }

  void updateUserID() async{
    var res = await dio.get(
      '$mainAPIUrl/account?session_id=${appStateRepo.apiIdentifiers.sessionID}',
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      var data = res.data;
      int userID = data['id'];
      appStateRepo.apiIdentifiers.userID = userID;
      appStateRepo.appStorage.updateAPIIdentifiers();
    }
  }

  void updateUserMovieData(int movieID, String ratingText, bool favourite, bool watchlisted) async{
    MovieDataClass updatedMovieData = appStateRepo.globalMovies[movieID]!.notifier.value.createDuplicate();
    updatedMovieData.userMovieStatus.score = double.parse(ratingText);
    updatedMovieData.userMovieStatus.favourite = favourite;
    updatedMovieData.userMovieStatus.watchlisted = watchlisted;
    appStateRepo.globalMovies[movieID]!.notifier.value = updatedMovieData;
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
        'session_id': appStateRepo.apiIdentifiers.sessionID
      },
      options: defaultAPIOption
    );

    await dio.post(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/favorite',
      queryParameters: {
        'session_id': appStateRepo.apiIdentifiers.sessionID
      },
      data: jsonEncode({
        'media_type': 'movie',
        'media_id': movieID,
        'favorite': favourite
      }),
      options: defaultAPIOption
    );

    await dio.post(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/watchlist',
      queryParameters: {
        'session_id': appStateRepo.apiIdentifiers.sessionID
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
    TvSeriesDataClass updatedTvSeriesData = appStateRepo.globalTvSeries[tvShowID]!.notifier.value.createDuplicate();
    updatedTvSeriesData.userTvSeriesStatus.score = double.parse(ratingText);
    updatedTvSeriesData.userTvSeriesStatus.favourite = favourite;
    updatedTvSeriesData.userTvSeriesStatus.watchlisted = watchlisted;
    appStateRepo.globalTvSeries[tvShowID]!.notifier.value = updatedTvSeriesData;
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
        'session_id': appStateRepo.apiIdentifiers.sessionID
      },
      options: defaultAPIOption
    );

    await dio.post(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/favorite',
      queryParameters: {
        'session_id': appStateRepo.apiIdentifiers.sessionID
      },
      data: jsonEncode({
        'media_type': 'tvShow',
        'media_id': tvShowID,
        'favorite': favourite
      }),
      options: defaultAPIOption
    );

    await dio.post(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/watchlist',
      queryParameters: {
        'session_id': appStateRepo.apiIdentifiers.sessionID
      },
      data: jsonEncode({
        'media_type': 'tvShow',
        'media_id': tvShowID,
        'watchlist': watchlisted
      }),
      options: defaultAPIOption
    );
  }

  void updateUserItemsList(int listID, List<MediaItemClass> includedItemsOriginal, List<MediaItemClass> includedItems) async{
    ListDataClass updatedListData = appStateRepo.globalLists[listID]!.notifier.value.createDuplicate();
    for(int i = 0; i < includedItemsOriginal.length; i++){
      if(!includedItems.contains(includedItemsOriginal[i])){
        if(includedItemsOriginal[i].mediaType == MediaType.movie){
          updatedListData.itemCount--;
          updatedListData.mediaItems.removeWhere((e) => e.id == includedItemsOriginal[i].id);
        }
      }
    }
    appStateRepo.globalLists[listID]!.notifier.value = updatedListData;
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
    ListDataClass updatedListData = appStateRepo.globalLists[listID]!.notifier.value.createDuplicate();
    updatedListData.mediaItems = <MediaItemClass>{...updatedListData.mediaItems, ...selectedItems}.toList();
    updatedListData.itemCount = updatedListData.mediaItems.length;
    appStateRepo.globalLists[listID]!.notifier.value = updatedListData;
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
    EpisodeDataClass updatedEpisodeData = appStateRepo.globalEpisodes[episodeID]!.notifier.value.createDuplicate();
    updatedEpisodeData.rating = double.parse(ratingText);
    appStateRepo.globalEpisodes[episodeID]!.notifier.value = updatedEpisodeData;
    await dio.post(
      '$mainAPIUrl/tv/$showID/season/$seasonNum/episode/$episodeNum/rating',
      options: defaultAPIOption,
      data: jsonEncode({
        'value': double.parse(ratingText)
      })
    );
  }

}

final ApiCallRepository apiCallRepo = ApiCallRepository();