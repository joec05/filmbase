String getTimeDifference(String time){
  DateTime parse = DateTime.parse(time);
  Duration difference = DateTime.now().difference(parse);
  int inSeconds = difference.inSeconds;
  int inMinutes = difference.inMinutes;
  int inHours = difference.inHours;
  int inDays = difference.inDays;
  if(inDays > 365){
    int year = (inDays / 365).floor();
    return year <= 1 ? '1 year ago' : '$year years ago';
  }else if(inDays > 30){
    int month = (inDays / 30).floor();
    return month <= -1 ? '1 month ago' : '$month months ago';
  }else if(inDays >= 1){
    return inDays < -1 ? '1 day ago' : '$inDays days ago';
  }else if(inHours >= 1){
    return inHours < -1 ? '1 hour ago' : '$inHours hour ago';
  }else if(inMinutes >= 1){
    return inMinutes < -1 ? '1 minute ago' : '$inMinutes minutes ago';
  }else{
    return inSeconds < -1 ? '1 second ago' : '$inSeconds seconds ago';
  }
}

String getLastDayOfMonth(){
  DateTime now = DateTime.now();
  DateTime lastDayOfThisMonth = DateTime(
    now.month == 12 ? now.year + 1 : now.year, 
    now.month + 1 <= 12 ? now.month + 1 : 1, 
    1
  ).subtract(const Duration(seconds: 1));
  String stringified = lastDayOfThisMonth.toIso8601String();
  return stringified.split(' ')[0];
}

String getFirstDayOfMonth(){
  DateTime thisMonth = DateTime.now();
  DateTime firstDayOfThisMonth = DateTime(thisMonth.year, thisMonth.month, 1);
  String stringified = firstDayOfThisMonth.toIso8601String();
  return stringified.split(' ')[0];
}

String getLastDayOfNextMonth(){
  DateTime now = DateTime.now();
  DateTime nextTwoMonths = DateTime(
    now.month == 11 ? now.year + 1 : now.year, 
    now.month + 2 <= 12 ? now.month + 2 : (now.month + 2) % 12, 
    1
  );
  DateTime lastDayOfNextMonth = DateTime(nextTwoMonths.year, nextTwoMonths.month, 1).subtract(const Duration(seconds: 1));
  String stringified = lastDayOfNextMonth.toIso8601String();
  return stringified.split(' ')[0];
}

String getFirstDayOfNextMonth(){
  DateTime now = DateTime.now();
  DateTime firstDayOfNextMonth = DateTime(
    now.month == 12 ? now.year + 1 : now.year,
    now.month + 1 <= 12 ? now.month + 1 : 1, 
    1
  );
  String stringified = firstDayOfNextMonth.toIso8601String();
  return stringified.split(' ')[0];
}