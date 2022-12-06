//
//  RootProductView.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/12/03.
//

import UIKit

class RootProductView: UIView {
    var currency = NewProduct.CurrencyUnit.KRW
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
        registerCell()
        registerTextFieldDelegate()
        setupNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: imageLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    let imageLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        let collectionCellWidth = UIScreen.main.bounds.width / 3 - 10
        layout.itemSize  = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        return layout
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.borderStyle = .roundedRect
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = .done
        return textField
    }()
    
    let priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.borderStyle = .roundedRect
        textField.returnKeyType = .done
        textField.keyboardType = UIKeyboardType.numberPad
        return textField
    }()
    
    private let salePriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인가격"
        textField.borderStyle = .roundedRect
        textField.keyboardType = UIKeyboardType.numberPad
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.borderStyle = .roundedRect
        textField.keyboardType = UIKeyboardType.numberPad
        return textField
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.cornerRadius = 10
        textView.keyboardType = UIKeyboardType.default
        textView.returnKeyType = .done
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["KRW", "USD"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self,
                                   action: #selector(segmentedControlValueChanged),
                                   for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceTextField, currencySegmentedControl])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var productStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, priceStackView, salePriceTextField, stockTextField])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func registerCell() {
        collectionView.register(ImageCollectionViewCell.self,
                                forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
    }
    
    @objc func segmentedControlValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currency = .KRW
        } else {
            currency = .USD
        }
    }
}

// MARK: - KeyBoard Response Notification
extension RootProductView {
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        keyboardWillHide()
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, descriptionTextView.isFirstResponder {
                   let keyboardRectangle = keyboardFrame.cgRectValue
                   let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.5) {
                   self.window?.frame.origin.y -= keyboardHeight
               }
           }
    }
    
    @objc func keyboardWillHide() {
        if self.window?.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.5) {
                self.window?.frame.origin.y = 0
            }
        }
    }
}

// MARK: - UITextFieldDelegate & UITextViewDelegate
extension RootProductView: UITextFieldDelegate, UITextViewDelegate {
    func registerTextFieldDelegate() {
        nameTextField.delegate = self
        priceTextField.delegate = self
        salePriceTextField.delegate = self
        stockTextField.delegate = self
        descriptionTextView.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextField.text != "" {
            priceTextField.becomeFirstResponder()
            return true
        }
        return false
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        keyboardWillHide()
        descriptionTextView.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        nameTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        salePriceTextField.resignFirstResponder()
        stockTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if descriptionTextView.text.count >= 1000 && text != "" {
            return false
        }
        return true
    }
}

// MARK: - ProductViewProtocol
extension RootProductView {
    func setupData() -> Result<NewProduct, DataError> {
        guard let name = nameTextField.text,
            let description = descriptionTextView.text,
            let priceString = priceTextField.text,
            let price = Double(priceString) else { return Result.failure(.none) }
        
        var newProduct = NewProduct(name: name,
                                    description: description,
                                    currency: currency,
                                    price: price)
        
        if salePriceTextField.text != nil {
            guard let salePriceString = salePriceTextField.text else { return Result.failure(.none) }
            newProduct.discountedPrice = Double(salePriceString)
        }
        if stockTextField.text != nil {
            guard let stock = stockTextField.text else { return Result.failure(.none) }
            newProduct.stock = Int(stock)
        }
        
        return Result.success(newProduct)
    }
}

// MARK: - Constraints
extension RootProductView {
    func setupUI() {
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        self.addSubview(collectionView)
        self.addSubview(productStackView)
        self.addSubview(descriptionTextView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                                constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                    constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                     constant: -10),
            collectionView.heightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.heightAnchor,
                                                   multiplier: 0.2),
            
            productStackView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5),
            productStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                      constant: 10),
            productStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                       constant: -10),
            
            descriptionTextView.topAnchor.constraint(equalTo: productStackView.bottomAnchor,
                                                     constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: productStackView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: productStackView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                                                        constant: -10)
        ])
    }
}
