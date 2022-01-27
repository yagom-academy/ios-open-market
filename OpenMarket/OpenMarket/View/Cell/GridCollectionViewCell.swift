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
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImageView.image = nil
        productNameLabel.text = nil
        stockLabel.text = nil
        priceLabel.attributedText = nil
        priceLabel.text = nil
        discountedPriceLabel.text = nil
    }
    
    func configureCell(with data: ProductInformation) {
        setUpImage(url: data.thumbnail)
        productNameLabel.text = data.name
        productNameLabel.font = .preferredFont(forTextStyle: .headline)
        setUpStockLabel(with: data.stock)
        setUpPriceLabel(price: data.price, discountedPrice: data.discountedPrice, currency: data.currency)
    }
    
    private func configureUI() {
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
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: url) else {
                return
            }
            
            self.loadImage(url: imageUrl) { image in
                DispatchQueue.main.async {
                    self.productImageView.image = image
                }
            }
        }
    }
    
    private func loadImage(url: URL, completionHandler: @escaping (UIImage) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                return
            }
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            completionHandler(image)
        }
        task.resume()
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
            priceLabel.text = "\(currency) \(price.formattedNumber())"
            priceLabel.textColor = .systemGray
        } else {
            priceLabel.text = "\(currency) \(price.formattedNumber())"
            priceLabel.textColor = .red
            priceLabel.attributedText = priceLabel.text?.strikeThrough()
            discountedPriceLabel.text = "\(currency) \(discountedPrice.formattedNumber())"
            discountedPriceLabel.textColor = .systemGray
        }
    }
    
    private func addBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray.cgColor
        layer.cornerRadius = 10
    }
}
