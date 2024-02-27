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
  late ListsController controller;

  @override
  void initState(){
    super.initState();
    controller = ListsController(context);
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
        controller.lists,
        controller.paginationStatus,
        controller.totalResults
      ]),
      builder: (context, child) {
        bool isLoading = controller.isLoading.value;
        List<int> lists = controller.lists.value;
        int totalResults = controller.totalResults.value;
        PaginationStatus paginationStatus = controller.paginationStatus.value;

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
                    onTap: () => controller.createListAlert(),
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
                  controller.paginate();
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
    );
  }
}