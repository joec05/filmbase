import 'package:filmbase/class/episode_data_class.dart';
import 'package:filmbase/class/item_credits.dart';
import 'package:filmbase/class/item_image_class.dart';
import 'package:filmbase/class/user_season_status.dart';

class SeasonDataClass{
  int id;
  int showID;
  String name;
  String? cover;
  String overview;
  List<UserEpisodeStatus> userEpisodesStatus;
  int seasonNum;
  List<EpisodeDataClass> episodes;
  int episodesCount;
  String? airDate;
  double? voteAverage;
  List<ItemImageClass> images;
  CreditsClass credits;

  SeasonDataClass(
    this.id,
    this.showID,
    this.name,
    this.cover,
    this.overview,
    this.userEpisodesStatus,
    this.seasonNum,
    this.episodes,
    this.episodesCount,
    this.airDate,
    this.voteAverage,
    this.images,
    this.credits,
  );

  factory SeasonDataClass.fromMap(Map map){
    return SeasonDataClass(
      map['id'],
      map['show_id'],
      map['name'], 
      map['poster_path'], 
      map['overview'], 
      List.generate(map['user_episodes_status'].length, (i) => UserEpisodeStatus.fromMap(map['user_episodes_status'][i])), 
      map['season_number'], 
      List.generate(map['episodes'].length, (i) => EpisodeDataClass.generateNewInstance(map['episodes'][i]['id']).fromMapBasic(map['episodes'][i])),
      map['episodes'].length,
      map['air_date'], 
      map['vote_average'], 
      List.generate(map['images'].length, (i) => ItemImageClass.fromMap(map['images'][i])), 
      CreditsClass.fromMap(map['credits']),
    );
  }

  factory SeasonDataClass.fromMapBasic(Map map){
    return SeasonDataClass(
      map['id'], 
      map['show_id'] ?? 0,
      map['name'], 
      map['poster_path'], 
      map['overview'], 
      [],
      map['season_number'], 
      [],
      map['episode_count'],
      map['air_date'], 
      map['vote_average'], 
      [], 
      CreditsClass.generateNewInstance(),
    );
  }

  factory SeasonDataClass.generateNewInstance(int id){
    return SeasonDataClass(
      id, 0, '', '', '', [], 0, [], 0, '', 0, [], CreditsClass.generateNewInstance()
    );
  }
}