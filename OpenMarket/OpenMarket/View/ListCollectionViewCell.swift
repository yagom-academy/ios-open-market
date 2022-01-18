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
        setUpLabelStackView()
        setUpProductImageView()
        setUpNameStackView()
        setUpPriceStackView()
    }
    
    func addSubviews() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(productImageView)
        contentStackView.addArrangedSubview(labelStackView)
        labelStackView.addArrangedSubview(nameStackView)
        labelStackView.addArrangedSubview(priceStackView)
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
    
    func setUpLabelStackView() {
        labelStackView.axis = .vertical
        labelStackView.alignment = .center
        labelStackView.distribution = .fill
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: contentStackView.topAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor)
        ])
    }
    
    func setUpProductImageView() {
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor)
        ])
    }
    
    func setUpNameStackView() {
        nameStackView.axis = .horizontal
        nameStackView.alignment = .center
        nameStackView.distribution = .fill
        
        nameStackView.addArrangedSubview(productNameLabel)
        nameStackView.addArrangedSubview(stockLabel)
    }
    
    func setUpPriceStackView() {
        priceStackView.axis = .horizontal
        priceStackView.alignment = .center
        priceStackView.distribution = .fill
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(discountedPriceLabel)
    }
}
