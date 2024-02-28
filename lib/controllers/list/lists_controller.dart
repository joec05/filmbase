import 'dart:async';
import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ListsController {
  final BuildContext context;
  ValueNotifier<List<int>> lists = ValueNotifier([]);
  ValueNotifier<int> totalResults = ValueNotifier(0);
  ValueNotifier<PaginationStatus> paginationStatus = ValueNotifier(PaginationStatus.loaded);
  late StreamSubscription updateListsStreamClassSubscription; 
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  ListsController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController() {
    fetchLists(1);
    updateListsStreamClassSubscription = UpdateListsStreamClass().updateListsStream.listen((ListsStreamControllerClass data){
      if(mounted){
        if(data.actionType == UpdateStreamActionType.add){
          if(!lists.value.contains(data.itemID)){
            lists.value.insert(0, data.itemID);
            lists.value = [...lists.value];
          }
        }else if(data.actionType == UpdateStreamActionType.delete){
          if(lists.value.contains(data.itemID)){
            lists.value.remove(data.itemID);
            lists.value = [...lists.value];
          }
        }
      }
    });
  }

  void dispose(){
    updateListsStreamClassSubscription.cancel();
    lists.dispose();
    totalResults.dispose();
    paginationStatus.dispose();
    isLoading.dispose();
  }

  void fetchLists(int page) async{
    List<int> getListsData = await runFetchAPI(
      '$mainAPIUrl/account/${appStateRepo.apiIdentifiers.userID}/lists?page=$page'
    );

    if(mounted){
      lists.value = [...lists.value, ...getListsData];
      paginationStatus.value = PaginationStatus.loaded;
      isLoading.value = false;
    }
  }

  void paginate() async{
    if(mounted){
      paginationStatus.value = PaginationStatus.loading;
      Future.delayed(Duration(milliseconds: paginateDelayDuration), (){
        fetchLists(
          lists.value.length ~/ 20 + 1
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
      totalResults.value = res.data['total_results'];
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
}