import UIKit

extension UIAlertController {
    static func simpleAlert(message: String, presentationDelegate: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(cancelAction)
        presentationDelegate.present(alert, animated: true, completion: nil)
    }
}
