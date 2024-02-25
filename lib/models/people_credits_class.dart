import 'package:filmbase/models/people_credit_movie_class.dart';
import 'package:filmbase/models/people_credit_tvshow_class.dart';

class PeopleCreditsClass{
  List<PeopleCreditMovieCastClass> moviesCast;
  List<PeopleCreditMovieCrewClass> moviesCrew;
  List<PeopleCreditTvShowCastClass> tvShowsCast;
  List<PeopleCreditTvShowCrewClass> tvShowsCrew;

  PeopleCreditsClass(
    this.moviesCast,
    this.moviesCrew,
    this.tvShowsCast,
    this.tvShowsCrew
  );

  factory PeopleCreditsClass.fromMap(Map map){
    return PeopleCreditsClass(
      List.generate(map['movies_credits']['cast'].length, (i) => PeopleCreditMovieCastClass.fromMap(map['movies_credits']['cast'][i])),
      List.generate(map['movies_credits']['crew'].length, (i) => PeopleCreditMovieCrewClass.fromMap(map['movies_credits']['crew'][i])),
      List.generate(map['tv_shows_credits']['cast'].length, (i) => PeopleCreditTvShowCastClass.fromMap(map['tv_shows_credits']['cast'][i])),
      List.generate(map['tv_shows_credits']['crew'].length, (i) => PeopleCreditTvShowCrewClass.fromMap(map['tv_shows_credits']['crew'][i]))
    );
  }

  factory PeopleCreditsClass.generateNewInstance(){
    return PeopleCreditsClass(
      [], [], [], []
    );
  }
}