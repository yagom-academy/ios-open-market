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
        self.stackView.addArrangedSubview(self.productImage)
        self.stackView.addArrangedSubview(self.nameLabel)
        self.stackView.addArrangedSubview(self.priceLabel)
        self.stackView.addArrangedSubview(self.stockLabel)
    }
    
    private func layout() {
        configureStackView()
        self.contentView.addSubview(self.stackView)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.productImage.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 0.5)
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
