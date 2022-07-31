import UIKit

class ProductDetailView: UIView {

    // MARK: - Properties
    
    let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let itemImageScrollView: UIScrollView = {
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
    
    let currencyStackView: UIStackView = {
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
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray3.cgColor
        textField.backgroundColor = .systemBackground
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        return textField
    }()
    
    let rightBarPlusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemGray3
        return button
    }()
    
    let textFieldStackView: UIStackView = {
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
        textView.text = "테스트"
        return textView
    }()
    
    let mainStackView: UIStackView = {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addToScrollView(of image: UIImage, viewController: ProductsDetailViewController) {
        let newImageView = UIImageView(image: image)
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        newImageView.widthAnchor.constraint(equalTo: newImageView.heightAnchor).isActive = true
        newImageView.isUserInteractionEnabled = true
        
        imageStackView.insertArrangedSubview(newImageView, at: imageStackView.arrangedSubviews.count - 1)
    }
    
    func configureDelegate(viewController: UITextFieldDelegate & UITextViewDelegate) {
        itemNameTextField.delegate = viewController
        itemPriceTextField.delegate = viewController
        itemSaleTextField.delegate = viewController
        itemStockTextField.delegate = viewController
        
        mainScrollView.keyboardDismissMode = .interactive
        
        descriptionTextView.delegate = viewController
    }
}

// MARK: - UIView Functions

extension ProductDetailView {
    private func addViews() {
        addSubview(mainScrollView)
        
        mainScrollView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(itemImageScrollView)
        mainStackView.addArrangedSubview(textFieldStackView)
        mainStackView.addArrangedSubview(descriptionTextView)
        
        itemImageScrollView.addSubview(imageStackView)
        
        imageStackView.addArrangedSubview(rightBarPlusButton)
        
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
            rightBarPlusButton.heightAnchor.constraint(equalTo: rightBarPlusButton.widthAnchor)
        ])
    }
}
