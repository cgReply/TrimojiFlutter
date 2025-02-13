import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller = window?.rootViewController as! FlutterViewController
        let shareChannel = FlutterMethodChannel(name: "com.example.emoji_trivia_app/share", binaryMessenger: controller.binaryMessenger)

        shareChannel.setMethodCallHandler { (call, result) in
            if call.method == "shareText" {
                if let args = call.arguments as? [String: Any], let text = args["text"] as? String {
                    self.shareText(text: text)
                    result(nil)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Text not provided", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func shareText(text: String) {
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}
