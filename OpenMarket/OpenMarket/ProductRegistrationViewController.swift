import UIKit

class ProductRegistrationViewController: UIViewController {
    
    private var cancelButton: UIButton!
    private var titleLabel: UILabel!
    private var doneButton: UIButton!
    private var navigationStackView: UIStackView!
    
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
        createCancelButton()
        createTitleLabel()
        createDoneButton()
        createNavigationStackView()
        
        createImagePickerController()
        createImageScrollView()
        
        createNameTextField()
        createPriceTextField()
        createCurrencySegmentedControl()
        createBargainPriceTextField()
        createStockTextField()
        createTextFieldStackView()
        
        createDescriptionTextView()
    }
    
    private func configureAttribute() {
        configureMainViewAttribute()
        
        configureCancelButton()
        configureTitleLabel()
        configureDoneButton()
        configureNavigationStackView()
        
        configureImagePickerController()
        configureImageScrollView()

        configureNameTextField()
        configurePriceTextField()
        configureCurrencySegmentedControl()
        configureBargainPriceTextField()
        configureStockTextField()
        configureTextFieldStackView()
        
        configureDescriptionTextView()
    }
    
    private func configureMainViewAttribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        view.addSubview(navigationStackView)
//        view.addSubview(imageScrollView)
//        view.addSubview(textFieldStackView)
//        view.addSubview(descriptionTextView)

        configureCancelButtonLayout()
        configureNavigationStackViewLayout()
    }
    
}

//MARK: - CancelButton
extension ProductRegistrationViewController {
    
    private func createCancelButton() {
        cancelButton = UIButton(type: .system)
        cancelButton.tintColor = .systemBlue
        
        let text = NSMutableAttributedString(string: "Cancel")
        text.adjustDynamicType(textStyle: .body)
        cancelButton.setAttributedTitle(text, for: .normal)
        cancelButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        cancelButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
    }
    
    private func configureCancelButton() {
        
    }
    
    private func configureCancelButtonLayout() {
        
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true)
    }
}

//MARK: - TitleLabel
extension ProductRegistrationViewController {
    
    private func createTitleLabel() {
        titleLabel = UILabel()
        
        let text = NSMutableAttributedString(string: "상품등록")
        text.adjustBold()
        text.adjustDynamicType(textStyle: .body)
        titleLabel.attributedText = text
        titleLabel.adjustsFontForContentSizeCategory = true
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
    }
    
    private func configureDoneButton() {
    
    }
}

//MARK: - NavigationStackView
extension ProductRegistrationViewController {
    
    enum NavigationStackViewAttribute {
        static let externalSpacing: CGFloat = 10
    }
    
    private func createNavigationStackView() {
        navigationStackView = UIStackView(arrangedSubviews: [cancelButton, titleLabel, doneButton])
        navigationStackView.backgroundColor = .systemBackground
        navigationStackView.axis = .horizontal
        navigationStackView.distribution = .equalSpacing
    }
    
    private func configureNavigationStackView() {
    
    }
    
    private func configureNavigationStackViewLayout() {
        navigationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                         constant: NavigationStackViewAttribute.externalSpacing),
            navigationStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                         constant: -1 * NavigationStackViewAttribute.externalSpacing),
            navigationStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        ])
    }
}

//MARK: - ImagePickerController
extension ProductRegistrationViewController {
    
    private func createImagePickerController() {
        
    }
    
    private func configureImagePickerController() {
    
    }
}

//MARK: - ImageScrollView
extension ProductRegistrationViewController {
    
    private func createImageScrollView() {
        
    }
    
    private func configureImageScrollView() {
    
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

//MARK: - TextFieldStackView
extension ProductRegistrationViewController {
    
    private func createTextFieldStackView() {
        
    }
    
    private func configureTextFieldStackView() {
    
    }
}

//MARK: - configureDescriptionTextView
extension ProductRegistrationViewController {
    
    private func createDescriptionTextView() {
        
    }
    
    private func configureDescriptionTextView() {
    
    }
}
