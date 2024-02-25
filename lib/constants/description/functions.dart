String getFullDateDescription(String date){
  List<String> dates = date.split('-');
  List<String> months = [
    '', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December'
  ];

  return '${dates[2]} ${months[int.parse(dates[1])]} ${dates[0]}';
}