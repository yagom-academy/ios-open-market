import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    let contentStackView = UIStackView()
    let labelStackView = UIStackView()
    let nameStackView = UIStackView()
    let priceStackView = UIStackView()
    let productImageView = UIImageView()
    let accessoryImageView = UIImageView()
    let productNameLabel = UILabel()
    let priceLabel = UILabel()
    let discountedPriceLabel = UILabel()
    let stockLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        addSubviews()
        setUpContentStackView()
        setUpProductImageView()
        setUpNameStackView()
        setUpPriceStackView()
        setUpLabelStackView()
        setUpAccessoryImageView()
    }
    
    func addSubviews() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(productImageView)
        contentStackView.addArrangedSubview(labelStackView)
        labelStackView.addArrangedSubview(nameStackView)
        labelStackView.addArrangedSubview(priceStackView)
        contentStackView.addArrangedSubview(accessoryImageView)
    }
    
    func setUpContentStackView() {
        contentStackView.axis = .horizontal
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentStackView.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            contentStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            contentStackView.heightAnchor.constraint(equalToConstant: contentView.bounds.height),
            contentStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setUpLabelStackView() {
        labelStackView.axis = .vertical
        labelStackView.alignment = .fill
        labelStackView.distribution = .fillEqually
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setUpProductImageView() {
        productImageView.contentMode = .scaleAspectFit
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalTo: contentStackView.heightAnchor, multiplier: 0.8),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            productImageView.centerYAnchor.constraint(equalTo: contentStackView.centerYAnchor)
        ])
    }
    
    func setUpNameStackView() {
        nameStackView.axis = .horizontal
        nameStackView.alignment = .center
        nameStackView.distribution = .fill
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        stockLabel.textAlignment = .right
        
        nameStackView.addArrangedSubview(productNameLabel)
        productNameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameStackView.addArrangedSubview(stockLabel)
        nameStackView.addArrangedSubview(accessoryImageView)
    }
    
    func setUpPriceStackView() {
        priceStackView.axis = .horizontal
        priceStackView.alignment = .fill
        priceStackView.distribution = .fill
        priceStackView.spacing = 8
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        priceStackView.addArrangedSubview(priceLabel)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priceStackView.addArrangedSubview(discountedPriceLabel)
    }
    
    func setUpAccessoryImageView() {
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        accessoryImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            accessoryImageView.heightAnchor.constraint(equalTo: stockLabel.heightAnchor),
            accessoryImageView.widthAnchor.constraint(equalTo: accessoryImageView.heightAnchor)
        ])
        
        accessoryImageView.image = UIImage(systemName: "chevron.right")
        accessoryImageView.tintColor = .systemGray4
    }
}
