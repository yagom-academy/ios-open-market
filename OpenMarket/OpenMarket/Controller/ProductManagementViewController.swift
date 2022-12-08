//
//  ProductManagementViewController.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/29.
//

import UIKit

protocol ProductManagementNavigationBarButtonProtocol {
    var cancelBarButtonItem: UIBarButtonItem? { get }
    var doneBarButtonItem: UIBarButtonItem? { get }
}

class ProductManagementViewController: UIViewController {
    let imageCollectionView: ImageCollectionView = .init(frame: .zero,
                                                         collectionViewLayout: .imagePicker)
    let nameTextField: NameTextField = .init(minimumLength: 3, maximumLength: 100)
    let priceTextField: NumberTextField = .init(placeholder: "상품가격", hasDefaultValue: false)
    let discountedPriceTextField: NumberTextField = .init(placeholder: "할인금액", hasDefaultValue: true)
    let stockTextField: NumberTextField = .init(placeholder: "재고수량", hasDefaultValue: true)
    let descriptionTextView: DescriptionTextView = .init(minimumLength: 10, maximumLength: 1000)
    let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl: UISegmentedControl = .init(items: ["KRW", "USD"])

        segmentedControl.selectedSegmentIndex = 0

        return segmentedControl
    }()
    private let priceAndCurrencyStackView: UIStackView = {
        let stackView: UIStackView = .init()

        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    private let contentStackView: UIStackView = {
        let stackView: UIStackView = .init()

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    private let scrollView: UIScrollView = {
        let scrollView: UIScrollView = .init()
        
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    var cancelBarButtonItem: UIBarButtonItem?
    var doneBarButtonItem: UIBarButtonItem?
    var hasEnoughContents: Bool {
        nameTextField.hasEnoughText &&
        priceTextField.hasEnoughText &&
        discountedPriceTextField.hasEnoughText &&
        stockTextField.hasEnoughText &&
        descriptionTextView.hasEnoughText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViews()
        setUpDelegate()
        setUpBarButtonItem()
        setUpNotification()
        setUpTapGestureRecognizer()
    }

    private func setUpViews() {
        imageCollectionView.bounces = false
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.bounces = false
        
        contentStackView.addArrangedSubview(imageCollectionView)
        priceAndCurrencyStackView.addArrangedSubview(priceTextField)
        priceAndCurrencyStackView.addArrangedSubview(currencySegmentedControl)
        contentStackView.addArrangedSubview(nameTextField)
        contentStackView.addArrangedSubview(priceAndCurrencyStackView)
        contentStackView.addArrangedSubview(discountedPriceTextField)
        contentStackView.addArrangedSubview(stockTextField)
        contentStackView.addArrangedSubview(descriptionTextView)
        scrollView.addSubview(contentStackView)
        view.addSubview(scrollView)

        let spacing: CGFloat = 10
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide
        
        let contentStackViewSizeConstraints: (width: NSLayoutConstraint, height: NSLayoutConstraint) = (contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor), contentStackView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor))
        
//        contentStackViewSizeConstraints.height.priority = .init(rawValue: 1)

        NSLayoutConstraint.activate([
            imageCollectionView.heightAnchor.constraint(equalToConstant: 160),
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: spacing),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -spacing),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: spacing),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -spacing),
            contentStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStackViewSizeConstraints.height, contentStackViewSizeConstraints.width,
            priceAndCurrencyStackView.heightAnchor.constraint(equalTo: nameTextField.heightAnchor),
            priceAndCurrencyStackView.heightAnchor.constraint(equalTo: discountedPriceTextField.heightAnchor),
            priceAndCurrencyStackView.heightAnchor.constraint(equalTo: stockTextField.heightAnchor)
        ])
        currencySegmentedControl.setContentHuggingPriority(.required, for: .horizontal)
    }

    private func setUpDelegate() {
        nameTextField.delegate = self
        priceTextField.delegate = self
        discountedPriceTextField.delegate = self
        stockTextField.delegate = self
        descriptionTextView.delegate = self
    }

    func makeProductByInputedData() -> ProductToRequest? {
        return ProductToRequest(name: nameTextField.text,
                                description: descriptionTextView.text,
                                currency: .init(currencySegmentedControl.selectedSegmentIndex),
                                price: priceTextField.text,
                                discountedPrice: discountedPriceTextField.text,
                                stock: stockTextField.text,
                                secret: Secret(secretKey: "xwxdkq8efjf3947z"))
    }
    
    private func setUpBarButtonItem() {
        doneBarButtonItem = UIBarButtonItem(title: "done",
                                            style: .plain,
                                            target: self,
                                            action: nil)
        cancelBarButtonItem = UIBarButtonItem(title: "Cancel",
                                              style: .plain,
                                              target: self,
                                              action: nil)
        doneBarButtonItem?.isEnabled = false
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkEnoughContents),
                                               name: UITextField.textDidChangeNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkEnoughContents),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }
    
    private func setUpTapGestureRecognizer() {
        let tapGestureRecognizer: UITapGestureRecognizer = .init(target: self,
                                                                 action: #selector(endEditing))

        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.isEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false

        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func checkEnoughContents(_ sender: NSNotification?) {
        if let nameTextField: NameTextField = sender?.object as? NameTextField {
            nameTextField.setUpStyleIfNeeded()
            nameTextField.calculateCountIfNeeded()
        } else if let numberTextField: NumberTextField = sender?.object as? NumberTextField {
            numberTextField.setUpStyleIfNeeded()
        } else if let descriptionTextView: DescriptionTextView = sender?.object as? DescriptionTextView {
            descriptionTextView.setUpStyleIfNeeded()
            descriptionTextView.calculateCountIfNeeded()
        }
        
        doneBarButtonItem?.isEnabled = hasEnoughContents
    }
    
    @objc
    private func keyboardWillShow(_ sender: Notification) {
        guard let userinfo: [AnyHashable : Any] = sender.userInfo,
              let keyboardFrame: CGRect = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardHeight: CGFloat = keyboardFrame.size.height
        
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        
        if let focusedTextView = UIResponder.currentFirstResponder as? UITextView {
            scrollView.scrollRectToVisible(focusedTextView.frame, animated: false)
        }
    }
    
    @objc
    private func keyboardWillHide(_ sender: Notification) {
        let contentInset: UIEdgeInsets = .zero
        
        scrollView.contentInset = contentInset
        scrollView.verticalScrollIndicatorInsets = contentInset
    }
    
    @objc
    func endEditing() {
        view.endEditing(true)
    }
}

extension ProductManagementViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let _: NumberTextField = textField as? NumberTextField,
           string.isNumber() == false {
            return false
        } else if let nameTextField: NameTextField = textField as? NameTextField,
                  let text: String = nameTextField.text {
            let lengthOfTextToAdd: Int = string.count - range.length
            let addedTextLength: Int = text.count + lengthOfTextToAdd

            return nameTextField.isLessThanOrEqualMaximumLength(addedTextLength)
        }
        return true
    }
}

extension ProductManagementViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let descriptionTextView: DescriptionTextView = textView as? DescriptionTextView {
            let lengthOfTextToAdd: Int = text.count - range.length
            let addedTextLength: Int = textView.text.count + lengthOfTextToAdd

            return descriptionTextView.isLessThanOrEqualMaximumLength(addedTextLength)
        }
        return true
    }
}
