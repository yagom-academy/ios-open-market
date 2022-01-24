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
        return stackView
    }()
    
    let productImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
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
        return label
    }()
    
    let productPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .trailing
        return stackView
    }()
    
    let productDiscountedPriceLabel = UILabel()
    let productPriceLabel = UILabel()
    
    let productDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    private func configProductNameAndStockStackView() {
        [productNameLabel, productStockLabel].forEach { label in
            productNameAndStockStackView.addArrangedSubview(label)
        }
    }
    
    private func configProductPriceStackView() {
        [productDiscountedPriceLabel, productPriceLabel].forEach { label in
            productPriceStackView.addArrangedSubview(label)
        }
    }
    
    func configUI() {
        configProductNameAndStockStackView()
        configProductPriceStackView()
        
        [productImageScrollView, productImagePageLabel, productNameAndStockStackView, productPriceStackView, productDescriptionTextView].forEach { view in
            productDetailStackView.addArrangedSubview(view)
        }
        
        productDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productDetailStackView.topAnchor.constraint(equalTo: self.topAnchor),
            productDetailStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            productDetailStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            productDetailStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            productDetailStackView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
}
