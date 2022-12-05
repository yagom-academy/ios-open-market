//
//  AddProductViewController.swift
//  OpenMarket
//
//  Created by Aaron, Jpush on 2022/11/25.
//

import UIKit

final class ProductViewController: UIViewController {
    var cellUpdateDelegate: CollectionViewUpdateDelegate?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    let addProductButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        button.contentMode = .center
        
        let image = UIImage(systemName: "plus")
        button.setImage(image, for: .normal)
        return button
    }()
    
    let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품명"
        
        return textField
    }()
    
    let productPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.tintColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "상품가격"
        textField.keyboardType = .decimalPad
        
        return textField
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    let bargainPriceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "할인금액"
        textField.keyboardType = .decimalPad
        
        return textField
    }()
    
    let stockTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .black
        textField.borderStyle = .roundedRect
        textField.placeholder = "재고수량"
        textField.keyboardType = .decimalPad
        
        return textField
    }()
    
    let currencySegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["KRW", "USD"])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        return control
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 17.0)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configure()
        setUpUI()
    }
    
    private func configure() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(tappedCancelButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(tappedDoneButton))
        
        productNameTextField.delegate = self
        productPriceTextField.delegate = self
        bargainPriceTextField.delegate = self
        stockTextField.delegate = self
        descriptionTextView.delegate = self
        
        self.view.addSubview(scrollView)
        self.view.addSubview(productNameTextField)
        self.view.addSubview(priceStackView)
        self.view.addSubview(bargainPriceTextField)
        self.view.addSubview(stockTextField)
        self.view.addSubview(descriptionTextView)
        
        scrollView.addSubview(imageStackView)
        scrollView.addSubview(addProductButton)
        
        addProductButton.addTarget(self, action: #selector(tappedPlusButton), for: .touchUpInside)
        
        self.priceStackView.addArrangedSubview(productPriceTextField)
        self.priceStackView.addArrangedSubview(currencySegmentedControl)
    }
    
    private func setUpUI() {
        let safeArea = self.view.safeAreaLayoutGuide
        let inset: CGFloat = 4
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: inset),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: inset),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -inset),
            scrollView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.2),
            
            imageStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            addProductButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.2),
            addProductButton.widthAnchor.constraint(equalTo: addProductButton.heightAnchor),
            addProductButton.leadingAnchor.constraint(equalTo: imageStackView.trailingAnchor, constant: inset),
            addProductButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: inset),

            productNameTextField.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: inset),
            productNameTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: inset),
            productNameTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -inset),
            
            priceStackView.topAnchor.constraint(equalTo: productNameTextField.bottomAnchor, constant: inset),
            priceStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: inset),
            priceStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -inset),
            
            productPriceTextField.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.7),
            
            bargainPriceTextField.topAnchor.constraint(equalTo: priceStackView.bottomAnchor, constant: inset),
            bargainPriceTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: inset),
            bargainPriceTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -inset),
            
            stockTextField.topAnchor.constraint(equalTo: bargainPriceTextField.bottomAnchor, constant: inset),
            stockTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: inset),
            stockTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -inset),
            
            descriptionTextView.topAnchor.constraint(equalTo: stockTextField.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: inset),
            descriptionTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -inset),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    @objc
    private func tappedDoneButton(_ sender: Any) {
        var validViewArray: [UIView] = []
        
        let name = productNameTextField.text ?? ""
        let description = descriptionTextView.text ?? ""
        let currency: Currency = currencySegmentedControl.selectedSegmentIndex == 0 ? .KRW : .USD
        let price = Double(productPriceTextField.text ?? "0") ?? 0
        let bargainPrice = Double(bargainPriceTextField.text ?? "0") ?? 0
        let stock = Int(stockTextField.text ?? "0") ?? 0

        var imageArray: [UIImage] = []
        let imageViewArray = imageStackView.subviews as? [UIImageView] ?? []
        imageViewArray.forEach { imageView in
            if let postImage = imageView.image {
                imageArray.append(postImage)
            }
        }
        
        if isValidImageCount() == false {
            validViewArray.append(addProductButton)
        }
        
        if isValidProductName(name) == false {
            validViewArray.append(productNameTextField)
        }
        
        if isValidProductPrice() == false {
            validViewArray.append(productPriceTextField)
        }
        
        if isValidbargainPrice(bargainPrice, price) == false {
            validViewArray.append(bargainPriceTextField)
        }
        
        guard validViewArray.isEmpty else {
            validViewArray.forEach { view in
                view.layer.borderColor = UIColor.systemRed.cgColor
                view.layer.borderWidth = 0.7
                view.layer.cornerRadius = 4
            }
            
            return
        }
        
        let product = Product(name: name,
                              description: description,
                              currency: currency,
                              price: price,
                              bargainPrice: bargainPrice,
                              discountedPrice: price - bargainPrice,
                              stock: stock,
                              secret: Constant.password
        )
        
        // post
        let manager = NetworkManager()
        manager.postProductLists(params: product, images: imageArray) {
            DispatchQueue.main.sync {
                self.cellUpdateDelegate?.updateCollectionView()
                self.dismiss(animated: true)
            }
        }
    }
    
    private func isValidImageCount() -> Bool {
        return imageStackView.subviews.isEmpty == false
    }
    
    private func isValidProductName(_ name: String) -> Bool {
        return 3 <= name.count && name.count <= 100
    }
    
    private func isValidbargainPrice(_ bargainPrice: Double, _ price: Double) -> Bool {
        return 0 <= bargainPrice && bargainPrice <= price
    }
    
    private func isValidProductPrice() -> Bool {
        guard productPriceTextField.text?.count != 0 else {
            return false
        }
        
        return true
    }
    
    @objc
    private func tappedPlusButton(_ sender: Any) {
        if self.imageStackView.subviews.count != 5 {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            
            self.present(picker, animated: true)
        }
    }
    
    @objc
    private func tappedCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension ProductViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 0.7
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == productNameTextField {
            return true
        }
        let isDelete = (string == "" && range.length == 1)
        
        return Double(string) != nil || isDelete
    }
}

extension ProductViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count <= 1000
    }
}
