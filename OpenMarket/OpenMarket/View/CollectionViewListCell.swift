import UIKit

class CollectionViewListCell: UICollectionViewListCell {
    //MARK: Property
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    //MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    //MARK: Method
    func updateAllComponents(from item: ProductListAsk.Response.Page) {
        ImageLoader.load(from: item.thumbnail) { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                    self.activityIndicator.stopAnimating()
                    self.layoutIfNeeded()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        updateNameLabel(from: item)
        updatePriceLabel(from: item)
        updateStockLabel(from: item)
    }
    
    private func updateNameLabel(from item: ProductListAsk.Response.Page) {
        let nameText = item.name.boldFont
        nameText.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .caption1), range: NSMakeRange(0, nameText.length))
        nameLabel.attributedText = nameText
    }
    
    private func updateStockLabel(from item: ProductListAsk.Response.Page) {
        let stockText = NSMutableAttributedString(string: "")
        if item.stock == 0 {
            stockText.append("품절".yellowColor)
        } else {
            let description = "잔여수량: \(item.stock)"
            stockText.append(description.grayColor)
        }
        
        stockText.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .caption2), range: NSMakeRange(0, stockText.length))
        stockLabel.attributedText = stockText
    }
    
    private func updatePriceLabel(from item: ProductListAsk.Response.Page) {
        guard let bargainPrice = item.bargainPrice.description.decimal,
              let originalPrice = item.price.description.decimal else {
                  return
              }
        
        let priceText = NSMutableAttributedString(string: "")
        
        if item.price != item.bargainPrice {
            priceText.append("\(item.currency) \(originalPrice)".redStrikeThroughStyle)
            priceText.append(NSAttributedString(string: " "))
            priceText.append("\(item.currency) \(bargainPrice)".grayColor)
        } else {
            priceText.append("\(item.currency) \(originalPrice)".grayColor)
        }
        
        priceText.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .caption2), range: NSMakeRange(0, priceText.length))
        priceLabel.attributedText = priceText
    }
    //MARK: Layout 
    private func configureLayout() {
        contentView.addSubview(activityIndicator)
        contentView.addSubview(imageView)
        contentView.addSubview(labelStackView)
        contentView.addSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            activityIndicator.trailingAnchor.constraint(equalTo: labelStackView.leadingAnchor, constant: -5),
            activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            activityIndicator.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/6),
            activityIndicator.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: labelStackView.leadingAnchor, constant: -5),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/6),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        NSLayoutConstraint.activate([
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stockLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
}
