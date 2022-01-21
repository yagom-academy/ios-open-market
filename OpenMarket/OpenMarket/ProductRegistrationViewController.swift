import UIKit

class ProductRegistrationViewController: UIViewController {
    
    enum Attribute {
        static let largeSpacing: CGFloat = 10
        static let smallSpacing: CGFloat = 5
    }
    
    private let cancelButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let doneButton = UIButton(type: .system)
    private let navigationView = UIView()
    
    private let wholeScreenScrollView = UIScrollView()
    
    private let imageStackView = UIStackView()
    private let imagePickerController = UIImagePickerController()
    private let imageScrollView = UIScrollView()
    
    private let textFieldStackView = UIStackView()
    private let nameTextField = AlignedTextField()
    private let priceStackView = UIStackView()
    private let priceTextField = AlignedTextField()
    private let currencySegmentedControl = UISegmentedControl()
    private let bargainPriceTextField = AlignedTextField()
    private let stockTextField = AlignedTextField()
    
    private let descriptionTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configure()
    }
    
    private func configureHierarchy() {
        view.addSubview(navigationView)
        view.addSubview(wholeScreenScrollView)

        navigationView.addSubview(cancelButton)
        navigationView.addSubview(titleLabel)
        navigationView.addSubview(doneButton)

        wholeScreenScrollView.addSubview(imageScrollView)
        wholeScreenScrollView.addSubview(textFieldStackView)
        wholeScreenScrollView.addSubview(descriptionTextView)
        
        imageScrollView.addSubview(imageStackView)

        textFieldStackView.addArrangedSubview(nameTextField)
        textFieldStackView.addArrangedSubview(priceStackView)
        textFieldStackView.addArrangedSubview(bargainPriceTextField)
        textFieldStackView.addArrangedSubview(stockTextField)
    }

    private func configure() {
        configureMainView()

        configureNavigationView()
        configureCancelButton()
        configureTitleLabel()
        configureDoneButton()

        configureWholeScreenScrollView()
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
    }
}

//MARK: - NavigationView
extension ProductRegistrationViewController {
    
    private func configureNavigationView() {
        navigationView.backgroundColor = .systemBackground
  
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        navigationView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            navigationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                         constant: Attribute.largeSpacing),
            navigationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                          constant: -1 * Attribute.largeSpacing),
            navigationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationView.topAnchor.constraint(equalTo: titleLabel.topAnchor,
                                                constant: -1 * Attribute.largeSpacing),
            navigationView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                constant: Attribute.largeSpacing),
        ])
    }
    
    //MARK: - CancelButton
    private func configureCancelButton() {
        let text = NSMutableAttributedString(string: "Cancel")
        text.adjustDynamicType(textStyle: .body)
        cancelButton.setAttributedTitle(text, for: .normal)
        cancelButton.tintColor = .systemBlue
        cancelButton.titleLabel?.textAlignment = .left
        cancelButton.titleLabel?.adjustsFontForContentSizeCategory = true
        cancelButton.titleLabel?.translatesAutoresizingMaskIntoConstraints = false

        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: navigationView.leadingAnchor),
            cancelButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor)
        ])
        
        cancelButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
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
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: navigationView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor)
        ])
    }
    
    //MARK: - DoneButton
    private func configureDoneButton() {
        doneButton.tintColor = .systemBlue
        
        let text = NSMutableAttributedString(string: "Done")
        text.adjustDynamicType(textStyle: .body)
        doneButton.setAttributedTitle(text, for: .normal)
        doneButton.titleLabel?.adjustsFontForContentSizeCategory = true
        doneButton.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        doneButton.addTarget(self, action: #selector(registerProduct), for: .touchUpInside)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.trailingAnchor.constraint(equalTo: navigationView.trailingAnchor),
            doneButton.centerYAnchor.constraint(equalTo: navigationView.centerYAnchor)
        ])
    }
    
    @objc private func registerProduct() {
        let identifier = Vendor.identifier
        guard let name = nameTextField.text else {
            return
        }
        guard let description = descriptionTextView.text else {
            return
        }
        guard let priceText = priceTextField.text,
              let price = Double(priceText) else {
                  return
              }
        guard let currency = currencySegmentedControl.titleForSegment(at: currencySegmentedControl.selectedSegmentIndex) else {
                  return
              }
        guard let discountedPriceText = bargainPriceTextField.text,
              let discountedPrice = Double(discountedPriceText) else {
                  return
              }
        
        guard let stockText = stockTextField.text else {
            return
        }
        let stock: Int = Int(stockText) ?? 0
        
        let secret = Vendor.secret
        let images: [Data] = {
            var images: [Data] = []
            imageStackView.arrangedSubviews.forEach {
                guard let imageView = $0 as? UIImageView,
                      let image = imageView.image?.jpegData(compressionQuality: 0.5) else {
                    return
                }
                images.append(image)
            }
            return images
        }()
        
        NetworkingAPI.ProductRegistration.request(session: URLSession.shared,
                                                  identifier: identifier,
                                                  name: name,
                                                  descriptions: description,
                                                  price: price,
                                                  currency: currency,
                                                  discountedPrice: discountedPrice,
                                                  stock: stock,
                                                  secret: secret,
                                                  images: images) {

            (result) in
            
            switch result {
            case .success:
                print("upload success")
            case .failure(let error):
                print(error)
            }
        }

        dismiss(animated: true)
    }
}

//MARK: - WholeScreenScrollView
extension ProductRegistrationViewController {
    
    private func configureWholeScreenScrollView() {
        wholeScreenScrollView.translatesAutoresizingMaskIntoConstraints = false
        wholeScreenScrollView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            wholeScreenScrollView.topAnchor.constraint(equalTo: navigationView.bottomAnchor,
                                                       constant: Attribute.largeSpacing),
            wholeScreenScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            wholeScreenScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                           constant: Attribute.largeSpacing),
            wholeScreenScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                            constant: -1 * Attribute.largeSpacing)
        ])
    }
}

//MARK: - ImageScrollView
extension ProductRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private func configureImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageScrollView.widthAnchor.constraint(equalTo: wholeScreenScrollView.widthAnchor),
            imageScrollView.topAnchor.constraint(equalTo: wholeScreenScrollView.topAnchor),
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
        
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textFieldStackView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor,
                                                    constant: Attribute.largeSpacing),
            textFieldStackView.widthAnchor.constraint(equalTo: wholeScreenScrollView.widthAnchor),
        ])
    }
    
    //MARK: - NameTextField
    private func configureNameTextField() {
        nameTextField.placeholder = "상품명"
    }
    
    //MARK: - PriceStackView
    private func configurePriceStackView() {
        priceStackView.axis = .horizontal
        priceStackView.alignment = .center
        priceStackView.spacing = Attribute.smallSpacing
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
        currencySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
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
        descriptionTextView.isScrollEnabled = false
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor,
                                                     constant: Attribute.largeSpacing),
            descriptionTextView.bottomAnchor.constraint(equalTo: wholeScreenScrollView.bottomAnchor),
            descriptionTextView.widthAnchor.constraint(equalTo: wholeScreenScrollView.widthAnchor),
            descriptionTextView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
    }
}
