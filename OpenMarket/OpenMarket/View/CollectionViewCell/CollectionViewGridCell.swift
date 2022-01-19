import UIKit

class CollectionViewGridCell: UICollectionViewCell {
    
    typealias Product = NetworkingAPI.ProductListQuery.Response.Page

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = imageView.frame
        return indicator
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
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
        label.text = "price"
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "stock"
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [
                nameLabel,
                priceLabel,
                stockLabel
            ]
        )
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttribute()
        configureLayout()
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateAllComponents(from item: Product) {
        ImageLoader.load(from: item.thumbnail) { (result) in
            switch result {
            case .success(let data):
                DispatchQueue.main.sync {
                    self.activityIndicator.stopAnimating()
                    self.imageView.isHidden = false
                    self.imageView.image = UIImage(data: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        updateNameLabel(from: item)
        updatePriceLabel(from: item)
        updateStockLabel(from: item)
    }
    
    private func updateNameLabel(from item: Product) {
        let nameText = item.name.boldFont
        nameText.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .title3), range: NSMakeRange(0, nameText.length))
        nameLabel.attributedText = nameText
    }
    
    private func updateStockLabel(from item: Product) {
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
    
    private func updatePriceLabel(from item: Product) {
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
    
    private func configureAttribute() {
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 15
    }
    
    private func configureLayout() {
        addSubview(activityIndicator)
        addSubview(imageView)
        addSubview(labelStackView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: labelStackView.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 10),
            labelStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.95),
        ])
        
    }
}
