//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Red, Mino. on 2022/05/16.
//

import UIKit

final class ProductsGridCell: UICollectionViewCell, BaseCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    private enum Constants {
        static let completedState = 3
    }
    
    private var tasks: [URLSessionDataTaskProtocol] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
        setUpAttribute()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        makeConstraints()
        setUpAttribute()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = ""
        priceLabel.text = ""
        sellingPriceLabel.text = ""
        stockLabel.text = ""
        
        tasks.forEach { task in
            let task = task as? URLSessionDataTask
            if task?.state.rawValue != Constants.completedState {
                task?.cancel()
            }
        }
        tasks.removeAll()
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, priceLabel, sellingPriceLabel, stockLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
    }()
    
    private let sellingPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.textAlignment = .center
        return label
    }()
    
    private func addSubviews() {
        contentView.addSubview(stackView)
        contentView.addSubview(indicatorView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
        ])
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
            indicatorView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            indicatorView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0),
            indicatorView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
        ])
    }
    
    private func setUpAttribute() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray2.cgColor
        layer.cornerRadius = 10
    }
    
    func configure(data: ProductDetail, imageCacheManager: ImageCacheManager) {
        guard let url = data.thumbnail else { return }
        updateLabel(data: data)
        updateImage(url: url, imageCacheManager: imageCacheManager)
    }
    
    private func updateLabel(data: ProductDetail) {
        guard let name = data.name,
              let currency = data.currency?.rawValue,
              let price = data.price?.toDecimal(),
              let barginPrice = data.bargainPrice?.toDecimal(),
              let stock = data.stock
        else {
            return
        }
        
        nameLabel.text = name
        
        if data.discountedPrice == .zero {
            priceLabel.isHidden = true
            sellingPriceLabel.text = "\(currency)  \(price)"
        } else {
            priceLabel.isHidden = false
            priceLabel.addStrikeThrough()
            priceLabel.text = "\(currency)  \(price)"
            sellingPriceLabel.text = "\(currency)  \(barginPrice)"
        }
        
        stockLabel.textColor = stock == .zero ? .systemOrange : .systemGray
        stockLabel.text = stock == .zero ? "품절 " : "남은수량 : \(stock) "
    }
    
    private func updateImage(url: URL, imageCacheManager: ImageCacheManager) {
        indicatorView.startAnimating()
        
        let task = imageView.loadImage(url: url, imageCacheManager: imageCacheManager) {
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
            }
        }
        
        guard let task = task else {
            return
        }
        
        tasks.append(task)
    }
}
