import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    let itemStackView = UIStackView()
    let thumbnailImageView = UIImageView()
    let nameLabel = UILabel()
    let priceStackView = UIStackView()
    let priceLabel = UILabel()
    let bargainPriceLabel = UILabel()
    let stockLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension GridCollectionViewCell {
    func configure() {
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(bargainPriceLabel)
        itemStackView.addArrangedSubview(thumbnailImageView)
        itemStackView.addArrangedSubview(nameLabel)
        itemStackView.addArrangedSubview(priceStackView)
        itemStackView.addArrangedSubview(stockLabel)

        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.layer.backgroundColor = UIColor.white.cgColor
        self.contentView.addSubview(itemStackView)

        itemStackView.axis = .vertical
        itemStackView.alignment = .center
        itemStackView.distribution = .fill

        NSLayoutConstraint.activate([
            itemStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
