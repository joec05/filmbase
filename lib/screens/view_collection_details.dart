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
  CollectionDataClass? collectionData;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchCollectionDetails();
  }

  @override
  void dispose(){
    super.dispose();
  }

  void fetchCollectionDetails() async{
    var res = await dio.get(
      '$mainAPIUrl/collection/${widget.collectionID}',
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      var data = res.data;
      var items = data['parts'];
      List<int> movies = [];
      List<int> tvShows = [];
      for(int i = 0; i < items.length; i++){
        if(items[i]['media_type'] == 'movie'){
          updateMovieBasicData(items[i]);
          movies.add(items[i]['id']);
        }else if(items[i]['media_type'] == 'tv'){
          updateTvSeriesBasicData(items[i]);
          tvShows.add(items[i]['id']);
        }
      }
      data['movies'] = movies;
      data['tv_shows'] = tvShows;
      var imagesReq = await dio.get(
        '$mainAPIUrl/collection/${widget.collectionID}/images',
        options: defaultAPIOption
      );
      if(imagesReq.statusCode == 200){
        data['images'] = [...imagesReq.data['backdrops'], ...imagesReq.data['posters']];
        if(mounted){
          setState(() {
            collectionData = CollectionDataClass.fromMap(data);
            isLoading = false;
          });
        }
      }else{
        if(mounted){
          handler.displaySnackbar(
            context, 
            SnackbarType.error, 
            tErr.api
          );
        }
      }
    }else{
      if(mounted){
        handler.displaySnackbar(
          context, 
          SnackbarType.error, 
          tErr.api
        );
      }
    }
  }

  @override
  Widget build(BuildContext context){
    if(!isLoading && collectionData != null){
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration
          ),
          title: setAppBarTitle('Collection Details'),
        ),
        body: CustomCollectionDetails(
          collectionData: collectionData!, 
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
}