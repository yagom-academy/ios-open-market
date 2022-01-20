import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    private let contentStackView = UIStackView()
    private let productImageView = UIImageView()
    private let labelStackView = UIStackView()
    private let priceStackView = UIStackView()
    private let productNameLabel = UILabel()
    private let priceLabel = UILabel()
    private let discountedPriceLabel = UILabel()
    private let stockLabel = UILabel()
    
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
    
    func configCell(with data: ProductInformation) {
        setUpImage(url: data.thumbnail)
        productNameLabel.text = data.name
        productNameLabel.font = .preferredFont(forTextStyle: .headline)
        setUpStockLabel(with: data.stock)
        setUpPriceLabel(price: data.price, discountedPrice: data.discountedPrice, currency: data.currency)
    }
    
    private func configUI() {
        addSubviews()
        setUpContentStackView()
        setUpProductImageView()
        setUpLabelStackView()
        setUpPriceStackView()
        addBorder()
    }
    
    private func addSubviews() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(productImageView)
        contentStackView.addArrangedSubview(labelStackView)
    }
    
    private func setUpContentStackView() {
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
    
    private func setUpProductImageView() {
        productImageView.contentMode = .scaleAspectFit
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentStackView.topAnchor, constant: 10),
            productImageView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 0.8),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor)
        ])
        
    }
    
    private func setUpLabelStackView() {
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
    
    private func setUpPriceStackView() {
        priceStackView.axis = .vertical
        priceStackView.alignment = .center
        priceStackView.distribution = .fillEqually
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(discountedPriceLabel)
    }
    
    private func setUpImage(url: String) {
        guard let imageUrl = URL(string: url),
              let data = try? Data(contentsOf: imageUrl) else {
                  return
              }
        
        productImageView.image = UIImage(data: data)
    }
    
    private func setUpStockLabel(with stock: Int) {
        if stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        } else {
            stockLabel.text = "잔여수량 : \(stock)"
            stockLabel.textColor = .systemGray
        }
    }
    
    private func setUpPriceLabel(price: Double, discountedPrice: Double, currency: String) {
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
    
    private func addBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = 10
    }
}
