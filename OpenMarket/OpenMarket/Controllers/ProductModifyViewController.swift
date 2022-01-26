import UIKit

class ProductModifyViewController: UIViewController, ProductManageable {
    var productRegisterManager = ProductRegisterManager()
    private lazy var productScrollView = productRegisterManager.productInformationScrollView
    private var productDetail: ProductDetail
    
    init(productDetail: ProductDetail) {
        self.productDetail = productDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("스토리보드 안써서 fatalError를 줬습니다.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardNotification()
        productRegisterManager.addDelegateToTextField(delegate: self)
        productRegisterManager.addDelegateToTextView(delegate: self)
        configUI()
        tapBehindViewToEndEdit(viewController: self)
        productRegisterManager.fetchRegisteredProductDetail(from: productDetail)
    }
    
    private func configUI() {
        view.backgroundColor = .white
        configRegistrationView(viewController: self)
        configNavigationBar()
    }
    
    private func configNavigationBar() {
        self.navigationItem.title = "상품수정"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(didTapCancelButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(didTapDoneButton))
    }
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapDoneButton() {
        productRegisterManager.update(productId: productDetail.id)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProductModifyViewController: UITextFieldDelegate {
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

extension ProductModifyViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length > 0 {
            return true
        }
        return range.location < 1000
    }
}
