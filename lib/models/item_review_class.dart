class ItemReviewClass{
  String id;
  String author;
  String name;
  String username;
  String? cover;
  double? score;
  String content;
  String creationTime;
  String updatedTime;
  String url;

  ItemReviewClass(
    this.id,
    this.author,
    this.name,
    this.username,
    this.cover,
    this.score,
    this.content,
    this.creationTime,
    this.updatedTime,
    this.url
  );
  
  factory ItemReviewClass.fromMap(Map map){
    return ItemReviewClass(
      map['id'], 
      map['author'], 
      map['author_details']['name'], 
      map['author_details']['username'],
      map['author_details']['avatar_path'], 
      map['author_details']['rating'] is String ? double.parse(map['author_details']['rating']) : map['author_details']['rating'] is int ? map['author_details']['rating'].toDouble() : map['author_details']['rating'], 
      map['content'], 
      map['created_at'], 
      map['updated_at'], 
      map['url']
    );
  }

  factory ItemReviewClass.generateNewInstance(){
    return ItemReviewClass(
      '', '', '', '', '', 0, '', '', '', ''
    );
  }
}