import UIKit

class CollectionViewGridCell: UICollectionViewCell {

     var activityIndicator: UIActivityIndicatorView = {
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
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "name"
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "price"
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "stock"
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(stockLabel)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        // TODO: 테두리 추가 
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        configureAutoLayout()
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureAutoLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            activityIndicator.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8),
            activityIndicator.heightAnchor.constraint(equalTo: activityIndicator.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}
