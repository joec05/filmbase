import 'dart:async';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewLists extends StatelessWidget {

  const ViewLists({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return const ViewListsStateful();
  }
}

class ViewListsStateful extends StatefulWidget {

  const ViewListsStateful({
    super.key
  });

  @override
  State<ViewListsStateful> createState() => _ViewListsStatefulState();
}

class _ViewListsStatefulState extends State<ViewListsStateful>{
  List<int> lists = [];
  int totalResults = 0;
  PaginationStatus paginationStatus = PaginationStatus.loaded;
  late StreamSubscription updateListsStreamClassSubscription; 
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    fetchLists(1);
    updateListsStreamClassSubscription = UpdateListsStreamClass().updateListsStream.listen((ListsStreamControllerClass data){
      if(mounted){
        if(data.actionType == UpdateStreamActionType.add){
          if(!lists.contains(data.itemID)){
            setState(() => lists.insert(0, data.itemID));
          }
        }else if(data.actionType == UpdateStreamActionType.delete){
          if(lists.contains(data.itemID)){
            setState(() => lists.remove(data.itemID));
          }
        }
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    updateListsStreamClassSubscription.cancel();
  }

  void fetchLists(int page) async{
    List<int> getListsData = await runFetchAPI(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/lists?page=$page'
    );

    if(mounted){
      setState(() {
        lists.addAll(getListsData);
        paginationStatus = PaginationStatus.loaded;
        isLoading = false;
      });
    }
  }

  void paginate() async{
    if(mounted){
      setState(() => paginationStatus = PaginationStatus.loading);
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchLists(
          lists.length ~/ 20 + 1
        );
      });
    }
  }

  Future<List<int>> runFetchAPI(String url) async{
    List<int> lists = [];
    var res = await dio.get(
      url,
      options: defaultAPIOption
    );
    if(res.statusCode == 200){
      totalResults = res.data['total_results'];
      var data = res.data['results'];
      for(int i = 0; i < data.length; i++){
        updateListData(data[i]);
        lists.add(data[i]['id']);
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
    return lists;
  }

  void createListAlert(){
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulBuilderContext, setState){
            return AlertDialog(
              title: const Text('Create list', textAlign: TextAlign.center),
              titlePadding: EdgeInsets.only(top: getScreenHeight() * 0.025),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      maxLength: 30,
                      minLines: 1,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Enter list name',
                        fillColor: Colors.brown.withOpacity(0.4),
                        prefixIcon: const Icon(Icons.list),
                        counterText: '',
                        filled: true,
                        border: InputBorder.none,
                        constraints: BoxConstraints(
                          maxWidth: getScreenWidth() * 0.75,
                          maxHeight: getScreenHeight() * 0.07,
                        ),
                      )
                    ),
                    SizedBox(
                      height: getScreenHeight() * 0.025
                    ),
                    TextField(
                      controller: descriptionController,
                      maxLength: 150,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter list description',
                        fillColor: Colors.brown.withOpacity(0.4),
                        prefixIcon: const Icon(Icons.description),
                        counterText: '',
                        filled: true,
                        border: InputBorder.none,
                        constraints: BoxConstraints(
                          maxWidth: getScreenWidth() * 0.75,
                          maxHeight: getScreenHeight() * 0.2,
                        ),
                      )
                    ),
                    SizedBox(
                      height: getScreenHeight() * 0.025
                    ),
                    CustomButton(
                      width: getScreenWidth() * 0.65, 
                      height: getScreenHeight() * 0.065, 
                      buttonColor: Colors.orange,
                      buttonText: 'Create list', 
                      onTapped: (){
                        apiCallRepo.createUserList(
                          nameController.text.trim(),
                          descriptionController.text.trim()
                        );
                        if(mounted){
                          Navigator.pop(dialogContext);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Successfully created')
                          ));
                        }
                      },
                      setBorderRadius: true
                    ),
                    SizedBox(
                      height: getScreenHeight() * 0.025
                    ),
                  ]
                ),
              )
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context){
    if(!isLoading){
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Lists'),
              InkWell(
                splashFactory: InkRipple.splashFactory,
                onTap: () => createListAlert(),
                child: const Icon(Icons.add, size: 25)
              )
            ]
          ),
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration,
          ),
        ),
        body: LoadMoreBottom(
          addBottomSpace: lists.length < totalResults,
          loadMore: () async{
            if(lists.length < totalResults){
              paginate();
            }
          },
          status: paginationStatus,
          refresh: null,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverList(delegate: SliverChildBuilderDelegate(
                childCount: lists.length, 
                (c, i) {
                  if(appStateRepo.globalLists[lists[i]] == null){
                    return Container();
                  }
                  return ValueListenableBuilder(
                    valueListenable: appStateRepo.globalLists[lists[i]]!.notifier,
                    builder: (context, listData, child){
                      return CustomListDisplay(
                        listData: listData,
                        skeletonMode: false,
                        key: UniqueKey()
                      );
                    },
                  );
                },
              )),
            ],
          ),
        )
      );
    }else{
      return Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Lists'),
              Icon(Icons.add, size: 25)
            ]
          ),
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration,
          ),
        ),
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverList(delegate: SliverChildBuilderDelegate(
              childCount: shimmerDefaultLength, 
              (c, i) {
                return shimmerSkeletonWidget(
                  CustomListDisplay(
                    listData: ListDataClass.generateNewInstance(-1),
                    skeletonMode: true,
                    key: UniqueKey()
                  ),
                );
              },
            )),
          ],
        )
      );
    }
  }
}