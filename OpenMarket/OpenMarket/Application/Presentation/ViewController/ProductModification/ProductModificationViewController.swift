//
//  ProductModificationViewController.swift
//  OpenMarket
//
//  Created by 데릭, 수꿍.
//

import UIKit

final class ProductModificationViewController: UIViewController {
    // MARK: - Properties
    
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
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10,
                                               left: 10,
                                               bottom: 10,
                                               right: 10)
        
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
        textField.placeholder = ProductStatus.productName.rawValue
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
        textField.placeholder = ProductStatus.productPrice.rawValue
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
        textField.placeholder = ProductStatus.discountedPrice.rawValue
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
        textField.placeholder = ProductStatus.numberOfStocks.rawValue
        textField.keyboardType = .numberPad
        textField.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return textField
    }()
    
    private let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return textView
    }()
    
    private var productModificationAPIManager: ProductModificationAPIManager?
    private var productImages: [ProductImage] = []
    var productInfo: ProductDetailsEntity?
    
    weak var delegate: ProductModificationDelegate?
    
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
        
        DispatchQueue.main.async { [weak self] in
            self?.updateUI(by: self?.productInfo)
        }
    }
    
    private func connectDelegate() {
        productNameTextField.delegate = self
        originalPriceTextField.delegate = self
        discountedPriceTextField.delegate = self
        productStockTextField.delegate = self
        productDescriptionTextView.delegate = self
    }
    
    private func configureNavigationItems() {
        title = CurrentPage.productModification.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                target: self,
                                                                action: #selector(didTappedCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
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
        
        NSLayoutConstraint.activate([
            imageAndPickerButtonScrollView.heightAnchor.constraint(equalToConstant: view.layer.bounds.width * 0.3),
            
            imageAndPickerButtonStackView.topAnchor.constraint(equalTo: imageAndPickerButtonScrollView.topAnchor),
            imageAndPickerButtonStackView.bottomAnchor.constraint(equalTo: imageAndPickerButtonScrollView.bottomAnchor),
            imageAndPickerButtonStackView.trailingAnchor.constraint(equalTo: imageAndPickerButtonScrollView.trailingAnchor),
            imageAndPickerButtonStackView.leadingAnchor.constraint(equalTo: imageAndPickerButtonScrollView.leadingAnchor),
            imageAndPickerButtonStackView.heightAnchor.constraint(equalTo: imageAndPickerButtonScrollView.heightAnchor)
        ])
    }
    
    private func registerNotificationForKeyboard() {
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
    
    private func configureNewImageView(_ images: [UIImage]) {
        images.forEach { image in
            let imageView = configureProfileImageView(with: image)
            
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
            
            imageStackView.addArrangedSubview(imageView)
        }
    }
    
    private func configureProfileImageView(with image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        
        return imageView
    }
    
    private func modify() {
        let currency = currencySegmentedControl.selectedSegmentIndex == 0 ? Currency.krw : Currency.usd
        
        let modifyEntity = ModifiedProductEntity(name: productNameTextField.text,
                                                 descriptions: productDescriptionTextView.text,
                                                 thumbnail_id: nil,
                                                 price: originalPriceTextField.text?.convertToOptionalInt(),
                                                 currency: currency,
                                                 discounted_price: discountedPriceTextField.text?.convertToOptionalInt(),
                                                 stock: productStockTextField.text?.convertToOptionalInt(),
                                                 secret: User.secret.rawValue)
        
        productModificationAPIManager?.modifyData(modifiedProductEntity: modifyEntity) { [weak self] result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(ProductDetails.self,
                                                                  from: data) else {
                    return
                }
                
                self?.presentConfirmAlert(message: AlertMessage.modificationSuccess.rawValue)
                self?.delegate?.productModificationViewController(
                    ProductModificationViewController.self,
                    didRecieve: decodedData.name)
                
            case .failure(let error):
                self?.presentConfirmAlert(message: error.errorDescription)
            }
        }
    }
    
    private func checkNumberOfText(in textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .lightGray
            textView.text = ProductStatus.productDescription.rawValue
        } else {
            textView.textColor = .black
        }
    }
    
    func updateUI(by data: ProductDetailsEntity?) {
        guard let data = data else {
            return
        }
        
        productModificationAPIManager = ProductModificationAPIManager(productID: data.id)
        productNameTextField.text = data.name
        originalPriceTextField.text = data.price.description
        discountedPriceTextField.text = data.bargainPrice.description
        productStockTextField.text = data.stock.description
        productDescriptionTextView.text = data.description
        currencySegmentedControl.selectedSegmentIndex = data.currency == .krw ? 0 : 1
        configureNewImageView(data.images)
        checkNumberOfText(in: productDescriptionTextView)
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
        modify()
    }
}

// MARK: - UITextFieldDelegate

extension ProductModificationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        
        return limitTextFieldLength(textField)
    }
    
    private func limitTextFieldLength(_ textField: UITextField) -> Bool {
        switch textField {
        case let textField where textField == productNameTextField:
            guard let name = textField.text,
                  name.count >= 40 else {
                return true
            }
            
            self.presentConfirmAlert(message: AlertMessage.exceedValue.rawValue)
            return false
        case let textField where textField == originalPriceTextField:
            guard let originalPrice = textField.text,
                  originalPrice.count >= 10 else {
                return true
            }
            
            self.presentConfirmAlert(message: AlertMessage.exceedValue.rawValue)
            return false
        case let textField where textField == discountedPriceTextField:
            guard let discountedPrice = textField.text,
                  discountedPrice.count >= 10 else {
                return true
            }
            
            self.presentConfirmAlert(message: AlertMessage.exceedValue.rawValue)
            return false
        case let textField where textField == productStockTextField:
            guard let stock = textField.text,
                  stock.count >= 10 else {
                return true
            }
            
            self.presentConfirmAlert(message: AlertMessage.exceedValue.rawValue)
            return false
        default:
            return true
        }
    }
    
    private func checkNumberOfNameText(_ productNameText: String) {
        switch productNameText.count {
        case 0:
            presentConfirmAlert(message: AlertMessage.emptyValue.rawValue)
        case 1..<3:
            presentConfirmAlert(message: AlertMessage.additionalCharacters.rawValue)
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        switch textField {
        case productNameTextField:
            guard let productNameText =
                    productNameTextField.text?.replacingOccurrences(of: " ",
                                                                    with: "") else {
                return
            }
            
            checkNumberOfNameText(productNameText)
        case originalPriceTextField:
            guard let originalPricetext = originalPriceTextField.text,
                  originalPricetext.count == 0 else {
                return
            }
            
            self.presentConfirmAlert(message: AlertMessage.emptyValue.rawValue)
        default:
            break
        }
    }
}

// MARK: - UITextViewDelegate

extension ProductModificationViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard textView.text.count < 1000 else {
            self.presentConfirmAlert(message: AlertMessage.exceedValue.rawValue)
            return false
        }
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text == ProductStatus.productDescription.rawValue else {
            return
        }
        
        textView.text = nil
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        textView.text = ProductStatus.productDescription.rawValue
        textView.textColor = .lightGray
    }
}
