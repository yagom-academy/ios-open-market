import UIKit

private enum Placeholder {
    static let name = "상품명"
    static let price = "상품가격"
    static let discountedPrice = "할인금액"
    static let stock = "재고수량"
}

private enum Design {
    static let buttonEdgeInsetMargin: CGFloat = 50
    static let textFieldStackViewTopMargin: CGFloat = 10
    static let textFieldStackViewLeadingMargin: CGFloat = 15
    static let textFieldStackViewTrailingMargin: CGFloat = -15
    static let descriptionTextViewTopMargin: CGFloat = 10
    static let imageScrollViewLeadingMargin: CGFloat = 20
    static let imageScrollViewTrailingMargin: CGFloat = -20
    static let imageScrollViewHeight: CGFloat = 150
}

class ProductInformationView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let imageScrollView = UIScrollView()
    private let imageContentView = UIView()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private let addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.contentEdgeInsets = UIEdgeInsets(top: Design.buttonEdgeInsetMargin, left: Design.buttonEdgeInsetMargin, bottom: Design.buttonEdgeInsetMargin, right: Design.buttonEdgeInsetMargin)
        return button
    }()

    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let nameTextField = CustomTextField(placeholder: Placeholder.name)
    private let priceTextField = CustomTextField(placeholder: Placeholder.price)
    private let discountedPriceTextField = CustomTextField(placeholder: Placeholder.discountedPrice)
    private let stockTextField = CustomTextField(placeholder: Placeholder.stock)
    
    private let currencySegmentedControl = LayoutSegmentedControl(items: Currency.allCases.map { $0.unit })
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 10
        textView.font = .preferredFont(forTextStyle: .footnote)
        return textView
    }()
    
    private func configUI() {
        configImageScrollView()
    
        [textFieldStackView, descriptionTextView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        [priceTextField, currencySegmentedControl].forEach { view in
            priceStackView.addArrangedSubview(view)
        }
        
        [nameTextField, priceStackView, discountedPriceTextField, stockTextField].forEach { view in
            textFieldStackView.addArrangedSubview(view)
        }
        
        NSLayoutConstraint.activate([
            textFieldStackView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: Design.textFieldStackViewTopMargin),
            textFieldStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Design.textFieldStackViewLeadingMargin),
            textFieldStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Design.textFieldStackViewTrailingMargin),
            
            descriptionTextView.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: Design.descriptionTextViewTopMargin),
            descriptionTextView.leadingAnchor.constraint(equalTo: textFieldStackView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: textFieldStackView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configImageScrollView() {
        imageStackView.addArrangedSubview(addImageButton)
        imageContentView.addSubview(imageStackView)
        imageScrollView.addSubview(imageContentView)
        self.addSubview(imageScrollView)
        
        [imageScrollView, imageContentView, imageStackView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Design.imageScrollViewLeadingMargin),
            imageScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Design.imageScrollViewTrailingMargin),
            imageScrollView.heightAnchor.constraint(equalToConstant: Design.imageScrollViewHeight),
            
            imageContentView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageContentView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            imageContentView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor),
            imageContentView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            imageContentView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor),
                        
            imageStackView.topAnchor.constraint(equalTo: imageContentView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageContentView.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: imageContentView.trailingAnchor),
            imageStackView.bottomAnchor.constraint(equalTo: imageContentView.bottomAnchor)
        ])
    }
    
    func addImageToImageStackView(from image: UIImage) {
        let image = UIImageView(image: image)
        image.contentMode = .scaleAspectFit
        imageStackView.addArrangedSubview(image)
    }
}
