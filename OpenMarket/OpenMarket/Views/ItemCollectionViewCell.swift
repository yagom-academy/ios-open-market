import UIKit

class ItemCollectionViewCell: UICollectionViewListCell {
    
    // MARK: - Properties
    
    private var itemImageViewLayoutConstraint: NSLayoutConstraint?
    private var multiplieToConstant: CGFloat?
    private var stackViewTraillingContraint: NSLayoutConstraint?
    
    private var product: Page? {
        didSet {
            guard let product = product else { return }
            
            itemNameLabel.text = product.name
            
            if product.discountedPrice == product.price || product.discountedPrice == 0 {
                itemPriceLabel.text = "\(product.currency) \(product.price)"
            } else {
                let salePrice = "\(product.currency) \(product.price)".strikeThrough()
                itemPriceLabel.attributedText = salePrice
                itemPriceLabel.textColor = .systemRed
                self.priceStackView.addArrangedSubview(itemSaleLabel)
                itemSaleLabel.text = "\(product.currency) \(product.price - product.discountedPrice)"
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
        label.textAlignment = .center
        return label
    }()
    
    private let itemSecondNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    private let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = ""
        label.textColor = .systemGray
        return label
    }()
    
    private let itemSaleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = ""
        label.textColor = .systemGray
        return label
    }()
    
    private let itemNameAndPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let itemStockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
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
        
        priceStackView.addArrangedSubview(itemPriceLabel)
        
        itemNameAndPriceStackView.addArrangedSubview(itemNameLabel)
        itemNameAndPriceStackView.addArrangedSubview(priceStackView)
        
        productStackView.addArrangedSubview(itemImageView)
        productStackView.addArrangedSubview(itemNameAndPriceStackView)
        productStackView.addArrangedSubview(itemStockLabel)
    }
    
    private func configureLayoutContraints() {
        itemImageView.widthAnchor.constraint(equalTo: self.itemImageView.heightAnchor).isActive = true
        
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
        
        self.productStackView.spacing = 10
        self.productStackView.axis = .horizontal
        self.stackViewTraillingContraint?.constant = -8
        self.productStackView.isLayoutMarginsRelativeArrangement = false
        
        self.priceStackView.axis = .horizontal
        self.itemNameAndPriceStackView.alignment = .leading
        
        self.itemImageViewLayoutConstraint?.isActive = false
        self.accessories = [ .disclosureIndicator() ]
    }
    
    private func gridLayout() {
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.systemGray3.cgColor
        
        self.productStackView.spacing = 0
        self.productStackView.axis = .vertical
        self.stackViewTraillingContraint?.constant = 0
        self.productStackView.isLayoutMarginsRelativeArrangement = true
        
        self.priceStackView.axis = .vertical
        self.itemNameAndPriceStackView.alignment = .fill
        
        self.itemImageViewLayoutConstraint?.isActive = true
        self.accessories = [ .delete() ]
    }
    
    func returnNameLabelText() -> String {
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
}

// MARK: - prepare For Reuse

extension ItemCollectionViewCell {
    override func prepareForReuse() {
        itemImageView.image = nil
        itemSaleLabel.textColor = .systemGray
        itemStockLabel.textColor = .systemGray
    }
}
