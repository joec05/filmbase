import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:filmbase/global_files.dart';
import 'package:readmore/readmore.dart';

class CustomListDetails extends StatefulWidget {
  final ListDataClass listData;
  final bool skeletonMode;

  const CustomListDetails({
    super.key,
    required this.listData,
    required this.skeletonMode
  });

  @override
  State<CustomListDetails> createState() => CustomListDetailsState();
}

class CustomListDetailsState extends State<CustomListDetails>{
  late ListDataClass listData;

  @override
  void initState(){
    super.initState();
    listData = widget.listData;
  }

  @override
  void dispose(){
    super.dispose();
  }

  void modifyItemsList() async{
    List<MediaItemClass> includedItems = [...listData.mediaItems.where((e) => e.mediaType == MediaType.movie).toList()];
    List<MediaItemClass> includedItemsOriginal = [...includedItems];
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulBuilderContext, setState){
            return AlertDialog(
              titlePadding: EdgeInsets.only(top: getScreenHeight() * 0.025),
              contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
              content: Container(
                constraints: BoxConstraints(
                  maxHeight: getScreenHeight() * 0.85
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getScreenWidth() * 0.035),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: listData.mediaItems.length,
                          itemBuilder: (context, i){
                            if(listData.mediaItems[i].mediaType == MediaType.movie){
                              MovieDataClass movieData = appStateRepo.globalMovies[listData.mediaItems[i].id]!.notifier.value;
                              return Row(
                                children: [
                                  Checkbox(
                                    value: includedItems.contains(listData.mediaItems[i]), 
                                    onChanged: (_){
                                      setState(() {
                                        if(includedItems.contains(listData.mediaItems[i])){
                                          includedItems.remove(listData.mediaItems[i]);
                                        }else{
                                          includedItems.add(listData.mediaItems[i]);
                                        }
                                      });
                                    }
                                  ),
                                  Flexible(child: Text(movieData.title, maxLines: 1, overflow: TextOverflow.ellipsis))
                                ]
                              );
                            }else if(listData.mediaItems[i].mediaType == MediaType.tvShow){
                              return Container();
                              /*
                              TvSeriesDataClass tvShowData = appStateRepo.globalTvSeries[listData.mediaItems[i].id]!.notifier.value;
                              return Row(
                                children: [
                                  Checkbox(
                                    value: includedItems.contains(listData.mediaItems[i]), 
                                    onChanged: (_){
                                      setState(() {
                                        if(includedItems.contains(listData.mediaItems[i])){
                                          includedItems.remove(listData.mediaItems[i]);
                                        }else{
                                          includedItems.add(listData.mediaItems[i]);
                                        }
                                      });
                                    }
                                  ),
                                  Flexible(child: Text(tvShowData.title, maxLines: 1, overflow: TextOverflow.ellipsis))
                                ]
                              );
                              */
                            }
                            return Container();
                          },
                        )
                      ),
                      SizedBox(
                        height: getScreenHeight() * 0.01
                      ),
                      CustomButton(
                        width: getScreenWidth() * 0.65, 
                        height: getScreenHeight() * 0.065, 
                        buttonColor: Colors.orange,
                        buttonText: 'Update', 
                        onTapped: (){
                          apiCallRepo.updateUserItemsList(
                            listData.id,
                            includedItemsOriginal,
                            includedItems
                          );
                          if(mounted){
                            apiCallRepo.updateUserItemsList(
                              listData.id, 
                              includedItemsOriginal, 
                              includedItems
                            );
                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Successfully updated')
                            ));
                          }
                        },
                        setBorderRadius: true
                      ),
                      SizedBox(
                        height: getScreenHeight() * 0.025
                      ),
                    ],
                  ),
                ),
              )
            );
          }
        );
      }
    );
  }

  void addMoviesList() async{
    List<MediaItemClass> searchedItems = [];
    List<MediaItemClass> selectedItems = [];
    TextEditingController searchController = TextEditingController();
    bool noItemsFound = false;
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulBuilderContext, setState){
            return AlertDialog(
              titlePadding: EdgeInsets.only(top: getScreenHeight() * 0.025),
              contentPadding: EdgeInsets.only(top: 0, bottom: getScreenHeight() * 0.025),
              content: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getScreenWidth() * 0.035),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: getScreenHeight() * 0.01
                      ),
                      TextField(
                        controller: searchController,
                        maxLines: 1,
                        maxLength: 30,
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.symmetric(horizontal: getScreenWidth() * 0.025),
                          fillColor: Colors.transparent,
                          filled: true,
                          hintText: 'Search anything',
                          suffixIcon: TextButton(
                            onPressed: () async{
                              if(searchController.text.isNotEmpty){
                                if(searchController.text.length < 4){
                                  handler.displaySnackbar(
                                    context,
                                    SnackbarType.error, 
                                    tErr.minSearchLength
                                  );
                                }else{
                                  var res = await dio.get(
                                    '$mainAPIUrl/search/movie?query=${searchController.text}&page=1',
                                    options: defaultAPIOption
                                  );
                                  if(res.statusCode == 200){
                                    List<MediaItemClass> searchedRes = [];
                                    var data = res.data['results'];
                                    for(int i = 0; i < data.length; i++){
                                      searchedRes.add(MediaItemClass(
                                        MediaType.movie,
                                        data[i]['id']
                                      ));
                                      updateMovieBasicData(data[i]);
                                    }
                                    setState((){
                                      noItemsFound = searchedRes.isEmpty;
                                      searchedItems = [...searchedRes];
                                    });
                                  }
                                }
                              }
                            },
                            child: const Icon(
                              FontAwesomeIcons.magnifyingGlass, 
                              size: 20, 
                              color: Colors.blue
                            )
                          ),
                          constraints: BoxConstraints(
                            maxWidth: getScreenWidth() * 0.75,
                            maxHeight: getScreenHeight() * 0.07,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.75), width: 2),
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.75), width: 2),
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                        )
                      ),
                      SizedBox(
                        height: searchedItems.isEmpty && !noItemsFound ? 0 : basicCoverDisplayWidgetSize.height * 1.3,
                        child: noItemsFound ?
                          Center(
                            child: Text(
                              'No movies found!!!',
                              style: TextStyle(
                                fontSize: defaultTextFontSize,
                                fontWeight: FontWeight.bold
                              )
                            )
                          )
                        :
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: searchedItems.length,
                          itemBuilder: (context, i){
                            if(listData.mediaItems.indexWhere((e) => e.id == searchedItems[i].id) > -1){
                              return Container();
                            }
                            MovieDataClass movieData = appStateRepo.globalMovies[searchedItems[i].id]!.notifier.value;
                            return Container(
                              width: basicCoverDisplayWidgetSize.width,
                              padding: EdgeInsets.only(
                                right: defaultHorizontalPadding
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: selectedItems.contains(searchedItems[i]), 
                                    onChanged: (_){
                                      setState(() {
                                        if(selectedItems.contains(searchedItems[i])){
                                          selectedItems.remove(searchedItems[i]);
                                        }else{
                                          selectedItems.add(searchedItems[i]);
                                        }
                                      });
                                    }
                                  ),
                                  SizedBox(
                                    width: basicCoverDisplayImageSize.width,
                                    height: basicCoverDisplayImageSize.height,
                                    child: generateCachedImage(movieData.cover)
                                  ), 
                                  Flexible(
                                    child: Text(
                                      movieData.title, 
                                      maxLines: 1, 
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: defaultTextFontSize * 0.75,
                                        fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ), 
                                ]
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: getScreenHeight() * 0.02
                      ),
                      CustomButton(
                        width: getScreenWidth() * 0.65, 
                        height: getScreenHeight() * 0.065, 
                        buttonColor: Colors.orange,
                        buttonText: 'Add', 
                        onTapped: (){
                          if(selectedItems.isEmpty){
                            Navigator.pop(dialogContext);
                          }else{
                            apiCallRepo.updateUserAddItemsList(
                              listData.id,
                              selectedItems
                            );
                            if(mounted){
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Successfully added')
                              ));
                            }
                          }
                        },
                        setBorderRadius: true
                      ),
                      SizedBox(
                        height: getScreenHeight() * 0.025
                      ),
                    ],
                  ),
                ),
              )
            );
          }
        );
      }
    );
  }

  void addTvShowsList() async{
    List<MediaItemClass> searchedItems = [];
    List<MediaItemClass> selectedItems = [];
    TextEditingController searchController = TextEditingController();
    bool noItemsFound = false;
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulBuilderContext, setState){
            return AlertDialog(
              titlePadding: EdgeInsets.only(top: getScreenHeight() * 0.025),
              contentPadding: EdgeInsets.only(top: 0, bottom: getScreenHeight() * 0.025),
              content: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getScreenWidth() * 0.035),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: getScreenHeight() * 0.01
                      ),
                      TextField(
                        controller: searchController,
                        maxLines: 1,
                        maxLength: 30,
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.symmetric(horizontal: getScreenWidth() * 0.025),
                          fillColor: Colors.transparent,
                          filled: true,
                          hintText: 'Search anything',
                          suffixIcon: TextButton(
                            onPressed: () async{
                              if(searchController.text.isNotEmpty){
                                if(searchController.text.length < 4){
                                  handler.displaySnackbar(
                                    context,
                                    SnackbarType.error, 
                                    tErr.minSearchLength
                                  );
                                }else{
                                  var res = await dio.get(
                                    '$mainAPIUrl/search/tv?query=${searchController.text}&page=1',
                                    options: defaultAPIOption
                                  );
                                  if(res.statusCode == 200){
                                    List<MediaItemClass> searchedRes = [];
                                    var data = res.data['results'];
                                    for(int i = 0; i < data.length; i++){
                                      searchedRes.add(MediaItemClass(
                                        MediaType.tvShow,
                                        data[i]['id']
                                      ));
                                      updateTvSeriesBasicData(data[i]);
                                    }
                                    setState((){
                                      noItemsFound = searchedRes.isEmpty;
                                      searchedItems = [...searchedRes];
                                    });
                                  }
                                }
                              }
                            },
                            child: const Icon(
                              FontAwesomeIcons.magnifyingGlass, 
                              size: 20, 
                              color: Colors.blue
                            )
                          ),
                          constraints: BoxConstraints(
                            maxWidth: getScreenWidth() * 0.75,
                            maxHeight: getScreenHeight() * 0.07,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.75), width: 2),
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.75), width: 2),
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                        )
                      ),
                      SizedBox(
                        height: searchedItems.isEmpty && !noItemsFound ? 0 : basicCoverDisplayWidgetSize.height * 1.3,
                        child: noItemsFound ?
                          Center(
                            child: Text(
                              'No TV shows found!!!',
                              style: TextStyle(
                                fontSize: defaultTextFontSize,
                                fontWeight: FontWeight.bold
                              )
                            )
                          )
                        :
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: searchedItems.length,
                          itemBuilder: (context, i){
                            if(listData.mediaItems.indexWhere((e) => e.id == searchedItems[i].id) > -1){
                              return Container();
                            }
                            TvSeriesDataClass tvShowData = appStateRepo.globalTvSeries[searchedItems[i].id]!.notifier.value;
                            return Container(
                              width: basicCoverDisplayWidgetSize.width,
                              padding: EdgeInsets.only(
                                right: defaultHorizontalPadding
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: selectedItems.contains(searchedItems[i]), 
                                    onChanged: (_){
                                      setState(() {
                                        if(selectedItems.contains(searchedItems[i])){
                                          selectedItems.remove(searchedItems[i]);
                                        }else{
                                          selectedItems.add(searchedItems[i]);
                                        }
                                      });
                                    }
                                  ),
                                  SizedBox(
                                    width: basicCoverDisplayImageSize.width,
                                    height: basicCoverDisplayImageSize.height,
                                    child: generateCachedImage(tvShowData.cover)
                                  ), 
                                  Flexible(
                                    child: Text(
                                      tvShowData.title, 
                                      maxLines: 1, 
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: defaultTextFontSize * 0.75,
                                        fontWeight: FontWeight.w600
                                      ),
                                    )
                                  ), 
                                ]
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: getScreenHeight() * 0.02
                      ),
                      CustomButton(
                        width: getScreenWidth() * 0.65, 
                        height: getScreenHeight() * 0.065, 
                        buttonColor: Colors.orange,
                        buttonText: 'Add', 
                        onTapped: (){
                          if(selectedItems.isEmpty){
                            Navigator.pop(dialogContext);
                          }else{
                            apiCallRepo.updateUserAddItemsList(
                              listData.id,
                              selectedItems
                            );
                            if(mounted){
                              Navigator.pop(dialogContext);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Successfully added')
                              ));
                            }
                          }
                        },
                        setBorderRadius: true
                      ),
                      SizedBox(
                        height: getScreenHeight() * 0.025
                      ),
                    ],
                  ),
                ),
              )
            );
          }
        );
      }
    );
  }

  void inquireAdd() async{
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          titlePadding: EdgeInsets.only(top: getScreenHeight() * 0.025),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    width: getScreenWidth() * 0.25, height: getScreenHeight() * 0.06, 
                    buttonColor: Colors.green, buttonText: 'Movie', 
                    onTapped: (){
                      if(mounted){
                        Navigator.pop(dialogContext);
                        addMoviesList();
                      }
                    }, 
                    setBorderRadius: true
                  ),
                  /*
                  CustomButton(
                    width: getScreenWidth() * 0.25, height: getScreenHeight() * 0.06, 
                    buttonColor: Colors.deepOrangeAccent, buttonText: 'TV Show', 
                    onTapped: (){
                      Navigator.pop(dialogContext);
                      addTvShowsList();
                    }, 
                    setBorderRadius: true
                  )
                  */
                ]
              )
            ]
          )
        );
      }
    );
  }

  void deleteListAlert() async{
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          titlePadding: EdgeInsets.only(top: getScreenHeight() * 0.025),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to delete this list?', style: TextStyle(
                fontSize: defaultTextFontSize * 0.95
              )),
              SizedBox(
                height: getScreenHeight() * 0.025
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    width: getScreenWidth() * 0.25, height: getScreenHeight() * 0.06, 
                    buttonColor: Colors.redAccent, buttonText: 'Yes', 
                    onTapped: (){
                      apiCallRepo.deleteList(listData.id);
                      if(mounted){
                        Navigator.pop(dialogContext);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Successfully deleted')
                        ));
                        Navigator.pop(context);
                      }
                    }, 
                    setBorderRadius: true
                  ),
                  CustomButton(
                    width: getScreenWidth() * 0.25, height: getScreenHeight() * 0.06, 
                    buttonColor: Colors.deepOrangeAccent, buttonText: 'No', 
                    onTapped: (){
                      Navigator.of(dialogContext).pop();
                    }, 
                    setBorderRadius: true
                  )
                ]
              )
            ]
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context){
    if(!widget.skeletonMode){
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: defaultHorizontalPadding,
          vertical: defaultVerticalPadding
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: detailDisplayCoverSize.width,
                  height: detailDisplayCoverSize.height,
                  child: generateCachedImage(listData.cover)
                ),
                SizedBox(
                  width: getScreenWidth() * 0.035
                ),
                Flexible(
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                StringEllipsis.convertToEllipsis(listData.name), 
                                style: TextStyle(
                                  fontSize: defaultTextFontSize,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getScreenHeight() * 0.0125,
                        ),
                        Text(
                          'Created by ${listData.creator ?? '?'}', 
                          style: TextStyle(
                            fontSize: defaultTextFontSize * 0.8,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${listData.mediaItems.where((e) => e.mediaType == MediaType.movie).toList().length} movies', 
                          style: TextStyle(
                            fontSize: defaultTextFontSize * 0.8,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${listData.mediaItems.where((e) => e.mediaType == MediaType.tvShow).toList().length} Tv shows', 
                          style: TextStyle(
                            fontSize: defaultTextFontSize * 0.8,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: getScreenHeight() * 0.0175,
                        ),
                        appStateRepo.currentUserData!.username == listData.creator ?
                          Row(
                            children: [
                              InkWell(
                              splashFactory: InkRipple.splashFactory,
                                onTap: () => modifyItemsList(),
                                child: Container(
                                  padding: const EdgeInsets.all(7.5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.8),
                                    borderRadius: const BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: const Icon(Icons.edit, size: 25)
                                ),
                              ),
                              SizedBox(
                                width: getScreenWidth() * 0.015
                              ),
                              InkWell(
                                splashFactory: InkRipple.splashFactory,
                                onTap: () => inquireAdd(),
                                child: Container(
                                  padding: const EdgeInsets.all(7.5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.8),
                                    borderRadius: const BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: const Icon(Icons.add, size: 25)
                                ),
                              ),
                              SizedBox(
                                width: getScreenWidth() * 0.015
                              ),
                              InkWell(
                                splashFactory: InkRipple.splashFactory,
                                onTap: () => deleteListAlert(),
                                child: Container(
                                  padding: const EdgeInsets.all(7.5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.8),
                                    borderRadius: const BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: const Icon(Icons.delete, size: 25)
                                ),
                              ),
                            ],
                          )
                        :
                          Container()
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: getScreenHeight() * 0.025,
            ),
            ReadMoreText(
              listData.description,
              trimLines: 5,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'More',
              trimExpandedText: ' Less',
              moreStyle: const TextStyle(fontSize: 14, color: Colors.blue),
              lessStyle: const TextStyle(fontSize: 14, color: Colors.blue),
            ),
            SizedBox(
              height: getScreenHeight() * 0.01,
            ),
          ]
        ),
      );
    }else{
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: defaultHorizontalPadding,
          vertical: defaultVerticalPadding
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: detailDisplayCoverSize.width,
                  height: detailDisplayCoverSize.height,
                  color: Colors.grey
                ),
                SizedBox(
                  width: getScreenWidth() * 0.035
                ),
                Flexible(
                  child: Container(
                    height: detailDisplayCoverSize.height,
                    color: Colors.grey
                  )
                ),
              ],
            ),
            SizedBox(
              height: getScreenHeight() * 0.025,
            ),
            Container(
              height: getScreenHeight() * 0.15,
              color: Colors.grey,
            ),
            SizedBox(
              height: getScreenHeight() * 0.01,
            ),
          ]
        ),
      );
    }
  }
}

