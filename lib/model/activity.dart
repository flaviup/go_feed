import 'dart:math';
import 'package:timeago/timeago.dart' as TimeAgo;

class Activity {
  Activity({this.avatarUrl, this.fullName, this.when, this.description, this.location, });

  final String avatarUrl;
  final String fullName;
  final DateTime when;
  final String description;
  final Point<double> location;
  String _address = "";

  String get address => _address;
  set address(String value) {
    _address = value;
  }

  String get timeAgo => TimeAgo.format(when.toLocal());
}
