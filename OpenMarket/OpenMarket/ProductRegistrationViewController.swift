import UIKit

class ProductRegistrationViewController: UIViewController {
    
    enum Attribute {
        static let largeSpacing: CGFloat = 10
        static let smallSpacing: CGFloat = 5
    }
    
    private let cancelButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let doneButton = UIButton(type: .system)
    private let navigationStackView = UIStackView()
    
    private let imageStackView = UIStackView()
    private let imagePickerController = UIImagePickerController()
    private let imageScrollView = UIScrollView()
    
    private let textFieldStackView = UIStackView()
    private let nameTextField = CustomTextField()
    private let priceStackView = UIStackView()
    private let priceTextField = CustomTextField()
    private let currencySegmentedControl = UISegmentedControl()
    private let bargainPriceTextField = CustomTextField()
    private let stockTextField = CustomTextField()
    
    private let descriptionTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttribute()
        configureLayout()
    }

    private func configureAttribute() {
        configureMainViewAttribute()
        
        configureNavigationStackViewAttribute()
        configureCancelButtonAttribute()
        configureTitleLabelAttribute()
        configureDoneButtonAttribute()
        
        configureImageScrollViewAttribute()
        configureImageStackViewAttribute()
        configureImagePickerControllerAttribute()
        
        configureTextFieldStackViewAttribute()
        configureNameTextFieldAttribute()
        configurePriceStackViewAttribute()
        configurePriceTextFieldAttribute()
        configureCurrencySegmentedControlAttribute()
        configureBargainPriceTextFieldAttribute()
        configureStockTextFieldAttribute()
        
        configureDescriptionTextViewAttribute()
    }
    
    private func configureLayout() {
        configureMainViewLayout()
        
        configureNavigationStackViewLayout()
        configureImageScrollViewLayout()
        configureImageStackViewLayout()
        
        configurePriceStackViewLayout()
        configurePriceTextFieldLayout()
        configureCurrencySegmentedControlLayout()
        configureTextFieldStackViewLayout()
        configureDescriptionTextViewLayout()
    }
    
    private func configureMainViewAttribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureMainViewLayout() {
        view.addSubview(navigationStackView)
        view.addSubview(imageScrollView)
        view.addSubview(textFieldStackView)
        view.addSubview(descriptionTextView)
    }
}

//MARK: - NavigationStackView
extension ProductRegistrationViewController {
    
    private func configureNavigationStackViewAttribute() {
        navigationStackView.backgroundColor = .systemBackground
        navigationStackView.axis = .horizontal
        navigationStackView.distribution = .fill
        navigationStackView.alignment = .center
    }
    
    private func configureNavigationStackViewLayout() {
        navigationStackView.addArrangedSubview(cancelButton)
        navigationStackView.addArrangedSubview(titleLabel)
        navigationStackView.addArrangedSubview(doneButton)
        navigationStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: Attribute.largeSpacing),
            navigationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                          constant: -1 * Attribute.largeSpacing),
            navigationStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationStackView.topAnchor.constraint(equalTo: titleLabel.topAnchor,
                                                    constant: -1 * Attribute.largeSpacing),
            navigationStackView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                    constant: Attribute.largeSpacing),
            navigationStackView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
        ])
    }
}

//MARK: - CancelButton
extension ProductRegistrationViewController {

    private func configureCancelButtonAttribute() {
        cancelButton.tintColor = .systemBlue
        cancelButton.titleLabel?.textAlignment = .left
        
        let text = NSMutableAttributedString(string: "Cancel")
        text.adjustDynamicType(textStyle: .body)
        cancelButton.setAttributedTitle(text, for: .normal)
        cancelButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        cancelButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        
        cancelButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true)
    }
}

//MARK: - TitleLabel
extension ProductRegistrationViewController {

