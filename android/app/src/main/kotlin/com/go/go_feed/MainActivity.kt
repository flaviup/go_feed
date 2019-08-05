package com.go.go_feed

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.LocationPickerPlugin

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    LocationPickerPlugin.registerWith(this.registrarFor("io.flutter.plugins.location_picker_plugin"))
  }
}
