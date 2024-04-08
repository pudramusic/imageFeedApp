

//import UIKit
//
//class NavigationController {
//    var navigationBar: UINavigationBar
//    var backButton: (() -> Void)?
//    
//    init(navigationBar: UINavigationBar) {
//        self.navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 88))
//        self.navigationBar.backgroundColor = .ypWhite
//        self.navigationBar.backIndicatorImage = UIImage(named: "backward")
//        self.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backward")
//        
//        let backButton = UIBarButtonItem(title: "Back",
//                                         style: .plain,
//                                         target: self,
//                                         action: #selector(didTapBackButton))
//        backButton.tintColor = UIColor(named: "ypBlack")
//    
//        let navigationItem = UINavigationItem()
//        navigationItem.leftBarButtonItem = backButton
//        
//        self.navigationBar.setItems([navigationItem], animated: false)
//
//    }
//    
//    @objc
//    func didTapBackButton() {
//        backButton?()
//    }
//}
