import Foundation
import Stipop

class StickerPickerViewController: UIViewController {
    let pickerView = SPUIPickerView()
    var channel: FlutterMethodChannel!
    var userID: String!
    var languageCode: String?
    var countryCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        var user = (languageCode != nil && countryCode != nil) ? SPUser(userID: self.userID, country: self.countryCode!, language: self.languageCode!) : SPUser(userID: self.userID)
        pickerView.setUser(user)
        self.view.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pickerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        let backgroundView = UIView()
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presentingViewController?.view.alpha = 1
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.presentingViewController?.view.alpha = 1
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) { self.dismiss(animated: false, completion: nil) }
}

extension StickerPickerViewController: SPUIDelegate {
    func spViewDidSelectSticker(_ view: SPUIView, sticker: SPSticker) {
        self.channel.invokeMethod("onStickerSelected", arguments: ["stickerId" : sticker.id, "stickerImg" : sticker.stickerImg, "keyword" : sticker.keyword])
    }
}
