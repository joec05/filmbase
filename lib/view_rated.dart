import 'package:flutter/material.dart';
import 'package:filmbase/styles/app_styles.dart';
import 'package:filmbase/view_rated_episodes.dart';
import 'package:filmbase/view_rated_movies.dart';
import 'package:filmbase/view_rated_tv_shows.dart';

class ViewRated extends StatelessWidget {
  final int initialIndex;

  const ViewRated({
    super.key,
    required this.initialIndex
  });

  @override
  Widget build(BuildContext context) {
    return ViewRatedStateful(
      initialIndex: initialIndex
    );
  }
}

class ViewRatedStateful extends StatefulWidget {
  final int initialIndex;

  const ViewRatedStateful({
    super.key,
    required this.initialIndex
  });

  @override
  State<ViewRatedStateful> createState() => _ViewRatedStatefulState();
}

class _ViewRatedStatefulState extends State<ViewRatedStateful> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override void initState(){
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialIndex);
  }

  @override void dispose(){
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: setAppBarTitle('Rated'),
        leading: defaultLeadingWidget(context),
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
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
                    Tab(text: 'Episodes'),
                  ],
                )                           
            ),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            ViewRatedMovies(
              key: UniqueKey()
            ),
            ViewRatedTvShows(
              key: UniqueKey(),
            ),
            ViewRatedEpisodes(
              key: UniqueKey()
            )
          ]
        )
      )
    );
  }
}