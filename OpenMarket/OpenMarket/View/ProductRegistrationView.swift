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
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.setUpBoder(cornerRadius: 10,
                              borderWidth: 1.5,
                              borderColor: UIColor.systemGray3.cgColor)
        
        return scrollView
    }()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.spacing = 4
        
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
        let image = UIImage(systemName: "plus")
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let productInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let segmentedStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.setUpBoder(cornerRadius: 10,
                            borderWidth: 1.5,
                            borderColor: UIColor.systemGray3.cgColor)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private let productName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 5,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.setUpBoder(cornerRadius: 10,
                             borderWidth: 1.5,
                             borderColor: UIColor.systemGray3.cgColor)
        
        return textField
    }()
    
    private let productPrice: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 5,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.setUpBoder(cornerRadius: 10,
                             borderWidth: 1.5,
                             borderColor: UIColor.systemGray3.cgColor)
        textField.keyboardType = .decimalPad
        
        return textField
    }()
    
    private let productDiscountedPrice: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 5,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.setUpBoder(cornerRadius: 10,
                             borderWidth: 1.5,
                             borderColor: UIColor.systemGray3.cgColor)
        textField.keyboardType = .decimalPad
        
        return textField
    }()
    
    private let stock: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 5,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        textField.setUpBoder(cornerRadius: 10,
                             borderWidth: 1.5,
                             borderColor: UIColor.systemGray3.cgColor)
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    private let priceSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [Currency.krw.rawValue,
                                                          Currency.usd.rawValue])
        segmentedControl.selectedSegmentIndex = 0
        
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
        imagePrickerButton.addTarget(self,
                                     action: #selector(pickImages),
                                     for: .touchUpInside)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
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
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor, constant: 8),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: -8),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor, constant: 8),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([pirckerView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor, constant: -16),
                                     pirckerView.widthAnchor.constraint(equalTo: pirckerView.heightAnchor, multiplier: 1.0)])
        
        NSLayoutConstraint.activate([
            imagePrickerButton.centerXAnchor.constraint(equalTo: pirckerView.centerXAnchor),
            imagePrickerButton.centerYAnchor.constraint(equalTo: pirckerView.centerYAnchor)])
    }
    
    private func setUpSubViewsHeight() {
        NSLayoutConstraint.activate(
            [productDescriptionTextView.heightAnchor
                .constraint(equalTo: safeAreaLayoutGuide.heightAnchor,
                            multiplier: 0.5),
             productInformationStackView.heightAnchor
                .constraint(equalTo: productDescriptionTextView.heightAnchor,
                            multiplier: 0.5)])
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
        
        let currency = priceSegmentedControl.selectedSegmentIndex == 0 ?  Currency.krw: Currency.usd
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
                             let image = imageView.image
                else { return }
                
                images.append(image.resize(width: 300).pngData() ?? Data())
            }
        return images
    }
    
    // MARK: - @objc functions
    
    @objc private func pickImages() {
        guard
            imageStackView.subviews.count < 6 else { return }
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
        imageStackView.insertArrangedSubview(imageView, at: 0)
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
}

extension ProductRegistrationView: UITextViewDelegate {
    @objc private func keyboardWillShow(_ sender: Notification) {
        frame.origin.y = -(productDescriptionTextView.frame.height)
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        frame.origin.y = 0
    }
    
    @objc func endEditing(){
        resignFirstResponder()
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
        let imageSize = Double(imgData.count) / 1000
        
        if imageSize > 300 {
            renderImage = resize(width: width - 5)
        }
        return renderImage
    }
}

// MARK: - ImagePickerDelegate

protocol ImagePickerDelegate {
    func pickImages(pikerController: UIImagePickerController)
}
