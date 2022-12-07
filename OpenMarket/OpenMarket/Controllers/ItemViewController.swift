//
//  ItemViewController.swift
//  OpenMarket
//
//  Created by leewonseok on 2022/12/02.
//

import UIKit

class ItemViewController: UIViewController {
    // MARK: - Property
    var networkManager = NetworkManager()
    var itemImages: [UIImage] = []
    var isPost: Bool = false
    var isTexting: Bool = false
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.contentMode = .scaleToFill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    let itemNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()
    
    let priceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        return textField
        
    }()
    
    let currencySegmentedControl: UISegmentedControl = {
        let item = ["KRW", "USD"]
        let segmentedControl = UISegmentedControl(items: item)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "할인금액"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemGray6
        textView.font = .preferredFont(forTextStyle: .headline)
        return textView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackGroundColor()
        configureNavigation()
        configureScrollView()
        configureImageScrollView()
        configureTextFieldAndTextView()

        descriptionTextView.delegate = self
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        self.addKeyboardNotifications()
//    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.removeKeyboardNotifications()
//    }
    
}

// MARK: - View Constraint
extension ItemViewController {
    func configureScrollView() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(stackView)
        
        let constraint = self.stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),

            self.stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            self.stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }
    
    func configureImageScrollView() {
        stackView.addArrangedSubview(imageScrollView)
        imageScrollView.addSubview(imageStackView)
        
        NSLayoutConstraint.activate([
            self.imageScrollView.topAnchor.constraint(equalTo: self.stackView.topAnchor),
            self.imageScrollView.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.imageScrollView.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
            self.imageScrollView.heightAnchor.constraint(equalToConstant: 130),
            
            self.imageStackView.topAnchor.constraint(equalTo: self.imageScrollView.topAnchor),
            self.imageStackView.bottomAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor),
            self.imageStackView.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor, constant: 5),
            self.imageStackView.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor, constant: -5),
        ])
        
    }
    
    func configureTextFieldAndTextView() {
        stackView.addArrangedSubview(itemNameTextField)
        stackView.addArrangedSubview(priceStackView)
        stackView.addArrangedSubview(discountedPriceTextField)
        stackView.addArrangedSubview(stockTextField)
        stackView.addArrangedSubview(descriptionTextView)
        
        priceStackView.addArrangedSubview(priceTextField)
        priceStackView.addArrangedSubview(currencySegmentedControl)
        
        NSLayoutConstraint.activate([
            priceTextField.heightAnchor.constraint(equalTo:itemNameTextField.heightAnchor)
        ])
    }
}

// MARK: - Method
extension ItemViewController {
    @objc func configureNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action:
                                                                    #selector(doneButtonTapped))
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
        guard let parameter = createParameter() else { return }
        
        self.isPost = true
        LoadingController.showLoading()
        networkManager.addItem(parameter: parameter, images: itemImages) { result in
            LoadingController.hideLoading()
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "성공", message: "등록에 성공했습니다", actionTitle: "확인", dismiss: true)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "실패", message: "등록에 실패했습니다", actionTitle: "확인", dismiss: false)
                }
            }
            
            self.isPost = false
        }
    }
    
    func showAlert(title: String, message: String, actionTitle: String, dismiss: Bool){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if dismiss {
            alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
                self.dismiss(animated: true)
            }))
        } else {
            alert.addAction(UIAlertAction(title: actionTitle, style: .default))
        }
        
        present(alert, animated: true)
    }
    
    func configureBackGroundColor() {
        self.view.backgroundColor = .systemBackground
    }
    
    func createParameter() -> [String:Any]? {
        let priceText = priceTextField.text ?? "0"
        let discountedPriceText = discountedPriceTextField.text ?? "0"
        let stockText = stockTextField.text ?? "0"
        
        guard isPost == false else {
            showAlert(title: "경고", message: "처리 중 입니다.", actionTitle: "확인", dismiss: false)
            return nil
        }
        
        guard itemImages.count > 0 else {
            showAlert(title: "경고", message: "이미지를 등록해주세요.", actionTitle: "확인", dismiss: false)
            return nil
        }
        
        guard let itemNameText =  itemNameTextField.text,
              itemNameText.count > 2 else {
            showAlert(title: "경고", message: "제목을 3글자 이상 입력해주세요.", actionTitle: "확인", dismiss: false)
            return nil
        }
        
        
        guard let price = Double(priceText),
              let discountPrice = Double(discountedPriceText),
              let stock = Int(stockText) else {
            showAlert(title: "경고", message: "유효한 숫자를 입력해주세요", actionTitle: "확인", dismiss: false)
            return nil
        }
        
        guard let descriptionText = descriptionTextView.text,
              descriptionText.count <= 1000 else {
            showAlert(title: "경고", message: "내용은 1000자 이하만 등록가능합니다.", actionTitle: "확인", dismiss: false)
            return nil
        }
        
        let parameter: [String: Any] = ["name": itemNameText,
                                        "price": price,
                                        "currency": currencySegmentedControl.selectedSegmentIndex == 0
                                        ? Currency.krw.rawValue: Currency.usd.rawValue,
                                        "discounted_price": discountPrice,
                                        "stock": stock,
                                        "description": descriptionText,
                                        "secret": NetworkManager.secret]
        return parameter
    }
}

extension ItemViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        addKeyboardNotifications()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        removeKeyboardNotifications()
    }
}

extension ItemViewController {
    func addKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 올려준다.
        if !isTexting  ,let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y -= keyboardHeight
            isTexting = true
        }
    }
    
    // 키보드가 사라졌다는 알림을 받으면 실행할 메서드
    @objc func keyboardWillHide(_ noti: NSNotification){
        // 키보드의 높이만큼 화면을 내려준다.
        if isTexting, let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.view.frame.origin.y += keyboardHeight
            isTexting = false
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
