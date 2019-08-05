import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_feed/model/activity.dart';
import 'package:go_feed/pages/activity_detail_page.dart';
import 'package:go_feed/pages/items/activity_feed_item.dart';
import 'package:go_feed/model/activity_feed_model.dart';

class ActivityFeedPage extends StatefulWidget {

  final String title;
  ActivityFeedPage({Key key, this.title}) : super(key: key);

  @override
  _ActivityFeedPageState createState() => _ActivityFeedPageState();
}

class _ActivityFeedPageState extends State<ActivityFeedPage> {

  final _listKey = GlobalKey<AnimatedListState>();
  ActivityFeedModel _activityFeedModel;
  int _selectedItem;

  @override
  void initState() {
    super.initState();

    _activityFeedModel = ActivityFeedModel(
      listKey: _listKey,
      initialActivities: <Activity>[Activity(avatarUrl: "https://thispersondoesnotexist.com/image", fullName: "John Doe", when: DateTime.now().toUtc(), description: "Description", location: Point<double>(31.7532126, -106.3401488))],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          semanticsLabel: "Page title: ${widget.title}",
          style: TextStyle(
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        child: AnimatedList(
          key: _listKey,
          initialItemCount: _activityFeedModel.length,
          itemBuilder: (context, index, animation) {
            return ActivityFeedItem(
              key: UniqueKey(),
              activity: _activityFeedModel[index],
              animation: animation,
              onTap: () {
                setState(() {
                  _selectedItem = index;
                });
                final activity = _activityFeedModel[index];
                Navigator.of(context)
                    .push(MaterialPageRoute<Activity>(builder: (_) => ActivityDetailPage(activity: activity, readOnly: false,)))
                    .then((v) {
                  final activity = v;
                  if (activity.fullName?.isNotEmpty &&
                      activity.description?.isNotEmpty &&
                      activity.when != null &&
                      activity.location != null) {
                      _activityFeedModel[index] = activity;
                  }
                });
              },
              selected: _selectedItem == index,
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewActivity(context),
        tooltip: 'Add new activity',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNewActivity(BuildContext context) {
    _selectedItem = null;
    var activity = Activity();
    Navigator.of(context)
             .push(MaterialPageRoute<Activity>(builder: (_) => ActivityDetailPage(activity: activity, readOnly: false,)))
             .then((v) {
      activity = v;
      if (activity.fullName?.isNotEmpty &&
          activity.description?.isNotEmpty &&
          activity.when != null &&
          activity.location != null) {
        _activityFeedModel.insert(0, activity);
      }
    });

    //final activity = Activity(avatarUrl: "https://picsum.photos/id/${_activityFeedModel.length}/80", fullName: "John Doe ${_activityFeedModel.length}", when: DateTime.now().toUtc(), description: "Description", location: Point<double>(31.7532126, -106.3401488));
  }
}
