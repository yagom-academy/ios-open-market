import UIKit.UIAlertController

protocol AlertMessage {
    func presentAlertMessage(controller: UIViewController, message: String)
}

extension AlertMessage {
    func presentAlertMessage(controller: UIViewController, message: String) {
        let alert = UIAlertController(title: "에러!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(action)
        controller.present(alert, animated: true)
    }
}
