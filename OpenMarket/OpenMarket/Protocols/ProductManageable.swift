import UIKit

protocol ProductManageable {
    var productRegisterManager: ProductRegisterManager { get set }
    func configRegistrationView(viewController: UIViewController)
    func presentAlert(viewController: UIViewController, title: String, message: String)
    func tapBehindViewToEndEdit(viewController: UIViewController)
}

extension ProductManageable {
    func configRegistrationView(viewController: UIViewController) {
        viewController.view.addSubview(productRegisterManager.productInformationScrollView)
        productRegisterManager.productInformationScrollView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            productRegisterManager.productInformationScrollView.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor),
            productRegisterManager.productInformationScrollView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            productRegisterManager.productInformationScrollView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            productRegisterManager.productInformationScrollView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        ])
    }
    
    func presentAlert(viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirmAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func tapBehindViewToEndEdit(viewController: UIViewController) {
        let tap = UITapGestureRecognizer(target: viewController.view, action: #selector(UIView.endEditing))
        viewController.view.addGestureRecognizer(tap)
    }
}
