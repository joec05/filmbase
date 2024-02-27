import 'package:flutter/material.dart';
import 'package:filmbase/global_files.dart';

class ViewWatchlist extends StatelessWidget {
  final int initialIndex;

  const ViewWatchlist({
    super.key,
    required this.initialIndex
  });

  @override
  Widget build(BuildContext context) {
    return ViewWatchlistStateful(
      initialIndex: initialIndex
    );
  }
}

class ViewWatchlistStateful extends StatefulWidget {
  final int initialIndex;

  const ViewWatchlistStateful({
    super.key,
    required this.initialIndex
  });

  @override
  State<ViewWatchlistStateful> createState() => _ViewWatchlistStatefulState();
}

class _ViewWatchlistStatefulState extends State<ViewWatchlistStateful> with SingleTickerProviderStateMixin{
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
        title: setAppBarTitle('Watchlist'),
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        leading: defaultLeadingWidget(context),
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
                  labelColor: Colors.grey,
                  indicatorColor: Colors.orange,
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
            ViewWatchlistMovies(
              key: UniqueKey()
            ),
            ViewWatchlistTvShows(
              key: UniqueKey(),
            )
          ]
        )
      )
    );
  }
}