import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    private let contentStackView = UIStackView()
    private let labelStackView = UIStackView()
    private let nameStackView = UIStackView()
    private let priceStackView = UIStackView()
    private let productImageView = UIImageView()
    private let accessoryImageView = UIImageView()
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
        setUpNameStackView()
        setUpPriceStackView()
        setUpLabelStackView()
        setUpAccessoryImageView()
        addUnderLine()
    }
    
    private func addSubviews() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(productImageView)
        contentStackView.addArrangedSubview(labelStackView)
        labelStackView.addArrangedSubview(nameStackView)
        labelStackView.addArrangedSubview(priceStackView)
        contentStackView.addArrangedSubview(accessoryImageView)
    }
    
    private func setUpContentStackView() {
        contentStackView.axis = .horizontal
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        contentStackView.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            contentStackView.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            contentStackView.heightAnchor.constraint(equalToConstant: contentView.bounds.height),
            contentStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setUpLabelStackView() {
        labelStackView.axis = .vertical
        labelStackView.alignment = .fill
        labelStackView.distribution = .fillEqually
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setUpProductImageView() {
        productImageView.contentMode = .scaleAspectFit
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalTo: contentStackView.heightAnchor, multiplier: 0.8),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            productImageView.centerYAnchor.constraint(equalTo: contentStackView.centerYAnchor)
        ])
    }
    
    private func setUpNameStackView() {
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
    
    private func setUpPriceStackView() {
        priceStackView.axis = .horizontal
        priceStackView.alignment = .fill
        priceStackView.distribution = .fill
        priceStackView.spacing = 8
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        priceStackView.addArrangedSubview(priceLabel)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priceStackView.addArrangedSubview(discountedPriceLabel)
    }
    
    private func setUpAccessoryImageView() {
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        accessoryImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            accessoryImageView.heightAnchor.constraint(equalTo: stockLabel.heightAnchor),
            accessoryImageView.widthAnchor.constraint(equalTo: accessoryImageView.heightAnchor)
        ])
        
        accessoryImageView.image = AccessoryImage.chevron
        accessoryImageView.tintColor = .systemGray
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
    
    private func addUnderLine() {
        let underline = layer.makeBorder([.bottom], color: UIColor.systemGray, width: 0.5)
        underline.frame = CGRect(x: 18, y: layer.frame.height, width: underline.frame.width - 1, height: underline.frame.height)
        layer.addSublayer(underline)
    }
}
