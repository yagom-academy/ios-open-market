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
        return label
    }()
    
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
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
        itemNameAndPriceStackView.addArrangedSubview(priceStackView)
        priceStackView.addArrangedSubview(itemPriceLabel)
        
        stackView.addArrangedSubview(itemImageView)
        stackView.addArrangedSubview(itemNameAndPriceStackView)
        stackView.addArrangedSubview(itemStockLabel)
        
        itemImageView.widthAnchor.constraint(equalTo: self.itemImageView.heightAnchor).isActive = true
        
        //        multiplieToConstant = contentView.frame.width * 0.7
        
        //        itemImageViewLayoutConstraint = itemImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        //        itemImageViewLayoutConstraint?.constant = -(multiplieToConstant ?? 0.0)
        //        itemImageViewLayoutConstraint?.isActive = true
        
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
            
                self.stackView.axis = .horizontal
                self.accessories = [
                    .disclosureIndicator()
                ]
                self.priceStackView.axis = .horizontal
                //                self.itemImageViewLayoutConstraint?.constant = -(self.multiplieToConstant ?? 0.0)
                self.itemNameAndPriceStackView.alignment = .leading
                self.layer.borderWidth = 0
                self.layer.borderColor = nil
                self.layoutIfNeeded()
            
        case .GRID:
                self.stackView.axis = .vertical
                self.accessories = [
                    .delete()
                ]
                self.priceStackView.axis = .vertical
                //                self.itemImageViewLayoutConstraint?.constant = 0
                self.itemNameAndPriceStackView.alignment = .center
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.systemGray.cgColor
                self.layer.cornerRadius = 20
                self.clipsToBounds = true
                self.layoutIfNeeded()
            
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
