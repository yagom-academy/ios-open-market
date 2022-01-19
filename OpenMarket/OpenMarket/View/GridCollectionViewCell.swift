import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    let contentStackView = UIStackView()
    let productImageView = UIImageView()
    let labelStackView = UIStackView()
    let priceStackView = UIStackView()
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
        setUpPriceStackView()
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
        labelStackView.addArrangedSubview(priceStackView)
        labelStackView.addArrangedSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            labelStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    func setUpPriceStackView() {
        priceStackView.axis = .vertical
        priceStackView.alignment = .center
        priceStackView.distribution = .fillEqually
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(discountedPriceLabel)
    }
    
    func setUpLabelText(with data: ProductInformation) {
        setUpImage(url: data.thumbnail)
        productNameLabel.text = data.name
        productNameLabel.font = .preferredFont(forTextStyle: .headline)
        setUpStockLabel(with: data.stock)
        setUpPriceLabel(price: data.price, discountedPrice: data.discountedPrice, currency: data.currency)
    }
    
    func setUpImage(url: String) {
        guard let imageUrl = URL(string: url),
              let data = try? Data(contentsOf: imageUrl) else {
                  return
              }
        
        productImageView.image = UIImage(data: data)
    }
    
    func setUpStockLabel(with stock: Int) {
        if stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        } else {
            stockLabel.text = "잔여수량 : \(stock)"
            stockLabel.textColor = .systemGray
        }
    }
    
    func setUpPriceLabel(price: Double, discountedPrice: Double, currency: String) {
        if discountedPrice == 0 {
            priceLabel.text = "\(currency) \(price.formattedPrice())"
            priceLabel.textColor = .systemGray
        } else {
            priceLabel.text = "\(currency) \(price.formattedPrice())"
            priceLabel.textColor = .red
            priceLabel.attributedText = priceLabel.text?.strikeThrough()
            discountedPriceLabel.text = "\(currency) \(discountedPrice.formattedPrice())"
            discountedPriceLabel.textColor = .systemGray
        }
    }
}
