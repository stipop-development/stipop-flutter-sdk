import Flutter
import UIKit
import Stipop

public class SwiftStipopPlugin: NSObject, FlutterPlugin {
    static var channel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "stipop_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftStipopPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)
        
        Stipop.initialize()
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let viewController: UIViewController =
                    (UIApplication.shared.delegate?.window??.rootViewController)!

        switch call.method {
        case "showKeyboard":
            let stickerPickerVC = StickerPickerViewController()
            stickerPickerVC.modalPresentationStyle = .overFullScreen
            stickerPickerVC.channel = SwiftStipopPlugin.channel!
            viewController.present(stickerPickerVC, animated: false, completion: nil)
            result(true)
            break;
        case "showSearch":
            let searchVC = SearchViewController()
            searchVC.modalPresentationStyle = .overFullScreen
            searchVC.channel = SwiftStipopPlugin.channel!
            viewController.present(searchVC, animated: false, completion: nil)
            result(true)
            break;
        case "hideKeyboard":
            result(true)
            break;
        default:
            result(FlutterMethodNotImplemented)
            break;
        }
    }
}
