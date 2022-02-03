import UIKit
import JNomaKit

final class ProductModificationViewController: UIViewController {
    
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
    private let         discountedPriceTextField = CenterAlignedTextField()
    private let stockTextField = CenterAlignedTextField()
    private let descriptionTextView = UITextView()
    private var product: Product?
    
    //MARK: - Initializer
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(product: Product) {
        self.init(nibName: nil, bundle: nil)
        self.product = product
    }
    
    //MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        create()
        organizeViewHierarchy()
        configure()
    }
}

extension ProductModificationViewController {
    private func create() {
        imageScrollView = ImageScrollView(mode: .modify, viewController: nil)
    }
    
    private func organizeViewHierarchy() {
        view.addSubview(navigationBar)
        view.addSubview(wholeScreenScrollView)

        wholeScreenScrollView.addSubview(imageScrollView)
        wholeScreenScrollView.addSubview(textFieldStackView)
        wholeScreenScrollView.addSubview(descriptionTextView)

        textFieldStackView.addArrangedSubview(nameTextField)
        textFieldStackView.addArrangedSubview(priceStackView)
        textFieldStackView.addArrangedSubview(discountedPriceTextField)
        textFieldStackView.addArrangedSubview(stockTextField)
    }
    
    private func configure() {
        guard let product = product else { return }
        
        configureMainView()
        configureNavigationBar()
        configureWholeScreenScrollView()
        configureImageScrollView(images: product.images)
        configureTextFieldStackView()
        configureNameTextField(text: product.name)
        configurePriceStackView()
        configurePriceTextField(price: product.price)
        configureCurrencySegmentedControl(currency: product.currency)
        configureDiscountedPriceTextField(discountedPrice: product.discountedPrice)
        configureStockTextField(stock: product.stock)
        configureDescriptionTextView(text: product.description)
    }
    
    private func configureMainView() {
        view.backgroundColor = .systemBackground
    }

    //MARK: - NavigationBar
    private func configureNavigationBar() {
        navigationBar.setLeftButton(title: "Cancel", action: #selector(dismissModal))
        navigationBar.setMainLabel(title: "상품수정")
        navigationBar.setRightButton(title: "Done", action: #selector(modifyProduct))
        
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
    
    @objc private func modifyProduct() {
        guard let product = product else {
                  return
              }
        
        let currency = currencySegmentedControl.titleForSegment(at: currencySegmentedControl.selectedSegmentIndex)
        NetworkingAPI.ProductModify.request(
            session: URLSession.shared,
            identifier: Vendor.identifier,
            productId: product.id,
            name: nameTextField.text,
            descriptions: descriptionTextView.text,
            thumbnailId: nil,
            price: Double(priceTextField.text ?? ""),
            currency: currency,
            discountedPrice: Double(        discountedPriceTextField.text ?? ""),
            stock: Int(stockTextField.text ?? ""),
            secret: Vendor.secret
        ) { result in
            
            switch result {
            case .success:
                print("Modify success")
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
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
    private func configureImageScrollView(images: [Product.Image]) {
        fillImages(images: images)
    
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageScrollView.widthAnchor.constraint(equalTo: wholeScreenScrollView.widthAnchor),
            imageScrollView.topAnchor.constraint(equalTo: wholeScreenScrollView.topAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
        ])
    }
    
    private func fillImages(images: [Product.Image]) {
        for _ in (1...images.count) {
            imageScrollView.pushToStack(imageView: UIImageView())
        }

        for (index, image) in images.enumerated() {
            ImageLoader.load(from: image.url) { result in
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else {
                        print(OpenMarketError.conversionFail("Data", "UIImage"))
                        return
                    }
                    DispatchQueue.main.async {
                        self.imageScrollView.update(image: image, at: index)
                    }
                case .failure(let error):
                    print(error.description)
                }
            }
        }
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
    private func configureNameTextField(text: String) {
        nameTextField.text = text
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
    private func configurePriceTextField(price: Double) {
        priceTextField.text = String(Int(price))
        priceTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    //MARK: - CurrencySegmentedControl
    private func configureCurrencySegmentedControl(currency: ProductDetailQueryManager.Currency){
        currencySegmentedControl.insertSegment(withTitle: "KRW", at: 0, animated: false)
        currencySegmentedControl.insertSegment(withTitle: "USD", at: 1, animated: false)
        let selectedIndex = currency == .KRW ? 0 : 1
        currencySegmentedControl.selectedSegmentIndex = selectedIndex
        currencySegmentedControl.isUserInteractionEnabled = false
        currencySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        currencySegmentedControl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    //MARK: - BargainPriceTextField
    private func configureDiscountedPriceTextField(discountedPrice: Double){
        discountedPriceTextField.text = String(Int(discountedPrice))
    }
    
    //MARK: - StockTextField
    private func configureStockTextField(stock: Int){
        stockTextField.text = String(stock)
    }
    
    //MARK: - DescriptionTextView
    private func configureDescriptionTextView(text: String){
        descriptionTextView.text = text
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


