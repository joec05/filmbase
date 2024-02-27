import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewCollectionDetails extends StatelessWidget {
  final int collectionID;

  const ViewCollectionDetails({
    super.key,
    required this.collectionID
  });

  @override
  Widget build(BuildContext context) {
    return _ViewCollectionDetailsStateful(
      collectionID: collectionID
    );
  }
}

class _ViewCollectionDetailsStateful extends StatefulWidget {
  final int collectionID;
  
  const _ViewCollectionDetailsStateful({
    required this.collectionID
  });

  @override
  State<_ViewCollectionDetailsStateful> createState() => _ViewCollectionDetailsStatefulState();
}

class _ViewCollectionDetailsStatefulState extends State<_ViewCollectionDetailsStateful>{
  late CollectionDetailsController controller;

  @override
  void initState(){
    super.initState();
    controller = CollectionDetailsController(context, widget.collectionID);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context){
    return ListenableBuilder(
      listenable: Listenable.merge([
        controller.isLoading,
        controller.collectionData
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        CollectionDataClass? collectionData = controller.collectionData.value;

        if(!isLoading && collectionData != null){
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: defaultAppBarDecoration
              ),
              title: setAppBarTitle('Collection Details'),
            ),
            body: CustomCollectionDetails(
              collectionData: collectionData, 
              skeletonMode: false
            )
          );
        }else{
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: defaultAppBarDecoration
              ),
              title: setAppBarTitle('Collection Details'),
            ),
            body: shimmerSkeletonWidget(
              CustomCollectionDetails(
                collectionData: CollectionDataClass.generateNewInstance(), 
                skeletonMode: true
              ),
            )
          );
        }
      }
    );
  }
}