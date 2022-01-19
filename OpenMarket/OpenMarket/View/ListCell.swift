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
        stockStackView.axis = .horizontal
        stockStackView.alignment = .center
        stockStackView.distribution = .fill
        stockStackView.spacing = 10
        stockLabel.font = .preferredFont(forTextStyle: .callout)

        disclosureImage.image = UIImage(systemName: "chevron.forward")
        disclosureImage.tintColor = .systemGray

        configureViewHierarchy()
        configureConstraint()
        configureContent(product: product)
    }

    private func configureViewHierarchy() {
        contentView.addSubview(listContentView)
        contentView.addSubview(stockStackView)
        stockStackView.addArrangedSubview(stockLabel)
        stockStackView.addArrangedSubview(disclosureImage)
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

    private func configureContent(product: Product) {
        var content = UIListContentConfiguration.subtitleCell()
        content.imageProperties.maximumSize = CGSize(width: 40, height: 40)
        guard let url = URL(string: product.thumbnail) else {
            return
        }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                return
            }
            DispatchQueue.main.async {
                content.image = UIImage(data: imageData)
                self.listContentView.configuration = content
            }
        }

        content.textProperties.font = .preferredFont(forTextStyle: .headline)
        content.textProperties.color = .black
        content.text = product.name

        content.textToSecondaryTextVerticalPadding = 3
        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .callout)
        content.secondaryTextProperties.color = .systemGray

        guard let price = product.price.format() else {
            return
        }
        let priceAttributedString =
            "\(product.currency) \(price)".eraseOriginalPrice()
        guard let bargainPrice = product.bargainPrice.format() else {
            return
        }
        let bargainPriceAttributedString = NSMutableAttributedString(
            string: "\(product.currency) \(bargainPrice)"
        )

        if product.discountedPrice != 0 {
            let blank = NSMutableAttributedString(string: " ")
            bargainPriceAttributedString.insert(blank, at: 0)
            bargainPriceAttributedString.insert(priceAttributedString, at: 0)
        }
        content.secondaryAttributedText = bargainPriceAttributedString

        listContentView.configuration = content

        if product.stock == .zero {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemOrange
        } else {
            guard let formattedStock = product.stock.format() else {
                return
            }
            stockLabel.text = "잔여수량 : \(formattedStock)"
            stockLabel.textColor = .systemGray
        }
    }
}
