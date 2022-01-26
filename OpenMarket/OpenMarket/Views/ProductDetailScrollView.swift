import UIKit

class ProductDetailScrollView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let productDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return stackView
    }()
    
    let productImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        return scrollView
    }()
    
    let productImagePageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    let productNameAndStockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
        
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()
    
    let productStockLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    let productPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .trailing
        return stackView
    }()
    
    let productBargainPriceLabel = UILabel()
    let productPriceLabel = UILabel()
    
    let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.font = .preferredFont(forTextStyle: .subheadline)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    private func configProductNameAndStockStackView() {
        [productNameLabel, productStockLabel].forEach { label in
            productNameAndStockStackView.addArrangedSubview(label)
        }
        productStockLabel.setContentHuggingPriority(.required, for: .horizontal)
        productStockLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func configProductPriceStackView() {
        [productPriceLabel, productBargainPriceLabel].forEach { label in
            productPriceStackView.addArrangedSubview(label)
        }
    }
    
    private func configUI() {
        configProductNameAndStockStackView()
        configProductPriceStackView()
        [productImagePageLabel, productNameAndStockStackView, productPriceStackView, productDescriptionTextView].forEach { view in
            productDetailStackView.addArrangedSubview(view)
        }
        
        self.addSubview(productImageScrollView)
        self.addSubview(productDetailStackView)
        productImageScrollView.translatesAutoresizingMaskIntoConstraints = false
        productDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            productImageScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            productImageScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            productImageScrollView.heightAnchor.constraint(equalToConstant: 300),
            
            productDetailStackView.topAnchor.constraint(equalTo: productImageScrollView.bottomAnchor),
            productDetailStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            productDetailStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            productDetailStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            productDetailStackView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}
