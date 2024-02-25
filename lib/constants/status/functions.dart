String getTvShowStatus(String status){
  if(status == 'Returning Series'){
    return 'Ongoing';
  }else{
    return status;
  }
}