import 'package:flutter/material.dart';
import 'package:go_feed/model/activity.dart';

class ActivityFeedModel {
  ActivityFeedModel({@required this.listKey, Iterable<Activity> initialActivities, }) :
        assert(listKey != null),
        _activities = List<Activity>.from(initialActivities ?? <Activity>[]);

  final GlobalKey<AnimatedListState> listKey;
  final List<Activity> _activities;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, Activity item) {
    _activities.insert(index, item);
    _animatedList.insertItem(index);
  }

  int get length => _activities.length;

  Activity operator [](int index) => _activities[index];

  int indexOf(Activity activity) => _activities.indexOf(activity);
}
