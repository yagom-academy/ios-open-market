import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var product: Page? {
        didSet {
            guard let product = product else { return }

//            itemImageView.image = image
            itemNameLabel.text = product.name
            itemPriceLabel.text = String(product.price)
            itemStockLabel.text = String(product.stock)
        }
    }
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "tshirt.fill")
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
        
        itemNameAndPriceStackView.addArrangedSubview(itemNameLabel)
        itemNameAndPriceStackView.addArrangedSubview(itemPriceLabel)
        
        addSubview(itemImageView)
        addSubview(itemNameAndPriceStackView)
        addSubview(itemStockLabel)
        
        NSLayoutConstraint.activate([
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            itemImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            itemNameAndPriceStackView.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor),
            itemNameAndPriceStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            itemNameAndPriceStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            itemNameAndPriceStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            itemStockLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemStockLabel.leadingAnchor.constraint(equalTo: itemNameAndPriceStackView.trailingAnchor),
            itemStockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemStockLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
