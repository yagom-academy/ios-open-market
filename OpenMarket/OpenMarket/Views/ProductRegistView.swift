import UIKit

class ProductRegistView: UIView {

    // MARK: - Properties

    var productInfo: Page?
    
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let itemImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let itemNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품명"
        textField.autocorrectionType = .no
        textField.font = .preferredFont(forTextStyle: .body)
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    
    let itemPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "상품가격"
        textField.keyboardType = .numberPad
        textField.font = .preferredFont(forTextStyle: .body)
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    
    let currencySegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["KRW", "USD"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private let currencyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let itemSaleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "할인금액"
        textField.keyboardType = .numberPad
        textField.font = .preferredFont(forTextStyle: .body)
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    
    let itemStockTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "재고수량"
        textField.keyboardType = .numberPad
        textField.font = .preferredFont(forTextStyle: .body)
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    
    let addImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemGray3
        return button
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
    
    let descriptionTextViewPlaceHolder: UILabel = {
        let label = UILabel()
        label.text = "상품설명"
        label.sizeToFit()
        label.textColor = .tertiaryLabel
        label.frame.origin = CGPoint(x: 6, y: 8)
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configureLayoutContraints()
        configureDescriptionPlaceholder()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UIView Functions

extension ProductRegistView {
    private func configureDescriptionPlaceholder() {
        descriptionTextViewPlaceHolder.font = descriptionTextView.font
        descriptionTextView.addSubview(descriptionTextViewPlaceHolder)
        descriptionTextViewPlaceHolder.isHidden = !descriptionTextView.text.isEmpty
    }
    
    private func addViews() {
        addSubview(mainScrollView)
        
        mainScrollView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(itemImageScrollView)
        mainStackView.addArrangedSubview(textFieldStackView)
        mainStackView.addArrangedSubview(descriptionTextView)
        
        itemImageScrollView.addSubview(imageStackView)
        
        imageStackView.addArrangedSubview(addImageButton)
        
        textFieldStackView.addArrangedSubview(itemNameTextField)
        textFieldStackView.addArrangedSubview(currencyStackView)
        textFieldStackView.addArrangedSubview(itemSaleTextField)
        textFieldStackView.addArrangedSubview(itemStockTextField)
        
        currencyStackView.addArrangedSubview(itemPriceTextField)
        currencyStackView.addArrangedSubview(currencySegmentControl)
    }
    
    private func configureLayoutContraints() {
        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            mainScrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: mainScrollView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: mainScrollView.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: mainScrollView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: mainScrollView.trailingAnchor),
            mainStackView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: itemImageScrollView.topAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: itemImageScrollView.bottomAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: itemImageScrollView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: itemImageScrollView.trailingAnchor),
            imageStackView.heightAnchor.constraint(equalTo: itemImageScrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            itemImageScrollView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
        ])
        
        NSLayoutConstraint.activate([
            addImageButton.heightAnchor.constraint(equalTo: addImageButton.widthAnchor)
        ])
    }
}

// MARK: - Setter Functions

extension ProductRegistView {
    func configureDelegate(viewController: UITextFieldDelegate & UITextViewDelegate) {
        itemNameTextField.delegate = viewController
        itemPriceTextField.delegate = viewController
        itemSaleTextField.delegate = viewController
        itemStockTextField.delegate = viewController
        
        mainScrollView.keyboardDismissMode = .interactive
        
        descriptionTextView.delegate = viewController
    }
    
    func addToScrollView(of image: UIImage, viewController: ProductsRegistViewController) {
        let newImageView = UIImageView(image: image)
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        newImageView.widthAnchor.constraint(equalTo: newImageView.heightAnchor).isActive = true
        newImageView.isUserInteractionEnabled = true
        
        imageStackView.insertArrangedSubview(newImageView, at: imageStackView.arrangedSubviews.count - 1)
    }
    
    private func makeimageView(url: String) {
        guard let url = URL(string: url),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return }
        let imageView = UIImageView(image: image)
        imageStackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    }
    
    func setProductInfomation(productInfo: Page?) {
        self.productInfo = productInfo
        
        guard let productInfo = productInfo else { return }
        
        imageStackView.arrangedSubviews.last?.removeFromSuperview()
        productInfo.images?.forEach { makeimageView(url: $0.url) }
        itemNameTextField.text = productInfo.name
        itemPriceTextField.text = String(Int(productInfo.price))
        itemSaleTextField.text = String(Int(productInfo.discountedPrice))
        itemStockTextField.text = String(productInfo.stock)
        
        descriptionTextView.text = productInfo.description
        descriptionTextViewPlaceHolder.isHidden = !descriptionTextView.text.isEmpty
        
        guard let segmentIndex = Currency(rawValue: productInfo.currency)?.toIndex() else { return }
        currencySegmentControl.selectedSegmentIndex = segmentIndex
    }
    
    func addTargetToImageButton(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        addImageButton.addTarget(target, action: action, for: controlEvents)
    }
}
