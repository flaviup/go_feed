import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    SwiftLocationPickerPlugin.register(with: self.registrar(forPlugin: "location_picker_plugin"))
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
