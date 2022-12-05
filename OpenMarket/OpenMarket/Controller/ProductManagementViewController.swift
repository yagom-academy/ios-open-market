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
    let imageCollectionView: ImageCollectionView = ImageCollectionView(frame: .zero, collectionViewLayout: .imagePicker)
    let nameTextField: NameTextField = NameTextField(minimumLength: 3, maximumLength: 100)
    let priceTextField: NumberTextField = NumberTextField(placeholder: "상품가격")
    let discountedPriceTextField: NumberTextField = NumberTextField(placeholder: "할인금액")
    let stockTextField: NumberTextField = NumberTextField(placeholder: "재고수량")
    let descriptionTextView: DescriptionTextView = DescriptionTextView(minimumLength: 10, maximumLength: 1000)
    let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["KRW", "USD"])

        segmentedControl.selectedSegmentIndex = 0

        return segmentedControl
    }()
    private let priceAndCurrencyStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()

        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    private let contentStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    private let scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    func setUpViewsIfNeeded() {
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
        
        let contentStackViewSizeConstraints: (width: NSLayoutConstraint, height: NSLayoutConstraint) = (contentStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor), contentStackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor))
        
        contentStackViewSizeConstraints.height.priority = .init(rawValue: 1)

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
            contentStackViewSizeConstraints.height, contentStackViewSizeConstraints.width
        ])
    }

    func setUpDelegateIfNeeded() {
        nameTextField.delegate = self
        priceTextField.delegate = self
        discountedPriceTextField.delegate = self
        stockTextField.delegate = self
        descriptionTextView.delegate = self
    }

    func makeProductByInputedData() -> Product? {
        return Product(name: nameTextField.text,
                       description: descriptionTextView.text,
                       currency: .init(currencySegmentedControl.selectedSegmentIndex),
                       price: priceTextField.text,
                       discountedPrice: discountedPriceTextField.text,
                       stock: stockTextField.text)
    }
    
    @objc
    private func keyboardWillShow(_ sender: Notification) {
        guard let userinfo = sender.userInfo,
              let keyboardFrame = userinfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
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
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.verticalScrollIndicatorInsets = contentInset
    }
    
    override
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
