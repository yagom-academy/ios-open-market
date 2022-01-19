import UIKit

class CollectionViewGridCell: UICollectionViewCell {

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = imageView.frame
        return indicator
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "name"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "price"
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "stock"
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                activityIndicator,
                imageView,
                nameLabel,
                priceLabel,
                stockLabel
            ]
        )
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateAllComponents(from item: ProductListAsk.Response.Page) {
        ImageLoader.load(from: item.thumbnail) { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                    self.activityIndicator.stopAnimating()
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
        nameText.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .title3), range: NSMakeRange(0, nameText.length))
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
        
        stockText.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .body), range: NSMakeRange(0, stockText.length))
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
            priceText.append(NSAttributedString(string: "\n"))
            priceText.append("\(item.currency) \(bargainPrice)".grayColor)
        } else {
            priceText.append("\(item.currency) \(originalPrice)".grayColor)
        }
        
        priceText.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .body), range: NSMakeRange(0, priceText.length))
        priceLabel.attributedText = priceText
    }
    private func configureLayout() {
        addSubview(stackView)
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
