import 'package:filmbase/global_files.dart';

class TvSeriesDataClass{
  int id;
  String title;
  String originalTitle;
  String originalLanguage;
  UserMovieTVStatus userTvSeriesStatus;
  String overview;
  double popularity;
  String? cover;
  String type;
  List<String> ratings;
  bool adult;
  String? backdropPath;
  List<TvSeriesCreator> creators;
  List<int> episodeRunTime;
  String firstAirDate;
  String? lastAirDate;
  List<int> genres;
  String homepage;
  bool inProduction;
  List<String> languages;
  EpisodeDataClass? lastEpisodeAired;
  EpisodeDataClass? nextEpisodeAired;
  List<NetworkDataClass> networks;
  int seasonsNum;
  int episodesNum;
  List<String> originCountries;
  List<ProductionCompanyClass> productionCompanies;
  List<String> productionCountries;
  List<SeasonDataClass> seasons;
  List<String> spokenLanguages;
  String status;
  String tagline;
  double? voteAverage;
  int? voteCount;
  ImagesSectionsClass images;
  CreditsClass credits;
  List<String> keywords;
  List<int> recommendations;
  List<ItemReviewClass> reviews;
  List<int> similar;

  TvSeriesDataClass(
    this.id,
    this.title,
    this.originalTitle,
    this.originalLanguage,
    this.userTvSeriesStatus,
    this.overview,
    this.popularity,
    this.cover,
    this.type,
    this.ratings,
    this.adult,
    this.backdropPath,
    this.creators,
    this.episodeRunTime,
    this.firstAirDate,
    this.lastAirDate,
    this.genres,
    this.homepage,
    this.inProduction,
    this.languages,
    this.lastEpisodeAired,
    this.nextEpisodeAired,
    this.networks,
    this.seasonsNum,
    this.episodesNum,
    this.originCountries,
    this.productionCompanies,
    this.productionCountries,
    this.seasons,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.voteAverage,
    this.voteCount,
    this.images,
    this.credits,
    this.keywords,
    this.recommendations,
    this.reviews,
    this.similar,
  );

  TvSeriesDataClass createDuplicate(){
    return TvSeriesDataClass(
      id, title, originalTitle, originalLanguage, userTvSeriesStatus,
      overview, popularity, cover, type, ratings, adult,
      backdropPath, creators, episodeRunTime, firstAirDate, lastAirDate,
      genres, homepage, inProduction, languages, lastEpisodeAired,
      nextEpisodeAired, networks, seasonsNum, episodesNum, originCountries,
      productionCompanies, productionCountries, seasons, spokenLanguages,
      status, tagline, voteAverage, voteCount, images, credits, keywords,
      recommendations, reviews, similar
    );
  }

  TvSeriesDataClass fromMapBasic(Map map){
    return TvSeriesDataClass(
      map['id'], 
      map['name'], 
      map['original_name'], 
      map['original_language'], 
      userTvSeriesStatus,
      map['overview'], 
      map['popularity'] is int ? map['popularity'].toDouble() : map['popularity'], 
      map['poster_path'], 
      type,
      ratings,
      adult,
      map['backdrop_path'],
      creators,
      episodeRunTime,
      map['first_air_date'],
      lastAirDate,
      map['genre_ids'] == null ? genres : List.generate(map['genre_ids'].length, (i) => map['genre_ids'][i]),
      homepage,
      inProduction,
      languages,
      lastEpisodeAired,
      nextEpisodeAired,
      networks,
      seasonsNum,
      episodesNum,
      List<String>.from(map['origin_country']),
      productionCompanies,
      productionCountries,
      seasons,
      spokenLanguages,
      status,
      tagline,
      map['vote_average'] is int ? map['vote_average'].toDouble() : map['vote_average'], 
      map['vote_count'],
      images,
      credits,
      keywords,
      recommendations,
      reviews,
      similar,
    );
  }

  TvSeriesDataClass fromMap(Map map){
    return TvSeriesDataClass(
      map['id'], 
      map['name'], 
      map['original_name'], 
      map['original_language'], 
      UserMovieTVStatus.fromMap(map['user_movie_status']),
      map['overview'],
      map['popularity'] is int ? map['popularity'].toDouble() : map['popularity'],  
      map['poster_path'], 
      map['type'], 
      List.generate(map['ratings'].length, (i) => map['ratings'][i]['rating']), 
      map['adult'], 
      map['backdrop_path'], 
      List.generate(map['created_by'].length, (i) => TvSeriesCreator.fromMap(map['created_by'][i])),
      List<int>.from(map['episode_run_time']), 
      map['first_air_date'], 
      map['last_air_date'],
      List.generate(map['genres'].length, (i) => map['genres'][i]['id']),
      map['homepage'], 
      map['in_production'], 
      List<String>.from(map['languages']), 
      map['last_episode_to_air'] == null ? null : EpisodeDataClass.generateNewInstance(map['last_episode_to_air']['id']).fromMapBasic(map['last_episode_to_air'],),
      map['next_episode_to_air'] == null ? null : EpisodeDataClass.generateNewInstance(map['next_episode_to_air']['id']).fromMapBasic(map['next_episode_to_air']), 
      List.generate(map['networks'].length, (i) => NetworkDataClass.generateNewInstance().fromMapBasic(map['networks'][i])),
      map['number_of_seasons'], 
      map['number_of_episodes'], 
      List<String>.from(map['origin_country']),
      List.generate(map['production_companies'].length, (i) => ProductionCompanyClass.fromMap(map['production_companies'][i])), 
      List.generate(map['production_countries'].length, (i) => map['production_countries'][i]['name']),
      List.generate(map['seasons'].length, (i) => SeasonDataClass.fromMapBasic(map['seasons'][i])),
      List.generate(map['spoken_languages'].length, (i) => map['spoken_languages'][i]['name']),
      map['status'], 
      map['tagline'],
      map['vote_average'] is int ? map['vote_average'].toDouble() : map['vote_average'], 
      map['vote_count'],
      ImagesSectionsClass.fromMap(map['images']),
      CreditsClass.fromMap(map['credits']),
      List.generate(map['keywords'].length, (i) => map['keywords'][i]['name']),
      List.generate(map['recommendations'].length, (i) => map['recommendations'][i]['id']),
      List.generate(map['reviews'].length, (i) => ItemReviewClass.fromMap(map['reviews'][i])),
      List.generate(map['similar'].length, (i) => map['similar'][i]['id']), 
    );
  }

  factory TvSeriesDataClass.generateNewInstance(int id){
    return TvSeriesDataClass(
      id, '', '', '', UserMovieTVStatus.generateNewInstance(), '', 0, '', '', 
      [], false, '', [], [], '', '', [], '', false, [], EpisodeDataClass.generateNewInstance(-1), 
      EpisodeDataClass.generateNewInstance(-1), [], 0, 0, [], [], [], [], [], '', '', 0, 0, 
      ImagesSectionsClass.generateNewInstance(), 
      CreditsClass.generateNewInstance(), [], [], [], []
    );
  }
}