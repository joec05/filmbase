int getAge(String birthDate){
  List<String> birthDateList = birthDate.split('-');
  int getDifference = DateTime.now().difference(DateTime(int.parse(birthDateList[0]), int.parse(birthDateList[1]), int.parse(birthDateList[2]))).inDays;
  return (getDifference / 365).floor();
}