    private func configureTitleLabelAttribute() {
        titleLabel.textAlignment = .center
        
        let text = NSMutableAttributedString(string: "상품등록")
        text.adjustBold()
        text.adjustDynamicType(textStyle: .body)
        titleLabel.attributedText = text
        titleLabel.adjustsFontForContentSizeCategory = true
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

//MARK: - DoneButton
extension ProductRegistrationViewController {
    
    private func configureDoneButtonAttribute() {
        doneButton.tintColor = .systemBlue
        
        let text = NSMutableAttributedString(string: "Done")
        text.adjustDynamicType(textStyle: .body)
        doneButton.setAttributedTitle(text, for: .normal)
        doneButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        doneButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

//MARK: - ImageScrollView
extension ProductRegistrationViewController {

    private func configureImageScrollViewAttribute() {
        
    }
    
    private func configureImageScrollViewLayout() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.addSubview(imageStackView)
        
        NSLayoutConstraint.activate([
            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: Attribute.largeSpacing),
            imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                         constant: -1 * Attribute.largeSpacing),
            imageScrollView.topAnchor.constraint(equalTo: navigationStackView.bottomAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
        ])
    }
}

//MARK: - ImageStackView
extension ProductRegistrationViewController {

    private func configureImageStackViewAttribute() {
        imageStackView.axis = .horizontal
        imageStackView.spacing = Attribute.largeSpacing
        
        let defaultButton = UIButton()
        defaultButton.backgroundColor = .systemGray5
        defaultButton.setImage(UIImage(systemName: "plus"), for: .normal)
        defaultButton.addTarget(self, action: #selector(presentImagePickerController), for: .touchUpInside)
        
        imageStackView.addArrangedSubview(defaultButton)
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            defaultButton.heightAnchor.constraint(equalTo: imageStackView.heightAnchor),
            defaultButton.widthAnchor.constraint(equalTo: defaultButton.heightAnchor)
        ])
    }
    
    private func configureImageStackViewLayout() {
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageStackView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor)
        ])
    }
    
    private func addPickedImage(image: UIImage) {
        let imageView = UIImageView()
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageStackView.insertArrangedSubview(imageView, at: 0)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: imageStackView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
}

//MARK: - ImagePickerController
extension ProductRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private func configureImagePickerControllerAttribute() {
        imagePickerController.delegate = self
    }
    
    private func configureImagePickerControllerLayout() {
        
    }
    
    @objc private func presentImagePickerController() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addPickedImage(image: possibleImage)
        }

        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - TextFieldStackView
extension ProductRegistrationViewController {

    private func configureTextFieldStackViewAttribute() {
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = Attribute.smallSpacing
    }
    
    private func configureTextFieldStackViewLayout() {
        textFieldStackView.addArrangedSubview(nameTextField)
        textFieldStackView.addArrangedSubview(priceStackView)
        textFieldStackView.addArrangedSubview(bargainPriceTextField)
        textFieldStackView.addArrangedSubview(stockTextField)
        
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textFieldStackView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor,
                                                    constant: Attribute.largeSpacing),
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                        constant: Attribute.largeSpacing),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                        constant: -1 * Attribute.largeSpacing)
        ])
    }
}

//MARK: - NameTextField
extension ProductRegistrationViewController {

    private func configureNameTextFieldAttribute() {
        nameTextField.placeholder = "상품명"
    }
}

//MARK: - PriceStackView
extension ProductRegistrationViewController {
    
    private func configurePriceStackViewAttribute() {
        priceStackView.axis = .horizontal
        priceStackView.spacing = Attribute.smallSpacing
    }
    
    private func configurePriceStackViewLayout() {
        priceStackView.addArrangedSubview(priceTextField)
        priceStackView.addArrangedSubview(currencySegmentedControl)
    }
}

//MARK: - PriceTextField
extension ProductRegistrationViewController {
    
    private func configurePriceTextFieldAttribute() {
        priceTextField.placeholder = "상품가격"
    }
    
    private func configurePriceTextFieldLayout() {
        priceTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

//MARK: - CurrencySegmentedControl
extension ProductRegistrationViewController {
    
    private func configureCurrencySegmentedControlAttribute() {
        currencySegmentedControl.insertSegment(withTitle: "KRW", at: 0, animated: false)
        currencySegmentedControl.insertSegment(withTitle: "USD", at: 1, animated: false)
        currencySegmentedControl.selectedSegmentIndex = 0
    }
    
    private func configureCurrencySegmentedControlLayout() {
        currencySegmentedControl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

//MARK: - BargainPriceTextField
extension ProductRegistrationViewController {
    
    private func configureBargainPriceTextFieldAttribute() {
        bargainPriceTextField.placeholder = "할인금액"
    }
}

//MARK: - StockTextField
extension ProductRegistrationViewController {
    
    private func configureStockTextFieldAttribute() {
        stockTextField.placeholder = "재고수정"
    }
}

//MARK: - configureDescriptionTextView
extension ProductRegistrationViewController {
    
    private func configureDescriptionTextViewAttribute() {
        descriptionTextView.text = "설명"
        descriptionTextView.font = .preferredFont(forTextStyle: .callout)
        descriptionTextView.adjustsFontForContentSizeCategory = true
    }
    
    private func configureDescriptionTextViewLayout() {
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor,
                                                     constant: Attribute.largeSpacing),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: Attribute.largeSpacing),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                          constant: -1 * Attribute.largeSpacing),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                        constant: -1 * Attribute.largeSpacing)
        ])
    }
}
