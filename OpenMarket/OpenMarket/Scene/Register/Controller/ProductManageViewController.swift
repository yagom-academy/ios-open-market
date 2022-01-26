import UIKit

class ProductManageViewController: UIViewController {
    let productRegisterManager = ProductRegisterManager()
    lazy var productScrollView = productRegisterManager.productInformationScrollView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardNotification()
        productRegisterManager.addDelegateToTextView(delegate: self)
        productRegisterManager.addDelegateToTextField(delegate: self)
        tapBehindViewToEndEdit()
        configUI()
    }
    
    func configUI() {
        view.backgroundColor = .white
        configRegistrationView()        
    }
    
    func setDescriptionTextViewPlaceholder() {
        if productScrollView.productInformationView.descriptionTextView.text.isEmpty {
            productScrollView.productInformationView.descriptionTextView.text = "상품 설명(10 ~ 1000자)"
            productScrollView.productInformationView.descriptionTextView.textColor = .lightGray
        }
    }
    
    func checkValidInput() -> Bool {
        if productRegisterManager.isRegisteredImageEmpty {
            presentAlert(title: AlertMessage.noProductImage.title, message: AlertMessage.noProductImage.message)
            return false
        }
        
        if productRegisterManager.takeNameTextFieldLength() < 3 {
            presentAlert(title: AlertMessage.notEnoughProductTitleLength.title, message: AlertMessage.notEnoughProductTitleLength.message)
            return false
        }
        
        if productRegisterManager.isPriceTextFieldEmpty {
            presentAlert(title: AlertMessage.noProductPrice.title, message: AlertMessage.noProductPrice.message)
            return false
        }
        
        if !productRegisterManager.checkValidDiscount() {
            presentAlert(title: AlertMessage.invalidDiscountedPrice.title, message: AlertMessage.invalidDiscountedPrice.message)
            return false
        }
        
        if productRegisterManager.taksdescriptionTextLength() < 10 {
            presentAlert(title: AlertMessage.notEnoughDescriptionLength.title, message: AlertMessage.notEnoughDescriptionLength.message)
            return false
        }
        
        if productRegisterManager.taksdescriptionTextLength() > 1000 {
            presentAlert(title: AlertMessage.exceedDescriptionLength.title, message: AlertMessage.exceedDescriptionLength.message)
            return false
        }
        
        return true
    }
    
    func configRegistrationView() {
        self.view.addSubview(productRegisterManager.productInformationScrollView)
        productRegisterManager.productInformationScrollView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            productRegisterManager.productInformationScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            productRegisterManager.productInformationScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productRegisterManager.productInformationScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productRegisterManager.productInformationScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: AlertActionMessage.done.title, style: .default, handler: nil)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tapBehindViewToEndEdit() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        self.view.addGestureRecognizer(tap)
    }
    
}

extension ProductManageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .default {
            return true
        }
                
        if range.location == 0 {
            if string == "0" {
                return false
            }
            
            if string == "." {
                textField.text = "0"
            }
        }
            
        if string == "." && textField.text?.contains(".") == true {
            return false
        }
        
        return true
    }
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let info = sender.userInfo else {
            return
        }
        let userInfo = info as NSDictionary
        guard let keyboardFrame = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue else {
            return
        }
    
        let keyboardRect = keyboardFrame.cgRectValue
        productScrollView.contentInset.bottom = keyboardRect.height
        
        if let firstResponder = self.view.firstResponder,
           let textView = firstResponder as? UITextView {
            productScrollView.scrollRectToVisible(textView.frame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        productScrollView.contentInset = .zero
    }
}

extension ProductManageViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location == 1000 {
            presentAlert(title: AlertMessage.exceedDescriptionLength.title, message: AlertMessage.exceedDescriptionLength.message)
            return false
        }
        if range.length > 0 {
            return true
        }
        return range.location < 1000
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setDescriptionTextViewPlaceholder()
        }
    }
}
