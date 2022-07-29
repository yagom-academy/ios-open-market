//
//  ProductEnrollmentViewController.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductEnrollmentViewController: UIViewController {
    private let productImagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        return imagePicker
    }()
    
    private let rootScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let imageAndPickerButtonScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let imageAndPickerButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let plusImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"),
                        for: .normal)
        button.backgroundColor = .systemGray4
        
        return button
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let productNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.placeholder = "상품명"
        
        return textField
    }()
    
    private let productPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    private let originalPriceTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "상품가격"
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    private let currencySegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: [
            Currency.krw.rawValue,
            Currency.usd.rawValue])
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private let discountedPriceTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "할인금액"
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    private let productStockTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.systemGray2.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "재고수량"
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    private let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.text = "내용"
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.productImagePicker.delegate = self
        
        configureDefaultUI()
    }
    
    private func configureDefaultUI() {
        configureNavigationItems()
        configureRootScrollView()
        configureRootStackView()
        configureTextFieldStackView()
        configureImageAndPickerScrollView()
    }
    
    private func configureNavigationItems() {
        self.title = "상품 등록"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(didTappedCancelButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                 target: self,
                                                                 action: #selector(didTappedDoneButton))
    }
    
    private func configureRootScrollView() {
        view.addSubview(rootScrollView)
        rootScrollView.addSubview(rootStackView)
        
        NSLayoutConstraint.activate([
            rootScrollView.topAnchor.constraint(equalTo: view.topAnchor,
                                                constant: 10),
            rootScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: 10),
            rootScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                     constant: -10),
            rootScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                   constant: -10)
        ])
    }
    
    private func configureRootStackView() {
        rootStackView.addArrangedSubview(imageAndPickerButtonScrollView)
        rootStackView.addArrangedSubview(textFieldStackView)
        rootStackView.addArrangedSubview(productDescriptionTextView)
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: rootScrollView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: rootScrollView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: rootScrollView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: rootScrollView.bottomAnchor),
            rootStackView.widthAnchor.constraint(equalTo: rootScrollView.widthAnchor)
        ])
    }
    
    private func configureTextFieldStackView() {
        textFieldStackView.addArrangedSubview(productNameTextField)
        textFieldStackView.addArrangedSubview(productPriceStackView)
        productPriceStackView.addArrangedSubview(originalPriceTextField)
        productPriceStackView.addArrangedSubview(currencySegmentedControl)
        textFieldStackView.addArrangedSubview(discountedPriceTextField)
        textFieldStackView.addArrangedSubview(productStockTextField)
    }
    
    private func configureImageAndPickerScrollView() {
        imageAndPickerButtonScrollView.addSubview(imageAndPickerButtonStackView)
        imageAndPickerButtonStackView.addArrangedSubview(imageStackView)
        imageAndPickerButtonStackView.addArrangedSubview(plusImageButton)
        
        plusImageButton.addTarget(self,
                                  action: #selector(didTappedImagePickerButton(_:)),
                                  for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageAndPickerButtonScrollView.heightAnchor.constraint(equalToConstant: view.layer.bounds.width * 0.3),
            
            imageAndPickerButtonStackView.topAnchor.constraint(equalTo: imageAndPickerButtonScrollView.topAnchor),
            imageAndPickerButtonStackView.bottomAnchor.constraint(equalTo: imageAndPickerButtonScrollView.bottomAnchor),
            imageAndPickerButtonStackView.trailingAnchor.constraint(equalTo: imageAndPickerButtonScrollView.trailingAnchor),
            imageAndPickerButtonStackView.leadingAnchor.constraint(equalTo: imageAndPickerButtonScrollView.leadingAnchor),
            imageAndPickerButtonStackView.heightAnchor.constraint(equalTo: imageAndPickerButtonScrollView.heightAnchor),
            
            plusImageButton.widthAnchor.constraint(equalTo: plusImageButton.heightAnchor)
        ])
    }
    
    private func configureNewImageView(_ image: UIImage) {
        let imageView = configureProfileImageView(with: image)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        imageStackView.addArrangedSubview(imageView)
    }
    
    private func configureProfileImageView(with image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        
        return imageView
    }
    
    @objc private func didTappedCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTappedDoneButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTappedImagePickerButton(_ sender: UIButton) {
        self.present(self.productImagePicker,
                     animated: true)
    }
}

extension ProductEnrollmentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage = UIImage()
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        configureNewImageView(newImage)
        
        picker.dismiss(animated: true,
                       completion: nil)
    }
}
