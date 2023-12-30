class ItemImageClass{
  String url;
  double voteAverage;
  int voteCount;

  ItemImageClass(
    this.url,
    this.voteAverage,
    this.voteCount
  );

  factory ItemImageClass.fromMap(Map map){
    return ItemImageClass(
      map['file_path'],
      map['vote_average'], 
      map['vote_count']
    );
  }
}