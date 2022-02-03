import UIKit
import JNomaKit

final class ProductRegistrationViewController: UIViewController {
    
    typealias Product = ProductDetailQueryManager.Response

    enum LayoutAttribute {
        static let largeSpacing: CGFloat = 10
        static let smallSpacing: CGFloat = 5
    }
    
    private let navigationBar = JNNavigationBar()
    private let wholeScreenScrollView = UIScrollView()
    private var imageScrollView: ImageScrollView!
    private let textFieldStackView = UIStackView()
    private let nameTextField = CenterAlignedTextField()
    private let priceStackView = UIStackView()
    private let priceTextField = CenterAlignedTextField()
    private let currencySegmentedControl = UISegmentedControl()
    private let bargainPriceTextField = CenterAlignedTextField()
    private let stockTextField = CenterAlignedTextField()
    private let descriptionTextView = UITextView()
    
    //MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        create()
        organizeViewHierarchy()
        configure()
    }
}

//MARK: - Private Method
extension ProductRegistrationViewController {
    private func create() {
        imageScrollView = ImageScrollView(mode: .register, viewController: self)
    }
    
    private func organizeViewHierarchy() {
        view.addSubview(navigationBar)
        view.addSubview(wholeScreenScrollView)

        wholeScreenScrollView.addSubview(imageScrollView)
        wholeScreenScrollView.addSubview(textFieldStackView)
        wholeScreenScrollView.addSubview(descriptionTextView)

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

    //MARK: - NavigationBar
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
        dismiss(animated: true)
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
        let images: [Data] = imageScrollView.allImageData
        
        guard (1...5).contains(images.count) else {
            return
        }
        
        NetworkingAPI.ProductRegistration.request(
            session: URLSession.shared,
            identifier: identifier,
            name: name,
            descriptions: description,
            price: price,
            currency: currency,
            discountedPrice: discountedPrice,
            stock: stock,
            secret: secret,
            images: images
        ) { result in
            
            switch result {
            case .success:
                print("upload success")
            case .failure(let error):
                print(error)
            }
        }

        dismiss(animated: true)
    }
    
    //MARK: - WholeScreenScrollView
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

    //MARK: - ImageScrollView
    private func configureImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageScrollView.widthAnchor.constraint(equalTo: wholeScreenScrollView.widthAnchor),
            imageScrollView.topAnchor.constraint(equalTo: wholeScreenScrollView.topAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
        ])
    }

    //MARK: - TextFieldStackView
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

    //MARK: - NameTextField
    private func configureNameTextField() {
        nameTextField.placeholder = "상품명"
    }

    //MARK: - PriceStackView
    private func configurePriceStackView() {
        priceStackView.axis = .horizontal
        priceStackView.alignment = .center
        priceStackView.spacing = LayoutAttribute.smallSpacing
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

    //MARK: - DescriptionTextView
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
