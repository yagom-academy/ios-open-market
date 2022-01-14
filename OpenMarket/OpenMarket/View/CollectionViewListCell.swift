import UIKit

class CollectionViewListCell: UICollectionViewCell {
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)
        return stackView
    }()
    
    let detailAskButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(labelStackView)
        stackView.addArrangedSubview(detailAskButton)
        return stackView
    }()
    
    func configureLayout() {
        activityIndicator.bounds = contentView.bounds
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: labelStackView.leadingAnchor, constant: -5),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            labelStackView.trailingAnchor.constraint(equalTo: detailAskButton.leadingAnchor, constant: -15),
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        NSLayoutConstraint.activate([
            detailAskButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            detailAskButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            detailAskButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            detailAskButton.widthAnchor.constraint(equalTo: detailAskButton.heightAnchor)
        ])
    }
}
