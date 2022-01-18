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
        contentStackView.alignment = .top
        contentStackView.distribution = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentStackView.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setUpLabelStackView() {
        labelStackView.axis = .vertical
        labelStackView.alignment = .center
        labelStackView.distribution = .fillEqually
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: contentStackView.topAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor),
            labelStackView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func setUpProductImageView() {
        productImageView.contentMode = .scaleAspectFit
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
            productImageView.widthAnchor.constraint(equalTo: contentStackView.heightAnchor, multiplier: 0.8),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            productImageView.centerYAnchor.constraint(equalTo: contentStackView.centerYAnchor)
        ])
    }
    
    func setUpNameStackView() {
        nameStackView.axis = .horizontal
        nameStackView.alignment = .center
        nameStackView.distribution = .fill
        
        nameStackView.addArrangedSubview(productNameLabel)
        nameStackView.addArrangedSubview(stockLabel)
        
        productNameLabel.widthAnchor.constraint(equalTo: nameStackView.widthAnchor, multiplier: 0.75).isActive = true
    }
    
    func setUpPriceStackView() {
        priceStackView.axis = .horizontal
        priceStackView.alignment = .center
        priceStackView.distribution = .fillEqually
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(discountedPriceLabel)
    }
    
    func setUpAccessoryImageView() {
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            accessoryImageView.widthAnchor.constraint(equalTo: stockLabel.heightAnchor),
            accessoryImageView.heightAnchor.constraint(equalTo: accessoryImageView.widthAnchor)
        ])
        
        accessoryImageView.image = UIImage(systemName: "chevron.right")
        accessoryImageView.tintColor = .systemGray4
    }
}
