import UIKit

class ProductRegisterViewController: UIViewController {
    private let productRegisterManager = ProductRegisterManager()
    private let imagePickerController = ImagePickerController()
    private lazy var productScrollView = productRegisterManager.productInformationScrollView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardNotification()
        productRegisterManager.delegate = self
        imagePickerController.pickerDelegate = self
        productRegisterManager.addDelegateToTextField(delegate: self)
        productRegisterManager.addDelegateToTextView(delegate: self)
        configUI()
        tapBehindViewToEndEdit()
    }
    
    private func configUI() {
        view.backgroundColor = .white
        configRegistrationView()
        configNavigationBar()
    }
    
    private func configNavigationBar() {
        self.navigationItem.title = "상품등록"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
    }
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapDoneButton() {
        if productRegisterManager.isRegisteredImageEmpty {
            presentAlert(title: "등록된 이미지가 없습니다.", message: "한 개 이상의 이미지를 필수로 등록해주세요.")
            return
        }
        
        if productRegisterManager.takeNameTextFieldLength() < 3 {
            presentAlert(title: "상품명을 더 길게 쓰세요", message: "상품명을 세 글자 이상 입력해주세요.")
            return
        }
        
        if productRegisterManager.isPriceTextFieldEmpty {
            presentAlert(title: "입력된 상품 가격이 없습니다.", message: "한 자리 이상의 상품 가격을 입력해주세요.")
            return
        }
                
        productRegisterManager.register()
        
        self.dismiss(animated: true) {
            self.productRegisterManager.updateProductData()
        }
    }
    
    private func configRegistrationView() {
        self.view.addSubview(productScrollView)
        productScrollView.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            productScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            productScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tapBehindViewToEndEdit() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}

extension ProductRegisterViewController: PickerPresenter {
    func presentImagePickerView() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

extension ProductRegisterViewController: PickerDelegate {
    func addImage(with image: UIImage) {
        if productRegisterManager.takeRegisteredImageCounts() < 5 {
            productRegisterManager.addImageToImageStackView(from: image)
        }
        
        if productRegisterManager.takeRegisteredImageCounts() == 5 {
            productRegisterManager.setImageButtonHidden(state: true)
        }
    }
}

extension ProductRegisterViewController: UITextFieldDelegate {
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

extension ProductRegisterViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length > 0 {
            return true
        }
        return range.location < 1000
    }
}
