import UIKit

class ListCell: UICollectionViewCell {

    private lazy var listContentView = UIListContentView(configuration: .subtitleCell())

    private let stockStackView = UIStackView()
    private let stockLabel = UILabel()
    private let disclosureImage = UIImageView()

    func configure(product: Product) {
        var content = UIListContentConfiguration.subtitleCell()
        content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
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

        content.secondaryTextProperties.font = .preferredFont(forTextStyle: .callout)
        content.secondaryTextProperties.color = .systemGray

        let priceAttributedString =
            "\(product.currency) \(product.price.format())".eraseOriginalPrice()
        let bargainPriceAttributedString = NSMutableAttributedString(
            string: "\(product.currency) \(product.bargainPrice)"
        )

        if product.discountedPrice != 0 {
            bargainPriceAttributedString.insert(priceAttributedString, at: 0)
        }
        content.secondaryAttributedText = bargainPriceAttributedString

        listContentView.configuration = content

        stockStackView.translatesAutoresizingMaskIntoConstraints = false
        stockStackView.axis = .horizontal
        stockStackView.alignment = .center
        stockStackView.distribution = .fill
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
        stockStackView.addArrangedSubview(stockLabel)
        stockStackView.addArrangedSubview(disclosureImage)
    }
}
