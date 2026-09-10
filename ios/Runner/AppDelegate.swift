import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var _fallbackWindow: UIWindow?

  override var window: UIWindow? {
    get {
      if let w = super.window, w.rootViewController != nil {
        return w
      }
      for scene in UIApplication.shared.connectedScenes {
        if let windowScene = scene as? UIWindowScene {
          for w in windowScene.windows {
            if w.rootViewController != nil {
              return w
            }
          }
        }
      }
      if let w = super.window {
        if w.rootViewController == nil {
          w.rootViewController = UIViewController()
        }
        return w
      }
      if _fallbackWindow == nil {
        let w = UIWindow(frame: UIScreen.main.bounds)
        w.rootViewController = UIViewController()
        _fallbackWindow = w
      }
      return _fallbackWindow
    }
    set {
      super.window = newValue
    }
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
