import UIKit

class ProductRegistrationViewController: UIViewController {
    
    enum Attribute {
        static let outerSpacing: CGFloat = 10
    }
    
    private var cancelButton: UIButton!
    private var titleLabel: UILabel!
    private var doneButton: UIButton!
    private var navigationStackView: UIStackView!
    
    private var imageStackView: UIStackView!
    private var imagePickerController: UIImagePickerController!
    private var imageScrollView: UIScrollView!
    
    private var nameTextField: UITextField!
    private var priceTextField: UITextField!
    private var currencySegmentedControl: UISegmentedControl!
    private var bargainPriceTextField: UITextField!
    private var stockTextField: UITextField!
    private var textFieldStackView: UIStackView!
    
    private var descriptionTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        createAllComponents()
        configureAttribute()
        configureLayout()
    }
    
    private func createAllComponents() {
        createNavigationStackView()
        createCancelButton()
        createTitleLabel()
        createDoneButton()
        
        createImageScrollView()
        createImageStackView()
        createImagePickerController()
        
        createTextFieldStackView()
        createNameTextField()
        createPriceTextField()
        createCurrencySegmentedControl()
        createBargainPriceTextField()
        createStockTextField()
        
        createDescriptionTextView()
    }
    
    private func configureAttribute() {
        configureMainViewAttribute()
        
        configureNavigationStackView()
        configureCancelButton()
        configureTitleLabel()
        configureDoneButton()
        
        configureImageScrollView()
        configureImageStackView()
        configureImagePickerController()
        
        configureTextFieldStackView()
        configureNameTextField()
        configurePriceTextField()
        configureCurrencySegmentedControl()
        configureBargainPriceTextField()
        configureStockTextField()
        
        configureDescriptionTextView()
    }
    
    private func configureLayout() {
        view.addSubview(navigationStackView)
        view.addSubview(imageScrollView)
//        view.addSubview(textFieldStackView)
//        view.addSubview(descriptionTextView)

        configureNavigationStackViewLayout()
        configureImageScrollViewLayout()
        configureImageStackViewLayout()
        configureTextFieldStackViewLayout()
        configureDescriptionTextViewLayout()
    }
    
    private func configureMainViewAttribute() {
        view.backgroundColor = .systemBackground
    }
}

//MARK: - NavigationStackView
extension ProductRegistrationViewController {
    
    private func createNavigationStackView() {
        navigationStackView = UIStackView()
        navigationStackView.backgroundColor = .systemBackground
        navigationStackView.axis = .horizontal
        navigationStackView.distribution = .fill
        navigationStackView.alignment = .center
    }
    
    private func configureNavigationStackView() {
    
    }
    
    private func configureNavigationStackViewLayout() {
        navigationStackView.addArrangedSubview(cancelButton)
        navigationStackView.addArrangedSubview(titleLabel)
        navigationStackView.addArrangedSubview(doneButton)
        navigationStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: Attribute.outerSpacing),
            navigationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                          constant: -1 * Attribute.outerSpacing),
            navigationStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationStackView.topAnchor.constraint(equalTo: titleLabel.topAnchor,
                                                    constant: -1 * Attribute.outerSpacing),
            navigationStackView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                    constant: Attribute.outerSpacing),
            navigationStackView.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
        ])
    }
}

//MARK: - CancelButton
extension ProductRegistrationViewController {
    
    private func createCancelButton() {
        cancelButton = UIButton(type: .system)
        cancelButton.tintColor = .systemBlue
        cancelButton.titleLabel?.textAlignment = .left
        
        let text = NSMutableAttributedString(string: "Cancel")
        text.adjustDynamicType(textStyle: .body)
        cancelButton.setAttributedTitle(text, for: .normal)
        cancelButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        cancelButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        
        cancelButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func configureCancelButton() {
        
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true)
    }
}

//MARK: - TitleLabel
extension ProductRegistrationViewController {
    
    private func createTitleLabel() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        
        let text = NSMutableAttributedString(string: "상품등록")
        text.adjustBold()
        text.adjustDynamicType(textStyle: .body)
        titleLabel.attributedText = text
        titleLabel.adjustsFontForContentSizeCategory = true
        
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    private func configureTitleLabel() {
    
    }
}

//MARK: - DoneButton
extension ProductRegistrationViewController {
    
    private func createDoneButton() {
        doneButton = UIButton(type: .system)
        doneButton.tintColor = .systemBlue
        
        let text = NSMutableAttributedString(string: "Done")
        text.adjustDynamicType(textStyle: .body)
        doneButton.setAttributedTitle(text, for: .normal)
        doneButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        doneButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func configureDoneButton() {
    
    }
}

//MARK: - ImageScrollView
extension ProductRegistrationViewController {
    
    private func createImageScrollView() {
        imageScrollView = UIScrollView()
    }
    
    private func configureImageScrollView() {
        
    }
    
    private func configureImageScrollViewLayout() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.addSubview(imageStackView)
        
        NSLayoutConstraint.activate([
            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: Attribute.outerSpacing),
            imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                         constant: -1 * Attribute.outerSpacing),
            imageScrollView.topAnchor.constraint(equalTo: navigationStackView.bottomAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
        ])
    }
}

//MARK: - ImageStackView
extension ProductRegistrationViewController {
    
    private func createImageStackView() {
        imageStackView = UIStackView()
    }

    private func configureImageStackView() {
        imageStackView.axis = .horizontal
        imageStackView.spacing = Attribute.outerSpacing
        
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
    
    private func createImagePickerController() {
        imagePickerController = UIImagePickerController()
    }
    
    private func configureImagePickerController() {
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
    
    private func createTextFieldStackView() {
        
    }
    
    private func configureTextFieldStackView() {
    
    }
    
    private func configureTextFieldStackViewLayout() {
        
    }
}

//MARK: - NameTextField
extension ProductRegistrationViewController {
    
    private func createNameTextField() {
        
    }
    
    private func configureNameTextField() {
    
    }
}

//MARK: - PriceTextField
extension ProductRegistrationViewController {
    
    private func createPriceTextField() {
        
    }
    
    private func configurePriceTextField() {
    
    }
}

//MARK: - CurrencySegmentedControl
extension ProductRegistrationViewController {
    
    private func createCurrencySegmentedControl() {
        
    }
    
    private func configureCurrencySegmentedControl() {
    
    }
}

//MARK: - BargainPriceTextField
extension ProductRegistrationViewController {
    
    private func createBargainPriceTextField() {
        
    }
    
    private func configureBargainPriceTextField() {
    
    }
}

//MARK: - StockTextField
extension ProductRegistrationViewController {
    
    private func createStockTextField() {
        
    }
    
    private func configureStockTextField() {
    
    }
}

//MARK: - configureDescriptionTextView
extension ProductRegistrationViewController {
    
    private func createDescriptionTextView() {
        
    }
    
    private func configureDescriptionTextView() {
    
    }
    
    private func configureDescriptionTextViewLayout() {
        
    }
}
