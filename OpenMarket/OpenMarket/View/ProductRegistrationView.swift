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
        scrollView.setUpBoder(cornerRadius: Design.borderCornerRadius,
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
    
    private let pirckerView: UIView = {
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
        textView.setUpBoder(cornerRadius: Design.borderCornerRadius,
                            borderWidth: Design.borderWidth,
                            borderColor: UIColor.systemGray3.cgColor)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
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
        textField.setUpBoder(cornerRadius: Design.borderCornerRadius,
                             borderWidth: Design.borderWidth,
                             borderColor: UIColor.systemGray3.cgColor)
        textField.autocorrectionType = .no
        
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
        textField.setUpBoder(cornerRadius: Design.borderCornerRadius,
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
        textField.setUpBoder(cornerRadius: Design.borderCornerRadius,
                             borderWidth: Design.borderWidth,
                             borderColor: UIColor.systemGray3.cgColor)
        textField.keyboardType = .decimalPad
        
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
        textField.setUpBoder(cornerRadius: Design.borderCornerRadius,
                             borderWidth: Design.borderWidth,
                             borderColor: UIColor.systemGray3.cgColor)
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    private let priceSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Currency.krw.rawValue,
                                                          Currency.usd.rawValue])
        segmentedControl.selectedSegmentIndex = .zero
        
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
    
    private func commonInit() {
        pickerController.delegate = self
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(totalStackView)
        setUpSubviews()
        setUpSubViewsHeight()
        setUpConstraints()
        productDescriptionTextView.delegate = self
        productName.delegate = self
        productPrice.delegate = self
        productDiscountedPrice.delegate = self
        stock.delegate = self
        setUpUiToolbar()
        imagePrickerButton.addTarget(self,
                                     action: #selector(pickImages),
                                     for: .touchUpInside)
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(endEditing(_:))))
    }
    
    private func setUpSubviews() {
        [imageScrollView, productInformationStackView, productDescriptionTextView]
            .forEach { totalStackView.addArrangedSubview($0) }
        [productName, segmentedStackView, productDiscountedPrice, stock]
            .forEach { productInformationStackView.addArrangedSubview($0) }
        [productPrice, priceSegmentedControl]
            .forEach { segmentedStackView.addArrangedSubview($0) }
        imageScrollView.addSubview(imageStackView)
        imageStackView.addArrangedSubview(pirckerView)
        pirckerView.addSubview(imagePrickerButton)
        
    }
    
    private func setUpConstraints() {
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
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor,
                                                constant: Design.imageScrollViewTopAnchorConstant),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor,
                                                   constant: Design.imageScrollViewBottomAnchorConstant),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor,
                                                    constant: Design.imageScrollViewLeadingAnchorConstant),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor,
                                                     constant: Design.imageScrollViewTrailingAnchorConstant)
        ])
        
        NSLayoutConstraint.activate([pirckerView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor, constant: Design.imageScrollViewHeightAnchorConstant),
                                     pirckerView.widthAnchor.constraint(equalTo: pirckerView.heightAnchor, multiplier: Design.imageScrollViewHeightAnchorMultiplier)])
        
        NSLayoutConstraint.activate([
            imagePrickerButton.centerXAnchor.constraint(equalTo: pirckerView.centerXAnchor),
            imagePrickerButton.centerYAnchor.constraint(equalTo: pirckerView.centerYAnchor)])
    }
    
    private func setUpSubViewsHeight() {
        NSLayoutConstraint.activate(
            [productDescriptionTextView.heightAnchor
                .constraint(equalTo: safeAreaLayoutGuide.heightAnchor,
                            multiplier: Design.safeAreaLayoutGuideHeightAnchorMultiplier),
             productInformationStackView.heightAnchor
                .constraint(equalTo: productDescriptionTextView.heightAnchor,
                            multiplier: Design.productDescriptionTextViewHeightAnchorMultiplier)])
    }
   
    private func setUpUiToolbar() {
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
    
    func postProduct() {
        guard let productName = productName.text,
              let priceText = productPrice.text,
              let priceValue = Double(priceText),
              let stockText = stock.text,
              let stock = Int(stockText)
        else { return }
        
        let images = convertImages()
        guard !images.isEmpty else { return }
        
        let currency = priceSegmentedControl.selectedSegmentIndex == .zero ?  Currency.krw: Currency.usd
        let product = RegistrationProduct(name: productName,
                                          descriptions: productDescriptionTextView.text,
                                          price: priceValue,
                                          currency: currency.rawValue,
                                          discountedPrice: Double(productDiscountedPrice.text ?? "0"),
                                          stock: stock,
                                          secret: "R49CfVhSdh")
        guard let productData = try? JSONEncoder().encode(product) else { return }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let postData = OpenMarketRequest(body: ["params" : [productData],
                                                "images": images],
                                         boundary: boundary,
                                         method: .post,
                                         baseURL: URLHost.openMarket.url + URLAdditionalPath.product.value,
                                         headers: ["identifier": "eef3d2e5-0335-11ed-9676-e35db3a6c61a",
                                                   "Content-Type": "multipart/form-data; boundary=\(boundary)"])
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: postData) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func convertImages() -> [Data] {
        var images = [Data]()
        let _ = imageStackView.subviews
            .filter { $0 != pirckerView }
            .forEach { guard let imageView = $0 as? UIImageView,
                             let image = imageView.image else { return }
                images.append(image.resize(width: Design.imageResizeWidth).pngData() ?? Data())
            }
        
        return images
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
        
        let imageView = setUpPickerImageView(image: editedImage)
        imageStackView.insertArrangedSubview(imageView, at: .zero)
        self.pickerController.dismiss(animated: true, completion: nil)
    }
    
    private func setUpPickerImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: pirckerView.frame.width),
            imageView.heightAnchor.constraint(equalToConstant: pirckerView.frame.height)
        ])
        
        return imageView
    }
    
    @objc func endEditing(){
        resignFirstResponder()
    }
}

extension ProductRegistrationView: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        frame.origin.y = -productDescriptionTextView.frame.height * 1.2
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        frame.origin.y = .zero
    }
}

extension UIImage {
    func resize(width: CGFloat) -> UIImage {
        let scale = width / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: width, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        var renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        let imgData = NSData(data: renderImage.pngData()!)
        let imageSize = Double(imgData.count) / Design.devideImageDataCountByThousand
        
        if imageSize > Design.imageDataCountConstraint {
            renderImage = resize(width: width - Design.renderImageResizeNumber)
        }
        return renderImage
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
    static let productNamePlaceholder = "상품명"
    static let productPricePlaceholder = "상품가격"
    static let productDiscountedPricePlaceholder = "할인금액"
    static let stockPlaceholder = "재고수량"
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
