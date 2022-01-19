import UIKit

class GridCell: UICollectionViewCell {
    private let itemStackView = UIStackView()
    private let thumbnailImageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceStackView = UIStackView()
    private let priceLabel = UILabel()
    private let bargainPriceLabel = UILabel()
    private let stockLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension GridCell {
    func configure(product: Product) {
        self.layer.borderColor = UIColor.systemGray3.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.layer.backgroundColor = UIColor.white.cgColor
        self.contentView.addSubview(itemStackView)

        itemStackView.axis = .vertical
        itemStackView.alignment = .center
        itemStackView.distribution = .fill
        itemStackView.spacing = 10
        priceStackView.axis = .vertical
        priceStackView.alignment = .center
        priceStackView.distribution = .fillEqually

        thumbnailImageView.contentMode = .scaleAspectFit

        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.textColor = .black
        priceLabel.font = .preferredFont(forTextStyle: .callout)
        priceLabel.textColor = .systemRed
        bargainPriceLabel.font = .preferredFont(forTextStyle: .callout)
        bargainPriceLabel.textColor = .systemGray
        stockLabel.font = .preferredFont(forTextStyle: .callout)

        configureViewHierarchy()
        configureConstraint()
        configureContent(product: product)
    }

    private func configureViewHierarchy() {
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(bargainPriceLabel)
        itemStackView.addArrangedSubview(thumbnailImageView)
        itemStackView.addArrangedSubview(nameLabel)
        itemStackView.addArrangedSubview(priceStackView)
        itemStackView.addArrangedSubview(stockLabel)
    }

    private func configureConstraint() {
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            itemStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            ),
            itemStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 5
            ),
            itemStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -5
            ),
            thumbnailImageView.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
                multiplier: 0.55
            ),
            nameLabel.heightAnchor.constraint(equalToConstant: 15),
            stockLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }

    private func configureContent(product: Product) {
        guard let url = URL(string: product.thumbnail) else {
            return
        }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                return
            }
            DispatchQueue.main.async {
                self.thumbnailImageView.image = UIImage(data: imageData)
            }
        }
        nameLabel.text = product.name
        if product.discountedPrice != .zero {
            guard let formattedPrice = product.price.format() else {
                return
            }
            let priceAttributedString =
                "\(formattedPrice)".eraseOriginalPrice()
            priceLabel.attributedText = priceAttributedString
        } else {
            priceLabel.isHidden = true
        }
        guard let formattedBargainPrice = product.bargainPrice.format() else {
            return
        }
        bargainPriceLabel.text = "\(product.currency) \(formattedBargainPrice)"
        if product.stock == .zero {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemOrange
        } else {
            guard let formattedStock = product.bargainPrice.format() else {
                return
            }
            stockLabel.text = "잔여수량 : \(formattedStock)"
            stockLabel.textColor = .systemGray
        }
    }
}
