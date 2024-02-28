class UserMovieTVStatus{
  int id;
  bool favourite;
  double score;
  bool watchlisted;

  UserMovieTVStatus(
    this.id,
    this.favourite,
    this.score,
    this.watchlisted
  );

  factory UserMovieTVStatus.fromMap(Map map){
    return UserMovieTVStatus(
      map['id'], 
      map['favorite'],
      map['rated'] == false ? 0.toDouble() : map['rated']['value'], 
      map['watchlist']
    );
  }

  factory UserMovieTVStatus.generateNewInstance(){
    return UserMovieTVStatus(
      0, false, 0.5, false
    );
  }
}