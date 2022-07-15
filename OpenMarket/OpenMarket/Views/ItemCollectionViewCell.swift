import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "tshirt.fill")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let itemNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "아이폰 12 mini"
        return label
    }()
    
    let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "100,000원"
        return label
    }()
    
    let itemNameAndPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let itemStockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "127개 남음."
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
            itemNameAndPriceStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemNameAndPriceStackView.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor),
            itemNameAndPriceStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            itemNameAndPriceStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
        
        NSLayoutConstraint.activate([
            itemStockLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemStockLabel.leadingAnchor.constraint(equalTo: itemNameAndPriceStackView.trailingAnchor),
            itemStockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemStockLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
