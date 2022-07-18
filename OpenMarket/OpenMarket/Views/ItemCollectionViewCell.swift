import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var product: Page? {
        didSet {
            guard let product = product else { return }

            itemNameLabel.text = product.name
            itemPriceLabel.text = String(product.price)
            itemStockLabel.text = String(product.stock)
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

        NSLayoutConstraint.activate([
            self.itemImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3),
            self.itemImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 1.0)
        ])
        
//        NSLayoutConstraint.activate([
//            itemNameAndPriceStackView.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor),
//            itemNameAndPriceStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
//            itemNameAndPriceStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
//            itemNameAndPriceStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
        
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
            }
            NSLayoutConstraint.activate([
                self.itemImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3),
                self.itemImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor)
            ])
        case .GRID:
            UIView.animate(withDuration: 0.3) {
                self.stackView.axis = .vertical
            }
            NSLayoutConstraint.activate([
                self.itemImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8),
                self.itemImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.4)
            ])
        }
    }
    
    override func prepareForReuse() {
        itemStockLabel.textColor = .systemGray
    }
}
