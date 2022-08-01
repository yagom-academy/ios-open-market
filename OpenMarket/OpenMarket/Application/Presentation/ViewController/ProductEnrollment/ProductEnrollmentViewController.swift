//
//  ProductEnrollmentViewController.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductEnrollmentViewController: UIViewController {
    // MARK: - Properties

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
        textField.font = UIFont.preferredFont(forTextStyle: .caption1)
        
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
        textField.font = UIFont.preferredFont(forTextStyle: .caption1)
        
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
        textField.font = UIFont.preferredFont(forTextStyle: .caption1)
        
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
        textField.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return textField
    }()
    
    private let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.text = "제품 상세 설명"
        textView.textColor = .lightGray
        textView.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return textView
    }()
    
    private let productEnrollmentAPIManager = ProductEnrollmentAPIManager()
    private var productImages: [ProductImage] = []
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureDefaultUI()
    }

    // MARK: - UI
    
    private func configureDefaultUI() {
        connectDelegate()
        configureNavigationItems()
        configureRootScrollView()
        configureRootStackView()
        configureTextFieldStackView()
        configureImageAndPickerScrollView()
        registerNotificationForKeyboard()
    }
    
    private func connectDelegate() {
        self.productImagePicker.delegate = self
        
        self.productNameTextField.delegate = self
        self.originalPriceTextField.delegate = self
        self.discountedPriceTextField.delegate = self
        self.productStockTextField.delegate = self
        
        self.productDescriptionTextView.delegate = self
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
        
        let heightAnchor = rootScrollView.heightAnchor.constraint(equalTo: rootScrollView.heightAnchor)
        heightAnchor.priority = .defaultHigh
        heightAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            rootScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            rootScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
            rootStackView.widthAnchor.constraint(equalTo: rootScrollView.widthAnchor),
            
            productDescriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    
    func registerNotificationForKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
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
    
    private func register() {
        let currency = currencySegmentedControl.selectedSegmentIndex == 0 ? Currency.krw : Currency.usd
        
        guard let productNameText = productNameTextField.text,
              let productDescriptionText = productDescriptionTextView.text,
              let originalPrice = originalPriceTextField.text?.convertToInt(),
              let discountedPrice = discountedPriceTextField.text?.convertToInt(),
              let productStock = productStockTextField.text?.convertToInt(),
              originalPrice > 0,
              productImages.count > 0 else {
            
            self.presentConfirmAlert(message: AlertMessage.emptyValue.rawValue)
            return
        }
        
        let parameter = PostParameter(name: productNameText,
                                      descriptions: productDescriptionText,
                                      price: originalPrice,
                                      currency: currency,
                                      discounted_price: discountedPrice,
                                      stock: productStock,
                                      secret: User.secret.rawValue)
        
        let productInfo = EnrollProductEntity(parameter: parameter, images: productImages)
        
        productEnrollmentAPIManager?.enrollData(postEntity: productInfo) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.presentConfirmAlert(message: AlertMessage.enrollmentSuccess.rawValue)
                case .failure(_):
                    self?.presentConfirmAlert(message: AlertMessage.enrollmentFailure.rawValue)
                }
            }
        }
    }
    
    // MARK: - Action
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        let contentInset = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: keyboardFrame.size.height,
            right: 0.0)
        
        rootScrollView.contentInset = contentInset
        rootScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide() {
        let contentInset = UIEdgeInsets.zero
        rootScrollView.contentInset = contentInset
        rootScrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func didTappedCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTappedDoneButton() {
        register()
    }
    
    @objc private func didTappedImagePickerButton(_ sender: UIButton) {
        if productImages.count < 5 {
            self.present(self.productImagePicker,
                         animated: true)
        } else {
            self.presentConfirmAlert(message: AlertMessage.exceedImages.rawValue)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProductEnrollmentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage = UIImage()
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        guard let productImage = ProductImage(withImage: newImage) else { return }
        productImages.append(productImage)
        
        configureNewImageView(newImage)
        
        picker.dismiss(animated: true,
                       completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension ProductEnrollmentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        
        return limitTextFieldLength(textField)
    }
    
    private func limitTextFieldLength(_ textField: UITextField) -> Bool {
        switch textField {
        case let textField where textField == productNameTextField:
            if textField.text!.count >= 40 {
                self.presentConfirmAlert(message: AlertMessage.exceedValue.rawValue)
                return false
            }
        case let textField where textField == originalPriceTextField:
            if textField.text!.count >= 10 {
                self.presentConfirmAlert(message: AlertMessage.exceedValue.rawValue)
                return false
            }
        case let textField where textField == discountedPriceTextField:
            if textField.text!.count >= 10 {
                self.presentConfirmAlert(message: AlertMessage.exceedValue.rawValue)
                return false
            }
        case let textField where textField == productStockTextField:
            if textField.text!.count >= 10 {
                self.presentConfirmAlert(message: AlertMessage.exceedValue.rawValue)
                return false
            }
        default:
            return true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch textField {
        case productNameTextField:
            guard let productNameText = productNameTextField.text?.replacingOccurrences(of: " ", with: "") else {
                return
            }
            
            if productNameText.count == 0 {
                self.presentConfirmAlert(message: AlertMessage.emptyValue.rawValue)
            } else if productNameText.count < 3 {
                self.presentConfirmAlert(message: AlertMessage.additionalCharacters.rawValue)
            }
        case originalPriceTextField:
            guard let originalPricetext = originalPriceTextField.text else {
                return
            }
            
            if originalPricetext.count == 0 {
                self.presentConfirmAlert(message: AlertMessage.emptyValue.rawValue)
            }
        default:
            break
        }
    }
}

// MARK: - UITextViewDelegate

extension ProductEnrollmentViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count >= 1000 {
            self.presentConfirmAlert(message: AlertMessage.exceedValue.rawValue)
            return false
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "제품 상세 설명" {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "제품 상세 설명"
            textView.textColor = .lightGray
        }
    }
}
