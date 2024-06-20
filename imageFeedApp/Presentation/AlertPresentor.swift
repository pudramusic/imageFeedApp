
import UIKit

class AlertPresentor: UIViewController {
    
    static let shared = AlertPresentor()
    
    func showNetworkError(errorMessage: String) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: errorMessage,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "ОК",
            style: .default) { _ in
                alert.dismiss(animated: true)
            }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
