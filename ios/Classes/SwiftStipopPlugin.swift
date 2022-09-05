import Flutter
import UIKit
import Stipop

public class SwiftStipopPlugin: NSObject, FlutterPlugin {
    
    static var channel: FlutterMethodChannel?
    var currentStipopVC: UIViewController?
    static var stipopButton: SPUIButton?
    
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
        case "connect":
            SwiftStipopPlugin.stipopButton = SPUIButton(type: .system)
            guard let arguments = call.arguments as? Dictionary<String, Any>, let userID = arguments["userID"] as? String else{
                result(FlutterMethodNotImplemented)
                return
            }
            SwiftStipopPlugin.stipopButton?.setUser(SPUser(userID: userID), viewType: .picker)
            viewController.view.addSubview(SwiftStipopPlugin.stipopButton!)
            SwiftStipopPlugin.stipopButton?.delegate = self
            break;
            
        case "show":
            SwiftStipopPlugin.stipopButton?.sendActions(for: .touchUpInside)
            result(true)

            break;
        case "hide":
            SwiftStipopPlugin.stipopButton?.resignFirstResponder()
            result(true)
            break;
        default:
            result(FlutterMethodNotImplemented)
            break;
        }
    }
}
extension SwiftStipopPlugin: SPUIDelegate {
    public func onStickerSingleTapped(_ view: SPUIView, sticker: SPSticker) {
        SwiftStipopPlugin.channel?.invokeMethod("onStickerSingleTapped", arguments: ["stickerId" : sticker.stickerId, "stickerImg" : sticker.stickerImg, "keyword" : sticker.keyword ?? ""])
    }
    public func onStickerDoubleTapped(_ view: SPUIView, sticker: SPSticker) {
        SwiftStipopPlugin.channel?.invokeMethod("onStickerDoubleTapped", arguments: ["stickerId" : sticker.stickerId, "stickerImg" : sticker.stickerImg, "keyword" : sticker.keyword ?? ""])
    }
    public func spViewDidAppear(_ view: SPUIView){
        switch view {
        case is SPUIPickerInputView:
            SwiftStipopPlugin.channel?.invokeMethod("pickerViewIsAppear", arguments: ["isAppear": true])
        case is SPUIPickerCustomView:
            break
        case is SPUISearchViewController:
            break
        case is SPUIStoreViewController:
            break
        default:
            break
        }
    }
    public func spViewDidDisappear(_ view: SPUIView){
        switch view {
        case is SPUIPickerInputView:
            SwiftStipopPlugin.channel?.invokeMethod("pickerViewIsAppear", arguments: ["isAppear": false])
        case is SPUIPickerCustomView:
            break
        case is SPUISearchViewController:
            break
        case is SPUIStoreViewController:
            break
        default:
            break
        }
    }
}
