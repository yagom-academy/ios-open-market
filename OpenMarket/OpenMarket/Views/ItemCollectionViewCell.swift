import UIKit

class ItemCollectionViewCell: UICollectionViewListCell {
    
    // MARK: - Properties
    
    var currentSeguement: Titles?
    var itemImageViewLayoutConstraint: NSLayoutConstraint?
    var multiplieToConstant: CGFloat?
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
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    let itemSaleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemGray
        label.numberOfLines = 0
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        stackView.isLayoutMarginsRelativeArrangement = false
        return stackView
    }()
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ItemCollectionViewCell {
    private func configureLayout() {
        addSubview(stackView)
        
        itemNameAndPriceStackView.addArrangedSubview(itemNameLabel)
        priceStackView.addArrangedSubview(itemPriceLabel)
        itemNameAndPriceStackView.addArrangedSubview(priceStackView)
        
        stackView.addArrangedSubview(itemImageView)
        stackView.addArrangedSubview(itemNameAndPriceStackView)
        stackView.addArrangedSubview(itemStockLabel)
        
        itemImageView.widthAnchor.constraint(equalTo: self.itemImageView.heightAnchor).isActive = true
        
        self.accessories = [
            .disclosureIndicator()
        ]
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setAxis(segment: Titles) {
        switch segment {
        case .LIST:
            UIView.animate(withDuration: 0.5) {
                self.stackView.axis = .horizontal
                self.accessories = [
                    .disclosureIndicator()
                ]
                self.priceStackView.axis = .horizontal
                self.itemNameAndPriceStackView.alignment = .leading
                self.layer.borderWidth = 0
                self.layer.borderColor = nil
                self.layer.cornerRadius = 0
                self.clipsToBounds = false
                self.stackView.isLayoutMarginsRelativeArrangement = false
                self.layoutIfNeeded()
            }
        case .GRID:
            UIView.animate(withDuration: 0.5) {
                self.stackView.axis = .vertical
                self.accessories = [
                    .delete()
                ]
                self.priceStackView.axis = .vertical
                self.itemNameAndPriceStackView.alignment = .fill
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.systemGray.cgColor
                self.layer.cornerRadius = 20
                self.clipsToBounds = true
                self.stackView.isLayoutMarginsRelativeArrangement = true
                self.layoutIfNeeded()
            }
        }
    }
    
    override func prepareForReuse() {
        itemStockLabel.textColor = .systemGray
        itemSaleLabel.textColor = .systemGray
    }
}
extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
