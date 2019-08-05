import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as TimeAgo;

class Activity {

  Activity({id, this.avatarUrl, this.fullName, this.when, this.description, this.location, String address = "",}) :
        _address = address ?? "" {
    if (id == null || id.isEmpty) {
      _id = Uuid().v4().toString();
    } else {
      _id = id;
    }
  }

  Activity.fromJson(@required Map<String, dynamic> json)
      : assert(json != null),
        _id = json["id"] ?? Uuid().v4().toString(),
        avatarUrl = json["avatarUrl"],
        fullName = json["fullName"],
        when = DateTime.parse(json["when"]),
        description = json["description"],
        location = Point(json["location"][0], json["location"][1]),
        _address = json["address"];

  Map<String, dynamic> toJson() => {
        "id" : id,
        "avatarUrl" : avatarUrl,
        "fullName" : fullName,
        "when" : when.toUtc().toIso8601String(),
        "description" : description,
        "location" : [location.x, location.y],
        "address" : address,
  };

  String _id;
  String get id => _id;
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

  ImageProvider<dynamic> get avatarImage => getImage(avatarUrl);
  String get timeAgo => TimeAgo.format(when.toLocal());

  static ImageProvider<dynamic> getImage(String path) {
    return (path != null && path.startsWith("http")) ? NetworkImage(path) : FileImage(File(path ?? ""));
  }
}
