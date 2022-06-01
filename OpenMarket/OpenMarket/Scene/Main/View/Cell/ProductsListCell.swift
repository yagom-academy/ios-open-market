//
//  ListCollectionViewCell.swift
//  OpenMarket
//
//  Created by Red, Mino. on 2022/05/16.
//

import UIKit

final class ProductsListCell: UICollectionViewCell, BaseCell {
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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        makeConstraints()
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
        let stackView = UIStackView(arrangedSubviews: [imageView, informationStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        return indicatorView
    }()
    
    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topStackView, bottomStackView])
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var topStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, stockLabel])
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemGray2
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [priceLabel, sellingPriceLabel])
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    
    private let sellingPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func addSubviews() {
        contentView.addSubview(stackView)
        contentView.addSubview(indicatorView)
        contentView.addSubview(bottomLineView)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
            indicatorView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
            indicatorView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0),
            indicatorView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            bottomLineView.heightAnchor.constraint(equalToConstant: 1),
            bottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            bottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
    }
    
    func configure(data: ProductDetail, apiService: APIProvider) {
        guard let url = data.thumbnail else { return }
        updateLabel(data: data)
        updateImage(url: url, apiService: apiService)
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
    
    private func updateImage(url: URL, apiService: APIProvider) {
        indicatorView.startAnimating()
        
        let task = imageView.loadImage(url: url, apiService: apiService) {
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
