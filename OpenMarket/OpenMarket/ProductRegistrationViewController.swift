import UIKit

class ProductRegistrationViewController: UIViewController {
    
    typealias Product = ProductDetailQueryManager.Response
    
    enum LayoutAttribute {
        static let largeSpacing: CGFloat = 10
        static let smallSpacing: CGFloat = 5
    }
    
    enum ProductImageAttribute {
        static let minimumImageCount = 1
        static let maximumImageCount = 5
        static let maximumImageBytesSize = 300 * 1024
        static let recommendedImageWidth: CGFloat = 500
        static let recommendedImageHeight: CGFloat = 500
    }

    var navigationBar: PlainNavigationBar!
    
    private let wholeScreenScrollView = UIScrollView()
    
    let imageStackView = UIStackView()
    let imageAddingButton = UIButton()
    private let imagePickerController = UIImagePickerController()
    private let imageScrollView = UIScrollView()
    
    private let textFieldStackView = UIStackView()
    let nameTextField = CenterAlignedTextField()
    let priceStackView = UIStackView()
    let priceTextField = CenterAlignedTextField()
    let currencySegmentedControl = UISegmentedControl()
    let bargainPriceTextField = CenterAlignedTextField()
    let stockTextField = CenterAlignedTextField()
    
    let descriptionTextView = UITextView()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        create()
        organizeViewHierarchy()
        configure()
    }
    
    //MARK: - Private Method
    private func create() {
        createNavigationBar()
    }
    
    private func organizeViewHierarchy() {
        view.addSubview(navigationBar)
        view.addSubview(wholeScreenScrollView)

        wholeScreenScrollView.addSubview(imageScrollView)
        wholeScreenScrollView.addSubview(textFieldStackView)
        wholeScreenScrollView.addSubview(descriptionTextView)
        
        imageScrollView.addSubview(imageStackView)
        imageStackView.addArrangedSubview(imageAddingButton)

        textFieldStackView.addArrangedSubview(nameTextField)
        textFieldStackView.addArrangedSubview(priceStackView)
        textFieldStackView.addArrangedSubview(bargainPriceTextField)
        textFieldStackView.addArrangedSubview(stockTextField)
    }

    private func configure() {
        configureMainView()
        configureNavigationBar()
        configureWholeScreenScrollView()
        configureImageScrollView()
        configureImageStackView()
        configureImageAddingButton()
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

//MARK: - NavigationBar
extension ProductRegistrationViewController {
    
    private func createNavigationBar() {
        self.navigationBar = PlainNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationBar.setLeftButton(title: "Cancel", action: #selector(dismissModal))
        navigationBar.setMainLabel(title: "상품등록")
        navigationBar.setRightButton(title: "Done", action: #selector(registerProduct))
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                         constant: LayoutAttribute.largeSpacing),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                          constant: -1 * LayoutAttribute.largeSpacing),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    @objc private func dismissModal() {
        //dismiss가 되긴 되는데, 이게 약한 참조로 작동할까..
        { [weak self] in
            self?.dismiss(animated: true)
        }()
    }
    
    @objc private func registerProduct() {
        guard let name = nameTextField.text,
              let description = descriptionTextView.text,
              let priceText = priceTextField.text,
              let price = Double(priceText),
              let currency = currencySegmentedControl.titleForSegment(at: currencySegmentedControl.selectedSegmentIndex),
              let discountedPriceText = bargainPriceTextField.text,
              let discountedPrice = Double(discountedPriceText),
              let stockText = stockTextField.text else {
                  return
              }
        
        let identifier = Vendor.identifier
        let stock: Int = Int(stockText) ?? 0
        let secret = Vendor.secret
        let images: [Data] = extractedImageDataFromStackView()
        
        guard (1...5).contains(images.count) else {
            return
        }
        
        NetworkingAPI.ProductRegistration.request(session: URLSession.shared,
                                                  identifier: identifier,
                                                  name: name,
                                                  descriptions: description,
                                                  price: price,
                                                  currency: currency,
                                                  discountedPrice: discountedPrice,
                                                  stock: stock,
                                                  secret: secret,
                                                  images: images) { result in
            
            switch result {
            case .success:
                print("upload success")
            case .failure(let error):
                print(error)
            }
        }

        dismiss(animated: true)
    }
    
    private func extractedImageDataFromStackView() -> [Data] {
        var images: [Data] = []
        
        imageStackView.arrangedSubviews.forEach {
            guard let imageView = $0 as? UIImageView,
                  let imageData = imageView.image?.jpegData(underBytes: ProductImageAttribute.maximumImageBytesSize) else {
                      print(OpenMarketError.conversionFail("UIImage", "JPEG Data").description)
                      return
                  }
            images.append(imageData)
        }
        
        return images
    }
}

//MARK: - WholeScreenScrollView
extension ProductRegistrationViewController {
    
    private func configureWholeScreenScrollView() {
        wholeScreenScrollView.translatesAutoresizingMaskIntoConstraints = false
        wholeScreenScrollView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            wholeScreenScrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                                       constant: LayoutAttribute.largeSpacing),
            wholeScreenScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            wholeScreenScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                           constant: LayoutAttribute.largeSpacing),
            wholeScreenScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                            constant: -1 * LayoutAttribute.largeSpacing)
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
}

