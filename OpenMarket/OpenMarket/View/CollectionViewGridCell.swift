import UIKit

class CollectionViewGridCell: UICollectionViewCell {

     var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pencil")
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "name"
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "price"
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "stock"
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(stockLabel)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        // TODO: 테두리 추가 
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        configureAutoLayout()
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateAllComponents(from item: ProductListAsk.Response.Page) {
        imageView.image = ImageLoader.load(from: item.thumbnail)
        activityIndicator.stopAnimating()
        updateNameLabel(from: item)
        updatePriceLabel(from: item)
        updateStockLabel(from: item)
    }
    
    func updateNameLabel(from item: ProductListAsk.Response.Page) {
        let nameText = item.name.boldFont
        nameText.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .title3), range: NSMakeRange(0, nameText.length))
        nameLabel.attributedText = nameText
    }
    
    func updateStockLabel(from item: ProductListAsk.Response.Page) {
        let stockText = NSMutableAttributedString(string: "")
        if item.stock == 0 {
            stockText.append("품절".yellowColor)
        } else {
            let description = "잔여수량: \(item.stock)"
            stockText.append(description.grayColor)
        }
        
        stockText.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .body), range: NSMakeRange(0, stockText.length))
        stockLabel.attributedText = stockText
    }
    
    func updatePriceLabel(from item: ProductListAsk.Response.Page) {
        guard let bargainPrice = item.bargainPrice.description.decimal,
              let originalPrice = item.price.description.decimal else {
                  return
              }
        
        let priceText = NSMutableAttributedString(string: "")
        
        if item.price != item.bargainPrice {
            priceText.append("\(item.currency) \(originalPrice)".redStrikeThroughStyle)
            priceText.append(NSAttributedString(string: "\n"))
            priceText.append("\(item.currency) \(bargainPrice)".grayColor)
        } else {
            priceText.append("\(item.currency) \(originalPrice)".grayColor)
        }
        
        priceText.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .body), range: NSMakeRange(0, priceText.length))
        priceLabel.attributedText = priceText
    }
    func configureAutoLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}
