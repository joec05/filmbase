import 'package:filmbase/global_files.dart';

class MovieDataClass{
  int id;
  String title;
  String originalTitle;
  String originalLanguage;
  UserMovieTVStatus userMovieStatus;
  String overview;
  double? popularity;
  String? cover;
  bool adult;
  String? backdropPath;
  CollectionDataClass? collection;
  int budget;
  List<int> genres;
  String homepage;
  List<ProductionCompanyClass> productionCompanies;
  List<String> productionCountries;
  String? releaseDate;
  int revenue;
  int runtime;
  List<String> spokenLanguages;
  String status;
  String tagline;
  bool? video;
  double? voteAverage;
  int? voteCount;
  ImagesSectionsClass images;
  CreditsClass credits;
  List<String> keywords;
  List<ListDataClass> lists;
  List<int> recommendations;
  List<ItemReviewClass> reviews;
  List<int> similar;

  MovieDataClass(
    this.id, 
    this.title, 
    this.originalTitle,
    this.originalLanguage,
    this.userMovieStatus,
    this.overview, 
    this.popularity, 
    this.cover, 
    this.adult, 
    this.backdropPath, 
    this.collection,
    this.budget, 
    this.genres, 
    this.homepage, 
    this.productionCompanies, 
    this.productionCountries,
    this.releaseDate, 
    this.revenue, 
    this.runtime, 
    this.spokenLanguages, 
    this.status, 
    this.tagline, 
    this.video, 
    this.voteAverage, 
    this.voteCount,
    this.images,
    this.credits,
    this.keywords,
    this.lists,
    this.recommendations,
    this.reviews,
    this.similar,
  );

  MovieDataClass createDuplicate(){
    return MovieDataClass(
      id, title, originalTitle, originalLanguage, userMovieStatus,
      overview, popularity, cover, adult, backdropPath, collection,
      budget, genres, homepage, productionCompanies, productionCountries,
      releaseDate, revenue, runtime, spokenLanguages, status, tagline,
      video, voteAverage, voteCount, images, credits, keywords,
      lists, recommendations, reviews, similar
    );
  }

  MovieDataClass fromMapBasic(Map map){
    return MovieDataClass(
      map['id'], 
      map['title'], 
      map['original_title'], 
      map['original_language'], 
      map['user_movie_status'] == null ? userMovieStatus : UserMovieTVStatus.fromMap(map['user_movie_status']),
      map['overview'], 
      map['popularity'] is int ? map['popularity'].toDouble() : map['popularity'], 
      map['poster_path'], 
      map['adult'],
      map['backdrop_path'],
      collection,
      budget,
      map['genre_ids'] == null ? [] : List<int>.from(map['genre_ids']),
      homepage,
      productionCompanies,
      productionCountries,
      map['release_date'],
      revenue,
      runtime,
      spokenLanguages,
      status,
      tagline,
      map['video'], 
      map['vote_average'] is int ? map['vote_average'].toDouble() : map['vote_average'], 
      map['vote_count'],
      images,
      credits,
      keywords,
      lists,
      recommendations,
      reviews,
      similar,
    );
  }

  MovieDataClass fromMap(Map map){
    return MovieDataClass(
      map['id'], 
      map['title'], 
      map['original_title'], 
      map['original_language'], 
      UserMovieTVStatus.fromMap(map['user_movie_status']), 
      map['overview'], 
      map['popularity'] is int ? map['popularity'].toDouble() : map['popularity'], 
      map['poster_path'], 
      map['adult'], 
      map['backdrop_path'], 
      map['belongs_to_collection'] == null ? null : CollectionDataClass.fromMapBasic(map['belongs_to_collection']), 
      map['budget'], 
      List.generate(map['genres'].length, (i) => map['genres'][i]['id']), 
      map['homepage'], 
      List.generate(map['production_companies'].length, (i) => ProductionCompanyClass.fromMap(map['production_companies'][i])), 
      List.generate(map['production_countries'].length, (i) => map['production_countries'][i]['name']),
      map['release_date'],
      map['revenue'], 
      map['runtime'],
      List.generate(map['spoken_languages'].length, (i) => map['spoken_languages'][i]['name']),
      map['status'], 
      map['tagline'], 
      map['video'],
      map['vote_average'] is int ? map['vote_average'].toDouble() : map['vote_average'], 
      map['vote_count'], 
      ImagesSectionsClass.fromMap(map['images']),
      CreditsClass.fromMap(map['credits']),
      List.generate(map['keywords'].length, (i) => map['keywords'][i]['name']),
      List.generate(map['lists'].length, (i) => ListDataClass.generateNewInstance(map['lists'][i]['id']).fromMapBasic(map['lists'][i])),
      List.generate(map['recommendations'].length, (i) => map['recommendations'][i]['id']),
      List.generate(map['reviews'].length, (i) => ItemReviewClass.fromMap(map['reviews'][i])),
      List.generate(map['similar'].length, (i) => map['similar'][i]['id']), 
    );
  }

  factory MovieDataClass.generateNewInstance(int id){
    return MovieDataClass(
      id, '', '', '', UserMovieTVStatus.generateNewInstance(), '', 0, '', false, '',
      CollectionDataClass.generateNewInstance(), 0, [], '', [], [], '', 0, 0, [], '', '', 
      false, 0, 0, ImagesSectionsClass.generateNewInstance(),
      CreditsClass.generateNewInstance(), [], [], [], [], []
    );
  }
}