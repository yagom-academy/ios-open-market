//
//  ProductRegistrationView.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/27.
//

import UIKit

final class ProductRegistrationView: UIView, Requestable {
    // MARK: - properties
    
    private let pickerController = UIImagePickerController()
    var delegate: ImagePickerDelegate?
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Design.stackViewSpacing
        
        return stackView
    }()
    
    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.setupBoder(cornerRadius: Design.borderCornerRadius,
                              borderWidth: Design.borderWidth,
                              borderColor: UIColor.systemGray3.cgColor)
        
        return scrollView
    }()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.spacing = Design.stackViewSpacing
        
        return stackView
    }()
    
    private let pickerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imagePrickerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: Design.plusButtonName)
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let productInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Design.stackViewSpacing
        
        return stackView
    }()
    
    private let segmentedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Design.stackViewSpacing
        
        return stackView
    }()
    
    private let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.setupBoder(cornerRadius: Design.borderCornerRadius,
                            borderWidth: Design.borderWidth,
                            borderColor: UIColor.systemGray3.cgColor)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = Design.productDescriptionPlaceholder
        textView.textColor = .systemGray3
        
        return textView
    }()
    
    private let productName: UITextField = {
        let textField = UITextField()
        textField.placeholder = Design.productNamePlaceholder
        textField.leftView = UIView(frame: CGRect(x: .zero,
                                                  y: .zero,
                                                  width: Design.viewFrameWidth,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.setupBoder(cornerRadius: Design.borderCornerRadius,
                             borderWidth: Design.borderWidth,
                             borderColor: UIColor.systemGray3.cgColor)
        
        return textField
    }()
    
    private let productPrice: UITextField = {
        let textField = UITextField()
        textField.placeholder = Design.productPricePlaceholder
        textField.leftView = UIView(frame: CGRect(x: .zero,
                                                  y: .zero,
                                                  width: Design.viewFrameWidth,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.setupBoder(cornerRadius: Design.borderCornerRadius,
                             borderWidth: Design.borderWidth,
                             borderColor: UIColor.systemGray3.cgColor)
        textField.keyboardType = .decimalPad
        
        return textField
    }()
    
    private let productDiscountedPrice: UITextField = {
        let textField = UITextField()
        textField.placeholder = Design.productDiscountedPricePlaceholder
        textField.leftView = UIView(frame: CGRect(x: .zero,
                                                  y: .zero,
                                                  width: Design.viewFrameWidth,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.setupBoder(cornerRadius: Design.borderCornerRadius,
                             borderWidth: Design.borderWidth,
                             borderColor: UIColor.systemGray3.cgColor)
        textField.keyboardType = .decimalPad
        textField.setContentHuggingPriority(.init(rawValue: 1000.0), for: .horizontal)
        textField.setContentCompressionResistancePriority(.init(rawValue: 1000.0), for: .horizontal)
        
        return textField
    }()
    
    private let stock: UITextField = {
        let textField = UITextField()
        textField.placeholder = Design.stockPlaceholder
        textField.leftView = UIView(frame: CGRect(x: .zero,
                                                  y: .zero,
                                                  width: Design.viewFrameWidth,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.setupBoder(cornerRadius: Design.borderCornerRadius,
                             borderWidth: Design.borderWidth,
                             borderColor: UIColor.systemGray3.cgColor)
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    private let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Currency.krw.rawValue,
                                                          Currency.usd.rawValue])
        segmentedControl.selectedSegmentIndex = .zero
        segmentedControl.setContentHuggingPriority(.init(rawValue: 1000.0), for: .horizontal)
        segmentedControl.setContentCompressionResistancePriority(.init(rawValue: 1000.0), for: .horizontal)
        
        return segmentedControl
    }()
    
    // MARK: - functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func register() {
        guard let productName = productName.text,
              productName.count > 2,
              productDescriptionTextView.text.count > 9,
              let price = makePriceText()
        else { return showInvalidInputAlert() }
        
        let images = convertImages(view: imageStackView)
        guard !images.isEmpty else { return showInvalidInputAlert() }
        
        let currency = currencySegmentedControl.selectedSegmentIndex == .zero ?  Currency.krw: Currency.usd
        let product = RegistrationProduct(name: productName,
                                          descriptions: productDescriptionTextView.text,
                                          price: price,
                                          currency: currency.rawValue,
                                          discountedPrice: Double(productDiscountedPrice.text ?? "0"),
                                          stock: Int(stock.text ?? "0"),
                                          secret: "R49CfVhSdh")
        postProduct(images: images, product: product)
    }
    
    private func commonInit() {
        setupView()
        setupDelegate()
        setupContent()
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(totalStackView)
        setupSubviews()
        setupSubViewsHeight()
        setupConstraints()
    }
    
    private func setupDelegate() {
        pickerController.delegate = self
        productDescriptionTextView.delegate = self
        productName.delegate = self
        productPrice.delegate = self
    }
    
    private func setupContent() {
        setupUiToolbar()
        imagePrickerButton.addTarget(self,
                                     action: #selector(pickImages),
                                     for: .touchUpInside)
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(endEditing(_:))))
    }
    
    private func setupSubviews() {
        [imageScrollView, productInformationStackView, productDescriptionTextView]
            .forEach { totalStackView.addArrangedSubview($0) }
        [productName, segmentedStackView, productDiscountedPrice, stock]
            .forEach { productInformationStackView.addArrangedSubview($0) }
        [productPrice, currencySegmentedControl]
            .forEach { segmentedStackView.addArrangedSubview($0) }
        imageScrollView.addSubview(imageStackView)
        imageStackView.addArrangedSubview(pickerView)
        pickerView.addSubview(imagePrickerButton)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [totalStackView.topAnchor
                .constraint(equalTo: safeAreaLayoutGuide.topAnchor),
             totalStackView.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
             totalStackView.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
             totalStackView.bottomAnchor
                .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)])
        
        NSLayoutConstraint.activate([
            imageStackView.topAnchor
                .constraint(equalTo: imageScrollView.topAnchor,
                            constant: Design.imageScrollViewTopAnchorConstant),
            imageStackView.bottomAnchor
                .constraint(equalTo: imageScrollView.bottomAnchor,
                            constant: Design.imageScrollViewBottomAnchorConstant),
            imageStackView.leadingAnchor
                .constraint(equalTo: imageScrollView.leadingAnchor,
                            constant: Design.imageScrollViewLeadingAnchorConstant),
            imageStackView.trailingAnchor
                .constraint(equalTo: imageScrollView.trailingAnchor,
                            constant: Design.imageScrollViewTrailingAnchorConstant)
        ])
        
        NSLayoutConstraint.activate([
            imagePrickerButton.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor),
            imagePrickerButton.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)])
    }
    
    private func setupSubViewsHeight() {
        NSLayoutConstraint.activate([
            pickerView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor,
                                               constant: Design.imageScrollViewHeightAnchorConstant),
            
            pickerView.widthAnchor.constraint(equalTo: pickerView.heightAnchor,
                                              multiplier: Design.imageScrollViewHeightAnchorMultiplier)])
        
        NSLayoutConstraint.activate(
            [productDescriptionTextView.heightAnchor
                .constraint(equalTo: safeAreaLayoutGuide.heightAnchor,
                            multiplier: Design.safeAreaLayoutGuideHeightAnchorMultiplier),
             productInformationStackView.heightAnchor
                .constraint(equalTo: productDescriptionTextView.heightAnchor,
                            multiplier: Design.productDescriptionTextViewHeightAnchorMultiplier)])
    }
    
    private func setupUiToolbar() {
        let keyboardToolbar = UIToolbar()
        let doneBarButton = UIBarButtonItem(title: Design.barButtonItemTitle,
                                            style: .plain,
                                            target: self,
                                            action: #selector(endEditing(_:)))
        
        keyboardToolbar.items = [doneBarButton]
        keyboardToolbar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        keyboardToolbar.sizeToFit()
        keyboardToolbar.tintColor = UIColor.systemGray
        
        productDescriptionTextView.inputAccessoryView = keyboardToolbar
    }
    
    private func makePriceText() -> Double? {
        guard let priceText = productPrice.text,
              let price = Double(priceText),
              let discountedPrice = Double(productDiscountedPrice.text ?? "0"),
              price > discountedPrice
        else { return nil }
        
        return price - discountedPrice
    }
    
    private func showInvalidInputAlert() {
        let postAlert = UIAlertController(title: "등록 형식이 잘못되었습니다",
                                          message: "필수사항을 입력해주세요", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "확인", style: .default)
        postAlert.addAction(alertAction)
        self.window?.rootViewController?.present(postAlert, animated: true)
    }
    
    // MARK: - @objc functions
    
    @objc private func pickImages() {
        guard
            imageStackView.subviews.count < Design.imageStackViewSubviewsCount else { return }
        delegate?.pickImages(pikerController: pickerController)
    }
}

