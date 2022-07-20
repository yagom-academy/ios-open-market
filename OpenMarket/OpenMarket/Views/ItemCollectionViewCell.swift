import UIKit

class ItemCollectionViewCell: UICollectionViewListCell {
    
    // MARK: - Properties
    
    var itemImageViewLayoutConstraint: NSLayoutConstraint?
    var multiplieToConstant: CGFloat?
    var stackViewTraillingContraint: NSLayoutConstraint?
    
    var product: Page? {
        didSet {
            guard let product = product else { return }
            
            itemNameLabel.text = product.name
            
            if product.discountedPrice == product.price {
                itemPriceLabel.text = "\(product.currency) \(product.price)"
            } else {
                let salePrice = "\(product.currency) \(product.price)".strikeThrough()
                itemPriceLabel.attributedText = salePrice
                itemPriceLabel.textColor = .systemRed
                self.priceStackView.addArrangedSubview(itemSaleLabel)
                itemSaleLabel.text = "\(product.currency) \(product.discountedPrice)"
            }
            
            if product.stock == 0 {
                itemStockLabel.text = "품절"
                itemStockLabel.textColor = .systemYellow
            } else {
                itemStockLabel.text = "잔여수량 : \(product.stock)"
            }
        }
    }
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let itemNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    let itemSecondNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = ""
        label.textAlignment = .center
        return label
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = ""
        label.textColor = .systemGray
        return label
    }()
    
    let itemSaleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = ""
        label.textColor = .systemGray
        return label
    }()
    
    let itemNameAndPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let itemStockLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.text = ""
        label.textColor = .systemGray
        label.textAlignment = .right
        return label
    }()
    
    let stackView: UIStackView = {
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
    
    let separator: UIView = {
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


// MARK: - Functions

extension ItemCollectionViewCell {
    
    private func addViews() {
        addSubview(stackView)
        addSubview(separator)
        
        priceStackView.addArrangedSubview(itemPriceLabel)
        
        itemNameAndPriceStackView.addArrangedSubview(itemNameLabel)
        itemNameAndPriceStackView.addArrangedSubview(priceStackView)
        
        stackView.addArrangedSubview(itemImageView)
        stackView.addArrangedSubview(itemNameAndPriceStackView)
        stackView.addArrangedSubview(itemStockLabel)
    }
    
    private func configureLayoutContraints() {
        itemImageView.widthAnchor.constraint(equalTo: self.itemImageView.heightAnchor).isActive = true
        
        stackViewTraillingContraint = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        stackViewTraillingContraint?.isActive = true
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 1),
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    private func listLayout() {
        self.clipsToBounds = false
        self.layer.cornerRadius = 0
        self.layer.borderWidth = 0
        self.layer.borderColor = nil
        
        self.stackView.spacing = 10
        self.stackView.axis = .horizontal
        self.stackViewTraillingContraint?.constant = -8
        self.stackView.isLayoutMarginsRelativeArrangement = false
        
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
        
        self.stackView.spacing = 0
        self.stackView.axis = .vertical
        self.stackViewTraillingContraint?.constant = 0
        self.stackView.isLayoutMarginsRelativeArrangement = true
        
        self.priceStackView.axis = .vertical
        self.itemNameAndPriceStackView.alignment = .fill
        
        self.itemImageViewLayoutConstraint?.isActive = true
        self.accessories = [ .delete() ]
    }
}

extension ItemCollectionViewCell {
    func setAxis(segment: Titles) {
        UIView.animate(withDuration: 0.3) {
            switch segment {
            case .LIST:
                self.listLayout()
            case .GRID:
                self.gridLayout()
            }
        }
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
