import UIKit

class ItemCollectionViewCell: UICollectionViewListCell {
    
    // MARK: - Properties
    var itemImageViewLayoutConstraint: NSLayoutConstraint?
    var multiplieToConstant: CGFloat?
    var product: Page? {
        didSet {
            guard let product = product else { return }

            itemNameLabel.text = product.name
            
            itemPriceLabel.text = "\(product.currency) \(product.price)"
            
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
        return label
    }()
    
    let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemGray
        return label
    }()
    
    let itemSaleLabel: UILabel = {
        let label = UILabel()
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor = .systemGray
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
        itemNameAndPriceStackView.addArrangedSubview(itemPriceLabel)
        
        stackView.addArrangedSubview(itemImageView)
        stackView.addArrangedSubview(itemNameAndPriceStackView)
        stackView.addArrangedSubview(itemStockLabel)
        
        multiplieToConstant = contentView.frame.width * 0.7
        
        itemImageViewLayoutConstraint = itemImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        itemImageViewLayoutConstraint?.constant = -(multiplieToConstant ?? 0.0)
        itemImageViewLayoutConstraint?.isActive = true

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
            UIView.animate(withDuration: 0.3) {
                self.stackView.axis = .horizontal
                self.accessories = [
                    .disclosureIndicator()
                ]
                self.itemImageViewLayoutConstraint?.constant = -(self.multiplieToConstant ?? 0.0)
                self.itemNameAndPriceStackView.alignment = .leading
                self.layer.borderWidth = 0
                self.layer.borderColor = nil
                self.layoutIfNeeded()
            }
        case .GRID:
            UIView.animate(withDuration: 0.3) {
                self.stackView.axis = .vertical
                self.accessories = [
                    .delete()
                ]
                self.itemImageViewLayoutConstraint?.constant = 0
                self.itemNameAndPriceStackView.alignment = .center
                self.layer.borderWidth = 1
                self.layer.borderColor = UIColor.systemGray.cgColor
                self.layoutIfNeeded()
            }
        }
    }
    
    override func prepareForReuse() {
        itemStockLabel.textColor = .systemGray
    }
}
