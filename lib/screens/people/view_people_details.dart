import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewPeopleDetails extends StatelessWidget {
  final int personID;

  const ViewPeopleDetails({
    super.key,
    required this.personID
  });

  @override
  Widget build(BuildContext context) {
    return _ViewPeopleDetailsStateful(
      personID: personID
    );
  }
}

class _ViewPeopleDetailsStateful extends StatefulWidget {
  final int personID;
  
  const _ViewPeopleDetailsStateful({
    required this.personID
  });

  @override
  State<_ViewPeopleDetailsStateful> createState() => _ViewPeopleDetailsStatefulState();
}

class _ViewPeopleDetailsStatefulState extends State<_ViewPeopleDetailsStateful>{
  late PeopleDetailsController controller;

  @override
  void initState(){
    super.initState();
    controller = PeopleDetailsController(context, widget.personID);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: controller.isLoading,
      builder: (context, isLoading, child) {
        if(!isLoading && appStateRepo.globalPeople[widget.personID] != null){
          return Scaffold(
            appBar: AppBar(
              title: setAppBarTitle('People'),
              flexibleSpace: Container(
                decoration: defaultAppBarDecoration
              ),
            ),
            body: ValueListenableBuilder(
              valueListenable: appStateRepo.globalPeople[widget.personID]!.notifier,
              builder: (context, peopleData, child){
                return CustomPeopleDetails(
                  peopleData: peopleData, 
                  skeletonMode: false,
                  key: UniqueKey()
                );
              },
            )
          );
        }else{
          return Scaffold(
            appBar: AppBar(
              title: setAppBarTitle('People'),
              flexibleSpace: Container(
                decoration: defaultAppBarDecoration
              ),
            ),
            body: shimmerSkeletonWidget(
              CustomPeopleDetails(
                peopleData: PeopleDataClass.generateNewInstance(-1), 
                skeletonMode: true,
                key: UniqueKey()
              ),
            )
          );
        }
      }
    );
  }
}