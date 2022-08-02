import UIKit

class ItemCollectionViewCell: UICollectionViewListCell {
    
    // MARK: - Properties
    
    private var itemImageViewLayoutConstraint: NSLayoutConstraint?
    private var stackViewTraillingContraint: NSLayoutConstraint?
    
    private let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    private var product: Page? {
        didSet {
            guard let product = product,
                  let formattedPriceString = numberFormatter.string(for: product.price),
                  let formattedSaleString = numberFormatter.string(for: product.price - product.discountedPrice) else { return }
            
            itemNameLabel.text = product.name
            
            if product.discountedPrice <= 0 {
                itemPriceLabel.text = "\(product.currency) \(formattedPriceString)"
            } else {
                let salePrice = "\(product.currency) \(formattedPriceString)".strikeThrough()
                itemPriceLabel.attributedText = salePrice
                itemPriceLabel.textColor = .systemRed
                priceStackView.addArrangedSubview(itemSaleLabel)
                itemSaleLabel.text = "\(product.currency) \(formattedSaleString)"
            }
            
            if product.stock == 0 {
                itemStockLabel.text = "품절"
                itemStockLabel.textColor = .systemYellow
            } else {
                itemStockLabel.text = "잔여수량 : \(product.stock)"
            }
        }
    }
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = ""
        label.textAlignment = .left
        return label
    }()
    
    private let itemNameAndStockStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.font = .preferredFont(forTextStyle: .body)
        label.text = ""
        label.textColor = .systemGray
        return label
    }()
    
    private let itemSaleLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.font = .preferredFont(forTextStyle: .body)
        label.text = ""
        label.textColor = .systemGray
        return label
    }()
    
    private let itemNameAndPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let itemStockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.text = ""
        label.textColor = .systemGray
        label.textAlignment = .right
        return label
    }()
    
    private let productStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 15, bottom: 12, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = false
        return stackView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        return view
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
        configureLayoutContraints()
        self.accessories = [ .disclosureIndicator() ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Cell Layout Method

extension ItemCollectionViewCell {
    private func addViews() {
        addSubview(productStackView)
        addSubview(separatorView)
        
        itemNameAndStockStackView.addArrangedSubview(itemNameLabel)
        itemNameAndStockStackView.addArrangedSubview(itemStockLabel)
        
        priceStackView.addArrangedSubview(itemPriceLabel)
        
        itemNameAndPriceStackView.addArrangedSubview(itemNameAndStockStackView)
        itemNameAndPriceStackView.addArrangedSubview(priceStackView)
        
        productStackView.addArrangedSubview(itemImageView)
        productStackView.addArrangedSubview(itemNameAndPriceStackView)
    }
    
    private func configureLayoutContraints() {
        itemImageView.widthAnchor.constraint(equalTo: self.itemImageView.heightAnchor).isActive = true
        itemImageViewLayoutConstraint = itemImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        
        stackViewTraillingContraint = productStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        stackViewTraillingContraint?.isActive = true
        
        NSLayoutConstraint.activate([
            productStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: productStackView.bottomAnchor, constant: 1),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func listLayout() {
        self.clipsToBounds = false
        self.layer.cornerRadius = 0
        self.layer.borderWidth = 0
        self.layer.borderColor = nil
        
        self.productStackView.removeArrangedSubview(itemStockLabel)
        self.itemNameAndStockStackView.addArrangedSubview(itemStockLabel)
        
        self.stackViewTraillingContraint?.constant = -8
        
        self.productStackView.spacing = 10
        self.productStackView.axis = .horizontal
        self.productStackView.isLayoutMarginsRelativeArrangement = false
        
        self.itemNameAndStockStackView.spacing = 8
        self.itemNameAndPriceStackView.spacing = 8
        self.itemNameAndPriceStackView.alignment = .fill
        
        self.priceStackView.spacing = 10
        self.priceStackView.axis = .horizontal
        self.priceStackView.alignment = .leading
        
        self.itemNameLabel.textAlignment = .left
        self.itemSaleLabel.textAlignment = .left
        self.itemPriceLabel.textAlignment = .left
        
        self.itemImageViewLayoutConstraint?.isActive = false
        self.accessories = [ .disclosureIndicator() ]
    }
    
    private func gridLayout() {
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.systemGray3.cgColor
        
        self.itemNameAndStockStackView.removeArrangedSubview(itemStockLabel)
        self.productStackView.addArrangedSubview(itemStockLabel)
        
        self.stackViewTraillingContraint?.constant = 0
        
        self.productStackView.spacing = 8
        self.productStackView.axis = .vertical
        self.productStackView.isLayoutMarginsRelativeArrangement = true
        
        self.itemNameAndStockStackView.spacing = 5
        self.itemNameAndPriceStackView.spacing = 5
        self.itemNameAndPriceStackView.alignment = .fill
        
        self.priceStackView.spacing = 4
        self.priceStackView.axis = .vertical
        self.priceStackView.alignment = .center
        
        self.itemNameLabel.textAlignment = .center
        self.itemSaleLabel.textAlignment = .center
        self.itemPriceLabel.textAlignment = .center
        
        self.itemImageViewLayoutConstraint?.isActive = true
        self.accessories = [ .delete() ]
    }
    
    private func getNameLabelText() -> String {
        guard let name = itemNameLabel.text else { return "" }
        return name
    }
}

// MARK: - Setter Method

extension ItemCollectionViewCell {
    func setAxis(segment: Titles) {
        UIView.animate(withDuration: 0.3) {
            switch segment {
            case .list:
                self.listLayout()
            case .grid:
                self.gridLayout()
            }
        }
    }
    
    func setProduct(by product: Page) {
        self.product = product
    }
    
    func setImage(by image: UIImage) {
        self.itemImageView.image = image
    }
    
    func setId() -> Int? {
        return product?.id
    }
}

// MARK: - prepare For Reuse

extension ItemCollectionViewCell {
    override func prepareForReuse() {
        itemImageView.image = nil
        itemNameLabel.text = ""
        itemPriceLabel.attributedText = nil
        itemPriceLabel.textColor = .systemGray
        itemSaleLabel.text = ""
        itemSaleLabel.textColor = .systemGray
        itemStockLabel.text = ""
        itemStockLabel.textColor = .systemGray
    }
}
