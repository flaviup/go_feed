import 'package:flutter/material.dart';
import 'package:go_feed/model/activity.dart';

class ActivityFeedModel {

  ActivityFeedModel({@required this.listKey, Iterable<Activity> initialActivities,}) :
        assert(listKey != null),
        _activities = List<Activity>.from(initialActivities ?? <Activity>[]) {
    _initAnimatedList();
  }

  ActivityFeedModel.fromJson({@required this.listKey, @required Map<String, dynamic> json})
      : assert(listKey != null),
        assert(json != null),
        _activities = List<Activity>.from(json["activities"].map((act) => Activity.fromJson(act)).toList()) {
    _initAnimatedList();
  }

  Map<String, dynamic> toJson() => {
    "activities" : _activities.map((a) => a.toJson()).toList(growable: false),
  };

  void _initAnimatedList() {
    _activities.reversed.forEach((a) => _animatedList?.insertItem(0));
  }

  final GlobalKey<AnimatedListState> listKey;
  final List<Activity> _activities;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, Activity item) {
    _activities.insert(index, item);
    _animatedList.insertItem(index);
  }

  int get length => _activities.length;

  Activity operator [](int index) => _activities[index];
  operator []=(int index, Activity activity) {
    _animatedList.setState(() {
      _activities[index] = activity;
    });
  }

  int indexOf(Activity activity) => _activities.indexOf(activity);
}
