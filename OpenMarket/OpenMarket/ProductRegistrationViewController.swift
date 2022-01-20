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
        configure()
    }

    private func configure() {
        configureMainView()
        
        configureNavigationStackView()
        configureCancelButton()
        configureTitleLabel()
        configureDoneButton()
        
        configureImageScrollView()
        configureImageStackView()
        configureImagePickerController()
        
        configureTextFieldStackView()
        configureNameTextField()
        configurePriceStackView()
        configurePriceTextField()
        configureCurrencySegmentedControl()
        configureBargainPriceTextField()
        configureStockTextField()
        
        configureDescriptionTextView()
    }
    
    //MARK: - MainView
    private func configureMainView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(navigationStackView)
        view.addSubview(imageScrollView)
        view.addSubview(textFieldStackView)
        view.addSubview(descriptionTextView)
    }
}

//MARK: - NavigationStackView
extension ProductRegistrationViewController {
    
    private func configureNavigationStackView() {
        navigationStackView.backgroundColor = .systemBackground
        navigationStackView.axis = .horizontal
        navigationStackView.distribution = .fill
        navigationStackView.alignment = .center
        
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
    
    //MARK: - CancelButton
    private func configureCancelButton() {
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
    
    //MARK: - TitleLabel
    private func configureTitleLabel() {
        titleLabel.textAlignment = .center
        
        let text = NSMutableAttributedString(string: "상품등록")
        text.adjustBold()
        text.adjustDynamicType(textStyle: .body)
        titleLabel.attributedText = text
        titleLabel.adjustsFontForContentSizeCategory = true
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    //MARK: - DoneButton
    private func configureDoneButton() {
        doneButton.tintColor = .systemBlue
        
        let text = NSMutableAttributedString(string: "Done")
        text.adjustDynamicType(textStyle: .body)
        doneButton.setAttributedTitle(text, for: .normal)
        doneButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        doneButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

//MARK: - ImageScrollView
extension ProductRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private func configureImageScrollView() {
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
    
    //MARK: - ImageStackView
    private func configureImageStackView() {
        imageStackView.axis = .horizontal
        imageStackView.spacing = Attribute.largeSpacing
        
        createDefaultButton()
        
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageStackView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor)
        ])
    }
    
    private func createDefaultButton() {
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
    
    //MARK: - ImagePickerController
    @objc private func presentImagePickerController() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func configureImagePickerController() {
        imagePickerController.delegate = self
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addPickedImage(image: possibleImage)
        }

        picker.dismiss(animated: true, completion: nil)
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

//MARK: - TextFieldStackView
extension ProductRegistrationViewController {

    private func configureTextFieldStackView() {
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = Attribute.smallSpacing
        
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
    
    //MARK: - NameTextField
    private func configureNameTextField() {
        nameTextField.placeholder = "상품명"
    }
    
    //MARK: - PriceStackView
    private func configurePriceStackView() {
        priceStackView.axis = .horizontal
        priceStackView.spacing = Attribute.smallSpacing
        
        priceStackView.addArrangedSubview(priceTextField)
        priceStackView.addArrangedSubview(currencySegmentedControl)
    }
    
    //MARK: - PriceTextField
    private func configurePriceTextField() {
        priceTextField.placeholder = "상품가격"
        
        priceTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    //MARK: - CurrencySegmentedControl
    private func configureCurrencySegmentedControl() {
        currencySegmentedControl.insertSegment(withTitle: "KRW", at: 0, animated: false)
        currencySegmentedControl.insertSegment(withTitle: "USD", at: 1, animated: false)
        currencySegmentedControl.selectedSegmentIndex = 0
        
        currencySegmentedControl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    //MARK: - BargainPriceTextField
    private func configureBargainPriceTextField() {
        bargainPriceTextField.placeholder = "할인금액"
    }
    
    //MARK: - StockTextField
    private func configureStockTextField() {
        stockTextField.placeholder = "재고수정"
    }
}

//MARK: - configureDescriptionTextView
extension ProductRegistrationViewController {
    
    private func configureDescriptionTextView() {
        descriptionTextView.text = "설명"
        descriptionTextView.font = .preferredFont(forTextStyle: .callout)
        descriptionTextView.adjustsFontForContentSizeCategory = true
        
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
