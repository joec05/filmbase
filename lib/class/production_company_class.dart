class ProductionCompanyClass{
  int id;
  String? cover;
  String name;
  String originCountry;

  ProductionCompanyClass(
    this.id,
    this.cover,
    this.name,
    this.originCountry
  );

  factory ProductionCompanyClass.fromMap(Map map){
    return ProductionCompanyClass(
      map['id'], 
      map['logo_path'], 
      map['name'], 
      map['origin_country']
    );
  }
}