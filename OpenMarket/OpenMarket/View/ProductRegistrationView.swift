//
//  ProductRegistrationView.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/27.
//

import UIKit

class ProductRegistrationView: UIView {
    // MARK: - properties
    
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
        backgroundColor = .systemBackground
        addSubview(totalStackView)
        setUpSubviews()
        setUpSubViewsHeight()
        setUpConstraints()
        imagePrickerButton.addTarget(self, action: #selector(pickImages), for: .touchUpInside)
    }
    
    private func setUpSubviews() {
        [imageScrollView, productInformationStackView, productDescriptionTextView]
            .forEach { totalStackView.addArrangedSubview($0) }
        [productName, segmentedStackView, productDiscountedPrice, stock]
            .forEach { productInformationStackView.addArrangedSubview($0) }
        [productPrice, priceSegmentedControl]
            .forEach { segmentedStackView.addArrangedSubview($0) }
        
        imageScrollView.addSubview(imageStackView)
        
        pirckerView.addSubview(imagePrickerButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor, constant: 8),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: -8),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor, constant: 8),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            imagePrickerButton.centerXAnchor.constraint(equalTo: pirckerView.centerXAnchor),
            imagePrickerButton.centerYAnchor.constraint(equalTo: pirckerView.centerYAnchor)])
        
        NSLayoutConstraint.activate([pirckerView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor, constant: -16),
                                     pirckerView.widthAnchor.constraint(equalTo: pirckerView.heightAnchor, multiplier: 1.0)])
        NSLayoutConstraint.activate(
            [totalStackView.topAnchor
                .constraint(equalTo: safeAreaLayoutGuide.topAnchor),
             totalStackView.leadingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
             totalStackView.trailingAnchor
                .constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
             totalStackView.bottomAnchor
                .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)])
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
    
    // MARK: - @objc functions
    
    @objc private func pickImages() {
        guard
            imageStackView.subviews.count < 6 else { return }
        delegate?.pickImages()
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
        picker.dismiss(animated: true, completion: nil)
    }
    
    func setUpPickerImageView(image: UIImage) -> UIImageView {
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

// MARK: - delegate

protocol ImagePickerDelegate {
    func pickImages()
}
