import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewFavourites extends StatelessWidget {
  final int initialIndex;

  const ViewFavourites({
    super.key,
    required this.initialIndex
  });

  @override
  Widget build(BuildContext context) {
    return ViewFavouritesStateful(
      initialIndex: initialIndex
    );
  }
}

class ViewFavouritesStateful extends StatefulWidget {
  final int initialIndex;

  const ViewFavouritesStateful({
    super.key,
    required this.initialIndex
  });

  @override
  State<ViewFavouritesStateful> createState() => _ViewFavouritesStatefulState();
}

class _ViewFavouritesStatefulState extends State<ViewFavouritesStateful> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override void initState(){
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialIndex);
  }

  @override void dispose(){
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: defaultLeadingWidget(context),
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: setAppBarTitle('Favourites'),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, bool f) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                floating: true, 
                expandedHeight: 50,
                pinned: true,
                automaticallyImplyLeading: false,
                bottom: TabBar(
                  onTap: (selectedIndex) {
                  },
                  isScrollable: false,
                  controller: _tabController,
                  labelColor: Colors.blueGrey,
                  indicatorColor: Colors.lightGreen,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3.0,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: 'Movies'),
                    Tab(text: 'TV Shows'),
                  ],
                )                           
            ),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            ViewFavouriteMovies(
              key: UniqueKey()
            ),
            ViewFavouriteTvShows(
              key: UniqueKey(),
            )
          ]
        )
      )
    );
  }
}