// MARK: - extensions

extension ProductRegistrationView: UIImagePickerControllerDelegate,
                                   UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        else { return }
        
        let imageView = setupPickerImageView(image: editedImage)
        imageStackView.insertArrangedSubview(imageView, at: .zero)
        self.pickerController.dismiss(animated: true, completion: nil)
    }
    
    private func setupPickerImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: pickerView.frame.width),
            imageView.heightAnchor.constraint(equalToConstant: pickerView.frame.height)
        ])
        
        return imageView
    }
    
    @objc func endEditing(){
        resignFirstResponder()
    }
}

extension ProductRegistrationView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        frame.origin.y = -productDescriptionTextView.frame.height * 1.2
        if textView.text == Design.productDescriptionPlaceholder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        frame.origin.y = .zero
        if textView.text.count == 0 {
            textView.text = Design.productDescriptionPlaceholder
            textView.textColor = .lightGray
        }
    }
}

extension ProductRegistrationView: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let textFieldText = textField.text else { return }
        if textFieldText.count > 100 {
            textField.deleteBackward()
        }
        
        if productPrice.text!.components(separatedBy: ".").count > 2 {
            productPrice.deleteBackward()
        }
    }
}

// MARK: - ImagePickerDelegate

protocol ImagePickerDelegate {
    func pickImages(pikerController: UIImagePickerController)
}

