import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as TimeAgo;

class Activity {
  Activity({id, this.avatarUrl, this.fullName, this.when, this.description, this.location, String address = "",}) {
    if (id == null || id.isEmpty) {
      _id = Uuid().v4().toString();
    } else {
      _id = id;
    }
    _address = address ?? "";
  }

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
