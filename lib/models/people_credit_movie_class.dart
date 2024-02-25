class PeopleCreditMovieCastClass{
  int id;
  String title;
  String originalTitle;
  String originalLanguage;
  String overview;
  double popularity;
  String? cover;
  String releaseDate;
  List<int> genres;
  double voteAverage;
  int voteCount;
  String character;
  int order;
  
  PeopleCreditMovieCastClass(
    this.id, 
    this.title, 
    this.originalTitle,
    this.originalLanguage,
    this.overview, 
    this.popularity, 
    this.cover,
    this.releaseDate,
    this.genres,
    this.voteAverage, 
    this.voteCount,
    this.character,
    this.order
  );

  factory PeopleCreditMovieCastClass.fromMap(Map map){
    return PeopleCreditMovieCastClass(
      map['id'], 
      map['title'], 
      map['original_title'], 
      map['original_language'], 
      map['overview'], 
      map['popularity'], 
      map['poster_path'], 
      map['release_date'],
      List<int>.from(map['genre_ids']),
      map['vote_average'], 
      map['vote_count'], 
      map['character'],
      map['order']
    );
  }
}


class PeopleCreditMovieCrewClass{
  int id;
  String title;
  String originalTitle;
  String originalLanguage;
  String overview;
  double popularity;
  String? cover;
  String releaseDate;
  List<int> genres;
  double voteAverage;
  int voteCount;
  String? department;
  String? job;
  
  PeopleCreditMovieCrewClass(
    this.id, 
    this.title, 
    this.originalTitle,
    this.originalLanguage,
    this.overview, 
    this.popularity, 
    this.cover,
    this.releaseDate,
    this.genres,
    this.voteAverage, 
    this.voteCount,
    this.department,
    this.job
  );

  factory PeopleCreditMovieCrewClass.fromMap(Map map){
    return PeopleCreditMovieCrewClass(
      map['id'], 
      map['title'], 
      map['original_title'], 
      map['original_language'], 
      map['overview'], 
      map['popularity'], 
      map['poster_path'], 
      map['release_date'],
      List<int>.from(map['genre_ids']), 
      map['vote_average'], 
      map['vote_count'], 
      map['department'],
      map['job']
    );
  }
}