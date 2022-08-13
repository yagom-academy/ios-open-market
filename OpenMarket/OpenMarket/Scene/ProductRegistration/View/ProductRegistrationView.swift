//
//  ProductRegistrationView.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/27.
//

import UIKit

class ProductRegistrationView: UIView {
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
        stackView.spacing = Design.stackViewSpacing
        stackView.alignment = .trailing
        
        return stackView
    }()
    
    private let pickerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    private let imagePrickerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(systemName: Design.plusButtonName)
        button.setImage(image,
                        for: .normal)
        
        return button
    }()
    
    private let productInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Design.stackViewSpacing
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private let productNameTextField: UITextField = {
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
    
    private let segmentedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Design.stackViewSpacing
        
        return stackView
    }()
    
    private let productPriceTextField: UITextField = {
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
    
    private let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Currency.krw.rawValue,
                                                          Currency.usd.rawValue])
        segmentedControl.selectedSegmentIndex = .zero
        segmentedControl.setContentHuggingPriority(.init(rawValue: 1000.0),
                                                   for: .horizontal)
        segmentedControl.setContentCompressionResistancePriority(.init(rawValue: 1000.0),
                                                                 for: .horizontal)
        
        return segmentedControl
    }()
    
    private let productDiscountedPriceTextField: UITextField = {
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
        textField.setContentHuggingPriority(.init(rawValue: 1000.0),
                                            for: .horizontal)
        textField.setContentCompressionResistancePriority(.init(rawValue: 1000.0),
                                                          for: .horizontal)
        
        return textField
    }()
    
    private let productStockTextField: UITextField = {
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
    
    private let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.setupBoder(cornerRadius: Design.borderCornerRadius,
                            borderWidth: Design.borderWidth,
                            borderColor: UIColor.systemGray3.cgColor)
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = Design.productDescriptionPlaceholder
        textView.textColor = .systemGray3
        
        return textView
    }()
    
    // MARK: - initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupView()
        setupDelegate()
        setupContent()
    }
    
    // MARK: - functions
    
    func registerProduct() {
        guard let product = setupProduct() else { return showInvalidInputAlert() }
        
        let images = setupImages()
        guard !images.isEmpty else { return showInvalidInputAlert() }
        
        ProductRegistrationManager.register(product: product, images: images)
    }
    
    private func setupProduct() -> RegistrationProduct? {
        guard let productName = productNameTextField.text,
              productName.count > 2,
              productDescriptionTextView.text.count > 9,
              let price = makePriceText()
        else { return nil }
        
        let currency = currencySegmentedControl.selectedSegmentIndex == .zero ?  Currency.krw: Currency.usd
        let product = RegistrationProduct(name: productName,
                                          descriptions: productDescriptionTextView.text,
                                          price: price,
                                          currency: currency.rawValue,
                                          discountedPrice: Double(productDiscountedPriceTextField.text ?? Design.zeroString),
                                          stock: Int(productStockTextField.text ?? Design.zeroString),
                                          secret: Design.secretKey)
        
        return product
    }
    
    private func setupImages() -> [Image] {
        var images = [Image]()
        let imagesData = convertImages(view: imageStackView)
        imagesData.forEach
        {
            images.append(Image(name: $0.description,
                                data: $0,
                                type: Design.png))
        }
        
        return images
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        setupSubviews()
        setupSubViewsHeight()
        setupConstraints()
    }
    
    private func setupSubviews() {
        [imageScrollView, productInformationStackView, productDescriptionTextView].forEach
        {
            totalStackView.addArrangedSubview($0)
        }
        
        [productNameTextField, segmentedStackView, productDiscountedPriceTextField, productStockTextField].forEach
        {
            productInformationStackView.addArrangedSubview($0)
        }
        
        [productPriceTextField, currencySegmentedControl].forEach
        {
            segmentedStackView.addArrangedSubview($0)
        }
        
        addSubview(totalStackView)
        imageScrollView.addSubview(imageStackView)
        imageStackView.addArrangedSubview(pickerView)
        pickerView.addSubview(imagePrickerButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                totalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                totalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                totalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                totalStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
            ])
        
        NSLayoutConstraint.activate(
            [
                imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor,
                                                    constant: Design.imageScrollViewTopAnchorConstant),
                imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor,
                                                       constant: Design.imageScrollViewBottomAnchorConstant),
                imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor,
                                                        constant: Design.imageScrollViewLeadingAnchorConstant),
                imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor,
                                                         constant: Design.imageScrollViewTrailingAnchorConstant)
            ])
        
        NSLayoutConstraint.activate(
            [
                imagePrickerButton.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor),
                imagePrickerButton.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
            ])
    }
    
    private func setupSubViewsHeight() {
        NSLayoutConstraint.activate(
            [
                pickerView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor,
                                                   constant: Design.imageScrollViewHeightAnchorConstant),
                pickerView.widthAnchor.constraint(equalTo: pickerView.heightAnchor,
                                                  multiplier: Design.imageScrollViewHeightAnchorMultiplier)
            ])
        
        NSLayoutConstraint.activate(
            [
                productDescriptionTextView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor,
                                                                   multiplier: Design.safeAreaLayoutGuideHeightAnchorMultiplier),
                productInformationStackView.heightAnchor.constraint(equalTo: productDescriptionTextView.heightAnchor,
                                                                    multiplier: Design.productDescriptionTextViewHeightAnchorMultiplier)
            ])
    }
    
    private func setupContent() {
        setupUiToolbar()
        imagePrickerButton.addTarget(self,
                                     action: #selector(pickImages),
                                     for: .touchUpInside)
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(endEditing(_:))))
    }
    
    private func setupDelegate() {
        pickerController.delegate = self
        productDescriptionTextView.delegate = self
        productNameTextField.delegate = self
        productPriceTextField.delegate = self
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
        guard let priceText = productPriceTextField.text,
              let price = Double(priceText),
              let discountedPrice = Double(productDiscountedPriceTextField.text ?? "0"),
              price >= discountedPrice
        else { return nil }
        
        return price - discountedPrice
    }
    
    private func showInvalidInputAlert() {
        let postAlert = UIAlertController(title: Design.postAlertControllerTitle,
                                          message: Design.postAlertControllerMessage,
                                          preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: Design.alertActionTitle,
                                        style: .default)
        postAlert.addAction(alertAction)
        
        window?.rootViewController?.present(postAlert,
                                            animated: true)
    }
    
    private func convertImages(view: UIView) -> [Data] {
        var images = [Data]()
        
        view.subviews.forEach
        {
            guard let imageView = $0 as? UIImageView,
                  let image = imageView.image else { return }
            
            images.append(image.resize(width: 300).pngData() ?? Data())
        }
        
        return images
    }
    
    // MARK: - @objc functions
    
    @objc private func pickImages() {
        guard imageStackView.subviews.count < Design.imageStackViewSubviewsCount else { return }
        
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
        imageStackView.insertArrangedSubview(imageView,
                                             at: .zero)
        pickerController.dismiss(animated: true,
                                 completion: nil)
    }
    
    private func setupPickerImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        
        NSLayoutConstraint.activate(
            [
                imageView.widthAnchor.constraint(equalToConstant: pickerView.frame.width),
                imageView.heightAnchor.constraint(equalToConstant: pickerView.frame.height)
            ])
        
        return imageView
    }
    
    @objc private func endEditing(){
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
        
        if productPriceTextField.text!.components(separatedBy: ".").count > 2 {
            productPriceTextField.deleteBackward()
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
    static let secretKey = "R49CfVhSdh"
    static let postAlertControllerTitle = "등록 형식이 잘못되었습니다"
    static let postAlertControllerMessage = "필수사항을 입력해주세요"
    static let alertActionTitle = "확인"
    static let zeroString = "0"
    static let png = "png"
}
