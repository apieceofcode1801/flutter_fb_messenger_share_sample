import UIKit
import Flutter
import FacebookShare
import FacebookCore
import Toast

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, SharingDelegate {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        
    }
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "com.apieceofcode.fbtest", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({ [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard call.method == "shareToMessenger", let url = call.arguments as? String else {
                result(FlutterMethodNotImplemented)
                return
            }
            self?.shareToMessenger(result: result, url: url)
        })
        
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    func shareToMessenger(result: FlutterResult, url: String) {
        guard let url = URL(string: url) else {
            window?.rootViewController?.view.makeToast("Invalid URL", position: ToastPosition.top)
            return
        }
        
        let content = ShareLinkContent()
        content.contentURL = url
        
        let dialog = MessageDialog(content: content, delegate: self)
        
        do {
            try dialog.validate()
        } catch {
            window?.rootViewController?.view.makeToast("Invalid URL", position: ToastPosition.top)
        }
        
        dialog.show()
        
    }
}
