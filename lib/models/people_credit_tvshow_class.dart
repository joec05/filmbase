class PeopleCreditTvShowCastClass{
  int id;
  String title;
  String originalTitle;
  String originalLanguage;
  List<String> originCountries;
  String overview;
  double popularity;
  String? cover;
  String firstAirDate;
  List<int> genres;
  double voteAverage;
  int voteCount;
  String character;
  int episodeCount;
  
  PeopleCreditTvShowCastClass(
    this.id, 
    this.title, 
    this.originalTitle,
    this.originalLanguage,
    this.originCountries,
    this.overview, 
    this.popularity, 
    this.cover,
    this.firstAirDate,
    this.genres,
    this.voteAverage, 
    this.voteCount,
    this.character,
    this.episodeCount
  );

  factory PeopleCreditTvShowCastClass.fromMap(Map map){
    return PeopleCreditTvShowCastClass(
      map['id'], 
      map['name'], 
      map['original_name'], 
      map['original_language'], 
      List<String>.from(map['origin_country']),
      map['overview'], 
      map['popularity'], 
      map['poster_path'], 
      map['first_air_date'],
      List<int>.from(map['genre_ids']), 
      map['vote_average'], 
      map['vote_count'], 
      map['character'],
      map['episode_count']
    );
  }
}


class PeopleCreditTvShowCrewClass{
  int id;
  String title;
  String originalTitle;
  String originalLanguage;
  List<String> originCountries;
  String overview;
  double popularity;
  String? cover;
  String firstAirDate;
  List<int> genres;
  double voteAverage;
  int voteCount;
  String? department;
  String? job;
  
  PeopleCreditTvShowCrewClass(
    this.id, 
    this.title, 
    this.originalTitle,
    this.originalLanguage,
    this.originCountries,
    this.overview, 
    this.popularity, 
    this.cover,
    this.firstAirDate,
    this.genres,
    this.voteAverage, 
    this.voteCount,
    this.department,
    this.job,
  );

  factory PeopleCreditTvShowCrewClass.fromMap(Map map){
    return PeopleCreditTvShowCrewClass(
      map['id'], 
      map['name'], 
      map['original_name'], 
      map['original_language'], 
      List<String>.from(map['origin_country']),
      map['overview'], 
      map['popularity'], 
      map['poster_path'], 
      map['first_air_date'],
      List<int>.from(map['genre_ids']), 
      map['vote_average'], 
      map['vote_count'], 
      map['department'],
      map['job'],
    );
  }
}