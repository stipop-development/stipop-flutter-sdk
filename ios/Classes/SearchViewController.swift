import Foundation
import Stipop

class SearchViewController: UIViewController {
    let searchVC = SPUISearchViewController()
    var channel: FlutterMethodChannel!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        let backgroundView = UIView()
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 200).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        backgroundView.addGestureRecognizer(tapGesture)
        
        searchVC.spDelegate = self
        if let searchView = searchVC.view {
            self.view.addSubview(searchView)
            searchView.translatesAutoresizingMaskIntoConstraints = false
            searchView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
            searchView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            searchView.backgroundColor = UIColor.white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.presentingViewController?.view.alpha = 0.3
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.presentingViewController?.view.alpha = 1
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer) { self.dismiss(animated: false, completion: nil) }
}

extension SearchViewController: SPDelegate {
    var user: SPUser {
        return SPUser(userID: "some_user_id")
    }
    
    func onStickerSelect(_ sticker: SPSticker) {
        self.channel.invokeMethod("onStickerSelected", arguments: ["stickerId" : sticker.id, "stickerImg" : sticker.stickerImg, "keyword" : sticker.keyword])
    }
}