// MARK: - Design

private enum Design {
    static let stackViewSpacing = 4.0
    static let borderCornerRadius = 10.0
    static let borderWidth = 1.5
    static let viewFrameWidth = 4.0
    static let plusButtonName = "plus"
    static let productNamePlaceholder = "상품명 (3자 이상, 100자 이하)"
    static let productPricePlaceholder = "상품가격 (필수입력)"
    static let productDiscountedPricePlaceholder = "할인금액 (미입력 시 정상가)"
    static let stockPlaceholder = "재고수량 (미입력 시 품절)"
    static let productDescriptionPlaceholder = "상품 설명 (10자 이상, 1000자 이하)"
    static let imageScrollViewTopAnchorConstant = 8.0
    static let imageScrollViewBottomAnchorConstant = -8.0
    static let imageScrollViewLeadingAnchorConstant = 8.0
    static let imageScrollViewTrailingAnchorConstant = -8.0
    static let imageScrollViewHeightAnchorConstant = -16.0
    static let imageScrollViewHeightAnchorMultiplier = 1.0
    static let safeAreaLayoutGuideHeightAnchorMultiplier = 0.4
    static let productDescriptionTextViewHeightAnchorMultiplier = 0.5
    static let barButtonItemTitle = "Done"
    static let imageResizeWidth = 300.0
    static let imageStackViewSubviewsCount = 6
    static let imageDataCountConstraint = 300.0
    static let renderImageResizeNumber = 5.0
    static let devideImageDataCountByThousand = 1000.0
}