//MARK: - ImageStackView
extension ProductRegistrationViewController {

    private func configureImageStackView() {
        imageStackView.axis = .horizontal
        imageStackView.spacing = LayoutAttribute.largeSpacing
        
        imageStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageStackView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor)
        ])
    }
    
    func addToStack(image: UIImage) {
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

//MARK: - ImageAddingButton
extension ProductRegistrationViewController {
    
    private func configureImageAddingButton() {
        imageAddingButton.backgroundColor = .systemGray5
        imageAddingButton.setImage(UIImage(systemName: "plus"), for: .normal)
        imageAddingButton.addTarget(self, action: #selector(presentImagePickerController), for: .touchUpInside)
        
        imageAddingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageAddingButton.heightAnchor.constraint(equalTo: imageStackView.heightAnchor),
            imageAddingButton.widthAnchor.constraint(equalTo: imageAddingButton.heightAnchor)
        ])
    }
    
    private func hideImageAddingButtonIfNeeded() {
        let images = imageStackView.arrangedSubviews.compactMap {
            $0 as? UIImageView
        }
        if images.count >= ProductImageAttribute.maximumImageCount {
            imageAddingButton.isHidden = true
        }
    }
    
    @objc private func presentImagePickerController() {
        present(imagePickerController, animated: true, completion: nil)
    }
}

//MARK: - ImagePickerController
extension ProductRegistrationViewController {
    
    private func configureImagePickerController() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
              let squareImage = editedImage.croppedToSquareForm() else {
                  print(OpenMarketError.conversionFail("basic UIImage", "cropped to square form").description)
                  return
              }

        if squareImage.size.width > ProductImageAttribute.recommendedImageWidth {
            let resizedImage = squareImage.resized(width: ProductImageAttribute.recommendedImageWidth,
                                            height: ProductImageAttribute.recommendedImageHeight)
            addToStack(image: resizedImage)
        } else {
            addToStack(image: squareImage)
        }
        
        picker.dismiss(animated: true, completion: nil)
        hideImageAddingButtonIfNeeded()
    }
}

//MARK: - TextFieldStackView
extension ProductRegistrationViewController {

    private func configureTextFieldStackView() {
        textFieldStackView.axis = .vertical
        textFieldStackView.spacing = LayoutAttribute.smallSpacing
        
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textFieldStackView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor,
                                                    constant: LayoutAttribute.largeSpacing),
            textFieldStackView.widthAnchor.constraint(equalTo: wholeScreenScrollView.widthAnchor),
        ])
    }
}

//MARK: - NameTextField
extension ProductRegistrationViewController {
    
    private func configureNameTextField() {
        nameTextField.placeholder = "상품명"
    }
}

//MARK: - PriceStackView
extension ProductRegistrationViewController {
    
    private func configurePriceStackView() {
        priceStackView.axis = .horizontal
        priceStackView.alignment = .center
        priceStackView.spacing = LayoutAttribute.smallSpacing
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        priceStackView.addArrangedSubview(priceTextField)
        priceStackView.addArrangedSubview(currencySegmentedControl)
    }
}

//MARK: - PriceTextField
extension ProductRegistrationViewController {
    
    private func configurePriceTextField() {
        priceTextField.placeholder = "상품가격"
        
        priceTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

//MARK: - CurrencySegmentedControl
extension ProductRegistrationViewController {
    
    private func configureCurrencySegmentedControl() {
        currencySegmentedControl.insertSegment(withTitle: "KRW", at: 0, animated: false)
        currencySegmentedControl.insertSegment(withTitle: "USD", at: 1, animated: false)
        currencySegmentedControl.selectedSegmentIndex = 0
        currencySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        currencySegmentedControl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

//MARK: - BargainPriceTextField
extension ProductRegistrationViewController {
    
    private func configureBargainPriceTextField() {
        bargainPriceTextField.placeholder = "할인금액"
    }
}

//MARK: - StockTextField
extension ProductRegistrationViewController {
    
    private func configureStockTextField() {
        stockTextField.placeholder = "재고수정"
    }
}

//MARK: - DescriptionTextView
extension ProductRegistrationViewController {
    
    private func configureDescriptionTextView() {
        descriptionTextView.text = "설명"
        descriptionTextView.font = .preferredFont(forTextStyle: .callout)
        descriptionTextView.adjustsFontForContentSizeCategory = true
        descriptionTextView.isScrollEnabled = false
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor,
                                                     constant: LayoutAttribute.largeSpacing),
            descriptionTextView.bottomAnchor.constraint(equalTo: wholeScreenScrollView.bottomAnchor),
            descriptionTextView.widthAnchor.constraint(equalTo: wholeScreenScrollView.widthAnchor),
            descriptionTextView.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
    }
}
