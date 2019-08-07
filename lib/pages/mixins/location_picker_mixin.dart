import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:image_picker/image_picker.dart';
import 'package:go_feed/location_picker/location_picker.dart';

mixin LocationPickerMixin<T extends StatefulWidget> on State<T> {

  @protected
  String address;

  @protected
  Map<dynamic, dynamic> locationData;

  @protected
  Future<Map<dynamic, dynamic>> showLocationPicker(Point<double> initLocation) async {
    final picker = LocationPicker(
      initialLat: initLocation?.x ?? 0,
      initialLong: initLocation?.y ?? 0,
    );
    Map<dynamic, dynamic> result = null;

    try {
      result = await picker.showLocationPicker;
    } on PlatformException catch (e) {
      print("Pex $e");
    } catch (e) {
      print('Something really unknown exception happened in location picker: $e');
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted || result == null)
      return null;

    setState(() {
      locationData = result;

      if (result.containsKey("line0")) address = result["line0"];
    });

    return result;
  }
}
