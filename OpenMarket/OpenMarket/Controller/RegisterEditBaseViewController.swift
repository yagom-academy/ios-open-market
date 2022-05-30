//
//  RegisterEditViewController.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/24.
//

import UIKit

class RegisterEditBaseViewController: UIViewController {
    
    private enum Constant {
        static let rightNavigationButtonText = "Done"
        static let leftNavigationButtonText = "Cancel"
    }
    
    private lazy var rightNavigationButton = UIBarButtonItem(
        title: Constant.rightNavigationButtonText,
        style: .plain,
        target: self,
        action: #selector(registerEditViewRightBarButtonTapped)
    )
    
    private lazy var leftNavigationButton: UIBarButtonItem = UIBarButtonItem(
        title: Constant.leftNavigationButtonText,
        style: .plain,
        target: self,
        action: #selector(registerEditViewLeftBarButtonTapped)
    )
    
    private lazy var baseScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addImageScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var addImageHorizontalStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .leading
        view.distribution = .equalSpacing
        return view
    }()
    
    lazy var baseVerticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            nameTextField,
            priceCurrencyStackView,
            discountPriceTextField,
            stockTextField,
            textView
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        return view
    }()
    
    private lazy var priceCurrencyStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [priceTextField, currencySegmentedControl])
        view.axis = .horizontal
        view.spacing = 10
        return view
    }()
    
    lazy var nameTextField = generateTextField(placeholder: "상품명", keyboardType: .default)
    lazy var priceTextField = generateTextField(placeholder: "상품가격", keyboardType: .decimalPad)
    lazy var discountPriceTextField = generateTextField(placeholder: "할인가격", keyboardType: .decimalPad)
    lazy var stockTextField = generateTextField(placeholder: "재고수량", keyboardType: .numberPad)
    
    lazy var currencySegmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: [Currency.KRW.rawValue, Currency.USD.rawValue])
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.font = .preferredFont(forTextStyle: .body)
        view.text = "제품 상세 설명 textView 입니다."
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        return view
    }()
}

// MARK: - Lifecycle Method

extension RegisterEditBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationTitle()
        setConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeRegisterForKeyboardNotification()
    }
}

// MARK: - Method

extension RegisterEditBaseViewController {
    
    private func setNavigationTitle() {
        navigationItem.rightBarButtonItem = rightNavigationButton
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = leftNavigationButton
    }
    
    func setConstraint() {
        view.addSubview(baseScrollView)
        NSLayoutConstraint.activate([
            baseScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            baseScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            baseScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            baseScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        baseScrollView.addSubview(addImageScrollView)
        NSLayoutConstraint.activate([
            addImageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addImageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addImageScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addImageScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ])
        
        addImageScrollView.addSubview(addImageHorizontalStackView)
        NSLayoutConstraint.activate([
            addImageHorizontalStackView.leadingAnchor.constraint(equalTo: addImageScrollView.leadingAnchor),
            addImageHorizontalStackView.trailingAnchor.constraint(equalTo: addImageScrollView.trailingAnchor),
            addImageHorizontalStackView.topAnchor.constraint(equalTo: addImageScrollView.topAnchor),
            addImageHorizontalStackView.heightAnchor.constraint(equalTo: addImageScrollView.heightAnchor)
        ])
        
        baseScrollView.addSubview(baseVerticalStackView)
        NSLayoutConstraint.activate([
            baseVerticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            baseVerticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            baseVerticalStackView.topAnchor.constraint(equalTo: addImageScrollView.bottomAnchor, constant: 15),
            baseVerticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            currencySegmentedControl.widthAnchor.constraint(equalTo: baseScrollView.widthAnchor, multiplier: 0.25)
        ])
    }
    
    private func generateTextField(placeholder: String, keyboardType: UIKeyboardType) -> UITextField {
        let field = UITextField()
        field.placeholder = "\(placeholder)"
        field.layer.borderColor = UIColor.systemGray4.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 5
        field.addLeftPadding()
        field.keyboardType = keyboardType
        NSLayoutConstraint.activate([
            field.heightAnchor.constraint(equalToConstant: 35)
        ])
        return field
    }
}

// MARK: - Keyboard Method

extension RegisterEditBaseViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != textView {
            self.textView.resignFirstResponder()
        }
    }
    
    private func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyBoardShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeRegisterForKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardHide(_ notification: Notification) {
        self.view.transform = .identity
    }
    
    @objc private func keyBoardShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyboardAnimate(keyboardRectangle: keyboardRectangle, textView: textView)
    }
    
    private func keyboardAnimate(keyboardRectangle: CGRect ,textView: UITextView) {
        if keyboardRectangle.height > (self.view.frame.height - textView.frame.maxY){
            self.view.transform = CGAffineTransform(translationX: 0, y: -(keyboardRectangle.height))
        }
    }
}

// MARK: - Action Method

extension RegisterEditBaseViewController {
    
    @objc func registerEditViewRightBarButtonTapped() {
        
    }
    
    @objc private func registerEditViewLeftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
