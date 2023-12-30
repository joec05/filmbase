class TvSeriesCreator{
  final int id;
  final String name;
  final String? cover;

  TvSeriesCreator(
    this.id,
    this.name,
    this.cover
  );

  factory TvSeriesCreator.fromMap(Map map){
    return TvSeriesCreator(
      map['id'], 
      map['name'], 
      map['profile_path']
    );
  }
}