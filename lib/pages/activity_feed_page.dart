import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_feed/model/activity.dart';
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
      initialActivities: <Activity>[Activity(avatarUrl: "https://thispersondoesnotexist.com/image", fullName: "John Doe", when: DateTime.now(), description: "Description", location: Point<double>(31.7532126, -106.3401488))],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: AnimatedList(
          key: _listKey,
          initialItemCount: _activityFeedModel.length,
          itemBuilder: (context, index, animation) {
            return ActivityFeedItem(
              activity: _activityFeedModel[index],
              animation: animation,
              onTap: () {
                setState(() {
                  _selectedItem = index;
                });
              },
              selected: _selectedItem == index,
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewActivity,
        tooltip: 'Add new activity',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _addNewActivity() {
    _selectedItem = null;
    final activity = Activity(avatarUrl: "https://thispersondoesnotexist.com/image", fullName: "John Doe ${_activityFeedModel.length}", when: DateTime.now(), description: "Description", location: Point<double>(31.7532126, -106.3401488));
    _activityFeedModel.insert(0, activity);
  }
}
