import 'package:filmbase/global_files.dart';

class EpisodeDataClass{
  int id;
  int showID;
  String name;
  String overview;
  String airDate;
  int? runtime;
  int seasonNum;
  int episodeNum;
  double rating;
  double? voteAverage;
  int? voteCount;
  String productionCode;
  String? stillPath;
  List<CreditsCastClass> casts;
  List<CreditsCrewClass> crews;
  List<CreditsCastClass> guestStars;
  List<ItemImageClass> images;

  EpisodeDataClass(
    this.id,
    this.showID,
    this.name,
    this.overview,
    this.airDate,
    this.runtime,
    this.seasonNum,
    this.episodeNum,
    this.rating,
    this.voteAverage,
    this.voteCount,
    this.productionCode,
    this.stillPath,
    this.casts,
    this.crews,
    this.guestStars,
    this.images
  );

  EpisodeDataClass createDuplicate(){
    return EpisodeDataClass(
      id, showID, name, overview, airDate, runtime, seasonNum, episodeNum,
      rating, voteAverage, voteCount, productionCode, stillPath, casts,
      crews, guestStars, images
    );
  }

  EpisodeDataClass fromMap(Map map){
    return EpisodeDataClass(
      map['id'], 
      map['show_id'],
      map['name'], 
      map['overview'], 
      map['air_date'],
      map['runtime'], 
      map['season_number'], 
      map['episode_number'],
      map['rating'] ?? 0.0, 
      map['vote_average'], 
      map['vote_count'], 
      map['production_code'], 
      map['still_path'] ?? stillPath, 
      List.generate(map['casts'].length, (i) => CreditsCastClass.fromMap(map['casts'][i])),
      List.generate(map['crews'].length, (i) => CreditsCrewClass.fromMap(map['crews'][i])),
      List.generate(map['guest_stars'].length, (i) => CreditsCastClass.fromMap(map['guest_stars'][i])),
      List.generate(map['images'].length, (i) => ItemImageClass.fromMap(map['images'][i]))
    );
  }

  EpisodeDataClass fromMapBasic(Map map){
    return EpisodeDataClass(
      map['id'], 
      map['show_id'],
      map['name'], 
      map['overview'], 
      map['air_date'] ?? '', 
      map['runtime'], 
      map['season_number'], 
      map['episode_number'], 
      map['rating'] ?? 0, 
      map['vote_average'], 
      map['vote_count'], 
      map['production_code'], 
      map['still_path'],
      casts,
      crews,
      guestStars,
      images,
    );
  }

  factory EpisodeDataClass.generateNewInstance(int id){
    return EpisodeDataClass(
      id, 0, '', '', '', 0, 0, 0, 0.5, 0, 0, '', '', [], [], [], []
    );
  }
}