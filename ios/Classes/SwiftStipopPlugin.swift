import Flutter
import UIKit
import Stipop

public class SwiftStipopPlugin: NSObject, FlutterPlugin {
    static var channel: FlutterMethodChannel?
    var currentStipopVC: UIViewController?
    
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
            guard let arguments = call.arguments as? Dictionary<String, Any>, let userID = arguments["userID"] as? String else{
                result(FlutterMethodNotImplemented)
                return
            }
            stickerPickerVC.modalPresentationStyle = .overFullScreen
            stickerPickerVC.channel = SwiftStipopPlugin.channel!
            stickerPickerVC.userID = userID
            currentStipopVC = stickerPickerVC
            viewController.present(stickerPickerVC, animated: false, completion: nil)
            result(true)
            break;
        case "showSearch":
            let searchVC = SearchViewController()
            guard let arguments = call.arguments as? Dictionary<String, Any>, let userID = arguments["userID"] as? String else{
                result(FlutterMethodNotImplemented)
                return
            }
            searchVC.modalPresentationStyle = .overFullScreen
            searchVC.channel = SwiftStipopPlugin.channel!
            searchVC.userID = userID
            currentStipopVC = searchVC
            viewController.present(searchVC, animated: false, completion: nil)
            result(true)
            break;
        case "hideKeyboard":
            currentStipopVC?.dismiss(animated: false, completion: {
                self.currentStipopVC = nil
            })
            result(true)
            break;
        default:
            result(FlutterMethodNotImplemented)
            break;
        }
    }
}
