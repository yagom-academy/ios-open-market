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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    func setUpViewsIfNeeded() {
        contentStackView.addArrangedSubview(imageCollectionView)
        priceAndCurrencyStackView.addArrangedSubview(priceTextField)
        priceAndCurrencyStackView.addArrangedSubview(currencySegmentedControl)
        contentStackView.addArrangedSubview(nameTextField)
        contentStackView.addArrangedSubview(priceAndCurrencyStackView)
        contentStackView.addArrangedSubview(discountedPriceTextField)
        contentStackView.addArrangedSubview(stockTextField)
        contentStackView.addArrangedSubview(descriptionTextView)
        view.addSubview(contentStackView)

        let spacing: CGFloat = 10
        let safeArea: UILayoutGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            imageCollectionView.heightAnchor.constraint(equalToConstant: 160),
            contentStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: spacing),
            contentStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -spacing),
            contentStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: spacing),
            contentStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -spacing)
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
