//  Created by Aejong, Tottale on 2022/11/22.

import UIKit

final class ProductGridCell: UICollectionViewCell {
    
    private let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.alignment = .center
        stackview.distribution = .equalSpacing
        stackview.translatesAutoresizingMaskIntoConstraints = false
        return stackview
    }()
    
    private let productImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureStackView() {
        stackView.addArrangedSubview(productImage)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(stockLabel)
    }
    
    private func layout() {
        configureStackView()
        contentView.addSubview(stackView)
        
        layer.masksToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.lightGray.cgColor
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            productImage.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5)
        ])
    }
    
    func configureCell(with product: Product) {
        let networkProvider = NetworkAPIProvider()
        networkProvider.fetchImage(url: product.thumbnail) { result in
            switch result {
            case .failure(_):
                DispatchQueue.main.async { [weak self] in
                    self?.productImage.image = UIImage(systemName: "xmark.seal.fill")
                }
                return
            case .success(let image):
                DispatchQueue.main.async { [weak self] in
                    self?.productImage.image = image
                }
            }
        }
        self.nameLabel.text = product.name
        self.priceLabel.attributedText = product.attributedLineBreakedPriceString
        self.stockLabel.attributedText = product.stock == 0 ? "품절".foregroundColor(.orange) : "잔여수량: \(product.stock)".attributed
    }
}
