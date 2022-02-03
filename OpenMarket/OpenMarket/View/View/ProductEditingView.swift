import UIKit
import JNomaKit

class ProductEditingView: UIView {
    
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

    let navigationBar = JNNavigationBar()
    let wholeScreenScrollView = UIScrollView()
    let imageScrollView = ImageScrollView()
    let textFieldStackView = UIStackView()
    let nameTextField = CenterAlignedTextField()
    let priceStackView = UIStackView()
    let priceTextField = CenterAlignedTextField()
    let currencySegmentedControl = UISegmentedControl()
    let bargainPriceTextField = CenterAlignedTextField()
    let stockTextField = CenterAlignedTextField()
    let descriptionTextView = UITextView()
    
    private weak var viewController: UIViewController?
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        organizeViewHierarchy()
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(viewController: UIViewController) {
        self.init(frame: CGRect())
        self.viewController = viewController
    }
    
    private func organizeViewHierarchy() {
        addSubview(navigationBar)
        addSubview(wholeScreenScrollView)

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
        backgroundColor = .systemBackground
    }
}

//MARK: - NavigationBar
extension ProductEditingView {
    
    private func configureNavigationBar() {
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                         constant: LayoutAttribute.largeSpacing),
            navigationBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                          constant: -1 * LayoutAttribute.largeSpacing),
            navigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
    }
}

//MARK: - WholeScreenScrollView
extension ProductEditingView {
    
    private func configureWholeScreenScrollView() {
        wholeScreenScrollView.translatesAutoresizingMaskIntoConstraints = false
        wholeScreenScrollView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            wholeScreenScrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                                       constant: LayoutAttribute.largeSpacing),
            wholeScreenScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            wholeScreenScrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                           constant: LayoutAttribute.largeSpacing),
            wholeScreenScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                            constant: -1 * LayoutAttribute.largeSpacing)
        ])
    }
}

//MARK: - ImageScrollView
extension ProductEditingView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private func configureImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageScrollView.widthAnchor.constraint(equalTo: wholeScreenScrollView.widthAnchor),
            imageScrollView.topAnchor.constraint(equalTo: wholeScreenScrollView.topAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),
        ])
    }
}

//MARK: - TextFieldStackView
extension ProductEditingView {

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
extension ProductEditingView {
    
    private func configureNameTextField() {
        nameTextField.placeholder = "상품명"
    }
}

//MARK: - PriceStackView
extension ProductEditingView {
    
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
extension ProductEditingView {
    
    private func configurePriceTextField() {
        priceTextField.placeholder = "상품가격"
        
        priceTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

//MARK: - CurrencySegmentedControl
extension ProductEditingView {
    
    private func configureCurrencySegmentedControl() {
        currencySegmentedControl.insertSegment(withTitle: "KRW", at: 0, animated: false)
        currencySegmentedControl.insertSegment(withTitle: "USD", at: 1, animated: false)
        currencySegmentedControl.selectedSegmentIndex = 0
        currencySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        currencySegmentedControl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

//MARK: - BargainPriceTextField
extension ProductEditingView {
    
    private func configureBargainPriceTextField() {
        bargainPriceTextField.placeholder = "할인금액"
    }
}

//MARK: - StockTextField
extension ProductEditingView {
    
    private func configureStockTextField() {
        stockTextField.placeholder = "재고수정"
    }
}

//MARK: - DescriptionTextView
extension ProductEditingView {
    
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
            descriptionTextView.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
}
