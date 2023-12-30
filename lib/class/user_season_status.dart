class UserEpisodeStatus{
  int id;
  int episodesNum;
  int score;

  UserEpisodeStatus(
    this.id,
    this.episodesNum,
    this.score,
  );

  factory UserEpisodeStatus.fromMap(Map map){
    return UserEpisodeStatus(
      map['id'], 
      map['episode_number'], 
      map['rated'] == false ? 0 : map['rated']['value']
    );
  }
}