import UIKit

class CollectionViewListCell: UICollectionViewCell {
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pencil")
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
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)
        return stackView
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
//    lazy var horizontalStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.addArrangedSubview(imageView)
//        stackView.addArrangedSubview(activityIndicator)
//        stackView.addArrangedSubview(labelStackView)
//        stackView.addArrangedSubview(stockLabel)
//        return stackView
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(labelStackView)
        contentView.addSubview(stockLabel)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureLayout() {
        activityIndicator.bounds = contentView.bounds
        imageView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: labelStackView.leadingAnchor, constant: -5),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/6),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            labelStackView.trailingAnchor.constraint(equalTo: stockLabel.leadingAnchor, constant: -15),
            labelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        NSLayoutConstraint.activate([
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            stockLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stockLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            stockLabel.widthAnchor.constraint(equalTo: stockLabel.heightAnchor)
        ])
    }
}
