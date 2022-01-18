import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    let contentStackView = UIStackView()
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
    }
    
    func addSubviews() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(productImageView)
    }
    
    func setUpContentStackView() {
        contentStackView.axis = .horizontal
        contentStackView.alignment = .top
        contentStackView.distribution = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func setUpProductImageView() {
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor)
        ])
    }
}
