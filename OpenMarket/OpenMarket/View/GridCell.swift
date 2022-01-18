import UIKit

class GridCell: UICollectionViewCell {
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

extension GridCell {
    private func configure() {
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(bargainPriceLabel)
        itemStackView.addArrangedSubview(thumbnailImageView)
        itemStackView.addArrangedSubview(nameLabel)
        itemStackView.addArrangedSubview(priceStackView)
        itemStackView.addArrangedSubview(stockLabel)

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

        configureConstraint()
    }

    private func configureConstraint() {
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
}
