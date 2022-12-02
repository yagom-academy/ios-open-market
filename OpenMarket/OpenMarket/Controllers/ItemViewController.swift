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
        stackView.distribution = .fill
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

    let desciptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemGray6
        return textView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configureNavigation()
        configureImageScrollView()
        configureTextFieldAndTextView()
    }
}

extension ItemViewController {
    // MARK: - View Constraint
    func configureImageScrollView() {
        self.view.addSubview(imageScrollView)
        self.imageScrollView.addSubview(imageStackView)

        NSLayoutConstraint.activate([
            self.imageScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.imageScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.imageScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            self.imageScrollView.heightAnchor.constraint(equalToConstant: 130),

            self.imageStackView.topAnchor.constraint(equalTo: self.imageScrollView.topAnchor),
            self.imageStackView.bottomAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor),
            self.imageStackView.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor, constant: 5),
            self.imageStackView.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor, constant: -5),
            self.imageStackView.heightAnchor.constraint(equalTo: self.imageScrollView.heightAnchor),
        ])
    }

    func configureTextFieldAndTextView() {
        self.view.addSubview(itemNameTextField)
        self.view.addSubview(priceStackView)
        self.view.addSubview(discountedPriceTextField)
        self.view.addSubview(stockTextField)
        self.view.addSubview(desciptionTextView)
        self.priceStackView.addSubview(priceTextField)
        self.priceStackView.addSubview(currencySegmentedControl)

        NSLayoutConstraint.activate([
            self.itemNameTextField.topAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor, constant: 15),
            self.itemNameTextField.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.itemNameTextField.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.itemNameTextField.heightAnchor.constraint(equalToConstant: 35),

            self.priceStackView.topAnchor.constraint(equalTo: self.itemNameTextField.bottomAnchor, constant: 10),
            self.priceStackView.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.priceStackView.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.priceStackView.heightAnchor.constraint(equalToConstant: 35),

            self.currencySegmentedControl.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.priceTextField.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.priceTextField.trailingAnchor.constraint(equalTo: self.currencySegmentedControl.leadingAnchor),

            self.discountedPriceTextField.topAnchor.constraint(equalTo: self.priceStackView.bottomAnchor, constant: 10),
            self.discountedPriceTextField.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.discountedPriceTextField.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.discountedPriceTextField.heightAnchor.constraint(equalToConstant: 35),

            self.stockTextField.topAnchor.constraint(equalTo: self.discountedPriceTextField.bottomAnchor, constant: 10),
            self.stockTextField.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.stockTextField.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.stockTextField.heightAnchor.constraint(equalToConstant: 35),

            self.desciptionTextView.topAnchor.constraint(equalTo: self.stockTextField.bottomAnchor, constant: 10),
            self.desciptionTextView.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.desciptionTextView.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.desciptionTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension ItemViewController {
    // MARK: - Method
    @objc func configureNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc func doneButtonTapped() { }

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
}

