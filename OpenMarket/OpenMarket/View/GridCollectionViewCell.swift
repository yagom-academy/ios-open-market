//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/27.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    var product: Item?
    
    private let mainStackView = UIStackView()
    private let productNameLabel = UILabel()
    private let productImage = UIImageView()
    private let priceLabel = UILabel()
    private let priceForSaleLabel = UILabel()
    private let stockLabel = UILabel()
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttribute()
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAttribute() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productImage.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceForSaleLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        mainStackView.distribution = .equalSpacing
        mainStackView.axis = .vertical
        mainStackView.spacing = 5
        loadingView.contentMode = .scaleAspectFill
        productImage.contentMode = .scaleAspectFit
        
        productNameLabel.textAlignment = .center
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        priceLabel.textAlignment = .center
        priceLabel.isHidden = true
        priceForSaleLabel.textAlignment = .center
        stockLabel.textAlignment = .center
    }
    
    private func configureLayout() {
        self.contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(loadingView)
        mainStackView.addArrangedSubview(productImage)
        mainStackView.addArrangedSubview(productNameLabel)
        mainStackView.addArrangedSubview(priceLabel)
        mainStackView.addArrangedSubview(priceForSaleLabel)
        mainStackView.addArrangedSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            productImage.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            loadingView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
        loadingView.startAnimating()
        loadingView.isHidden = false
    }
    
    func configureContent(item: Item) {
        self.product = item
        
        var priceForSale: String
        var priceToString: String
        var stock: String
        
        do {
            priceToString = try item.price.formatDouble
            priceForSale = try item.discountedPrice.formatDouble
            stock = try item.stock.formatInt
        } catch {
            priceToString = OpenMarketStatus.noneError
            priceForSale = OpenMarketStatus.noneError
            stock = OpenMarketStatus.noneError
        }
        
        productNameLabel.text = "\(item.name)"
        priceLabel.text = .none
        priceLabel.attributedText = .none
        stockLabel.text = OpenMarketDataText.stock + "\(stock)"
        stockLabel.textColor = .systemGray
        priceForSaleLabel.text = "\(item.currency) \(priceForSale)"
        priceForSaleLabel.textColor = .systemGray
        
        if item.bargainPrice != 0 {
            priceLabel.isHidden = false
            priceForSaleLabel.text = "\(item.currency) \(priceForSale)"
            priceLabel.textColor = .systemRed
            priceLabel.text = "\(item.currency) \(priceToString)"
            
            guard let priceText = priceLabel.text else { return }
            let attribute = NSMutableAttributedString(string: priceText)
            attribute.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attribute.length))
            priceLabel.attributedText = attribute
            priceForSaleLabel.textColor = .systemGray
        }
        
        if item.stock == 0 {
            stockLabel.text = OpenMarketDataText.soldOut
            stockLabel.text"Co"lor = .systemYellow
        }
        
        DispatchQueue.global().async {
            guard let url = URL(string: item.thumbnail) else { return }
            NetworkManager.publicNetworkManager.getImageData(url: url) { image in
                DispatchQueue.main.async {
                    if item == self.product {
                        self.productImage.image = image
                        self.loadingView.stopAnimating()
                        self.loadingView.isHidden = true
                    }
                }
            }
        }
        
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
    }
}
