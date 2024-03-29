import 'package:filmbase/global_files.dart';

class CreditsClass{
  List<CreditsCastClass> casts;
  List<CreditsCrewClass> crews;

  CreditsClass(
    this.casts,
    this.crews
  );

  factory CreditsClass.fromMap(Map map){
    return CreditsClass(
      List.generate(map['cast'].length, (i) => CreditsCastClass.fromMap(map['cast'][i])), 
      List.generate(map['crew'].length, (i) => CreditsCrewClass.fromMap(map['crew'][i])), 
    );
  }

  factory CreditsClass.generateNewInstance(){
    return CreditsClass(
      [], []
    );
  }
}