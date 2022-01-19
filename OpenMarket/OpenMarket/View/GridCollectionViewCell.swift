import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    let contentStackView = UIStackView()
    let productImageView = UIImageView()
    let labelStackView = UIStackView()
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImageView.image = nil
        productNameLabel.text = nil
        stockLabel.text = nil
        priceLabel.text = nil
        discountedPriceLabel.text = nil
    }
    
    func configUI() {
        addSubviews()
        setUpContentStackView()
        setUpProductImageView()
        setUpLabelStackView()
    }
    
    func addSubviews() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(productImageView)
        contentStackView.addArrangedSubview(labelStackView)
    }
    
    func setUpProductImageView() {
        productImageView.contentMode = .scaleAspectFit
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentStackView.topAnchor),
            productImageView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.8),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor)
        ])
        
    }
    
    func setUpContentStackView() {
        contentStackView.axis = .vertical
        contentStackView.alignment = .center
        contentStackView.distribution = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            contentStackView.heightAnchor.constraint(equalToConstant: contentView.bounds.height),
            contentStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setUpLabelStackView() {
        labelStackView.axis = .vertical
        labelStackView.alignment = .center
        labelStackView.distribution = .fillEqually
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        labelStackView.addArrangedSubview(productNameLabel)
        labelStackView.addArrangedSubview(priceLabel)
        labelStackView.addArrangedSubview(discountedPriceLabel)
        labelStackView.addArrangedSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            labelStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
