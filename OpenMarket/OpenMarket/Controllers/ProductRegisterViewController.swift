import UIKit

class ProductRegisterViewController: UIViewController {
    private let productRegisterManager = ProductRegisterManager()
    private let imagePickerController = ImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productRegisterManager.delegate = self
        imagePickerController.pickerDelegate = self
        productRegisterManager.addDelegateToTextField(delegate: self)
        configUI()
        tapBehindViewToEndEdit()
    }
    
    private func configUI() {
        view.backgroundColor = .white
        configNavigationBar()
        configRegistrationView()
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
        self.dismiss(animated: true, completion: nil)
    }
    
    private func configRegistrationView() {
        let productRegistrationView = productRegisterManager.productInformationView
        self.view.addSubview(productRegistrationView)
        
        [productRegistrationView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            productRegistrationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            productRegistrationView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productRegistrationView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productRegistrationView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
}
