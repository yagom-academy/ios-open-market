import UIKit

class ListCell: UICollectionViewCell {
    private lazy var listContentView = UIListContentView(configuration: .subtitleCell())
    private let stockStackView = UIStackView()
    private let stockLabel = UILabel()
    private let disclosureImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension ListCell {
    func configure(product: Product) {
        var content = UIListContentConfiguration.subtitleCell()
        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        guard let url = URL(string: product.thumbnail) else {
            return
        }
        guard let imageData = try? Data(contentsOf: url) else {
            return
        }
        content.image = UIImage(data: imageData)

        content.textProperties.font = .preferredFont(forTextStyle: .headline)
        content.textProperties.color = .black
        content.text = product.name

        content.textToSecondaryTextVerticalPadding = 3
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .callout)
        content.secondaryTextProperties.color = .systemGray

        let priceAttributedString =
            "\(product.currency) \(product.price.format())".eraseOriginalPrice()
        let bargainPriceAttributedString = NSMutableAttributedString(
            string: "\(product.currency) \(product.bargainPrice.format())"
        )

        if product.discountedPrice != 0 {
            let blank = NSMutableAttributedString(string: " ")
            bargainPriceAttributedString.insert(blank, at: 0)
            bargainPriceAttributedString.insert(priceAttributedString, at: 0)
        }
        content.secondaryAttributedText = bargainPriceAttributedString

        listContentView.configuration = content

        stockStackView.axis = .horizontal
        stockStackView.alignment = .center
        stockStackView.distribution = .fill
        stockStackView.spacing = 10
        stockLabel.font = .preferredFont(forTextStyle: .callout)
        if product.stock == .zero {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemOrange
        } else {
            let formattedStock = product.stock.format()
            stockLabel.text = "잔여수량 : \(formattedStock)"
            stockLabel.textColor = .systemGray
        }

        disclosureImage.image = UIImage(systemName: "chevron.forward")
        disclosureImage.tintColor = .systemGray

        configureViewHierarchy()
        configureConstraint()
    }

    private func configureConstraint() {
        listContentView.translatesAutoresizingMaskIntoConstraints = false
        stockStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            listContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            listContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stockStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stockStackView.heightAnchor.constraint(
                equalTo: contentView.heightAnchor,
                multiplier: 0.3
            ),
            stockStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -15
            )
        ])
    }

    private func configureViewHierarchy() {
        contentView.addSubview(listContentView)
        contentView.addSubview(stockStackView)
        stockStackView.addArrangedSubview(stockLabel)
        stockStackView.addArrangedSubview(disclosureImage)
    }
}
