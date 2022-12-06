//
//  GridCollectionViewCell.swift
//  OpenMarket
//
//  Created by Ash and som on 2022/11/27.
//

import UIKit

final class GridCollectionViewCell: UICollectionViewCell {
    var product: Item?
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    private let productImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isHidden = true
        
        return label
    }()
    
    private let priceForSaleLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        configureItemLabel(item: item)
        configureItemImage(item: item)
    }
    
    private func configureItemImage(item: Item) {
        DispatchQueue.global().async {
            NetworkManager.publicNetworkManager.getImageData(url: item.thumbnail) { image in
                DispatchQueue.main.async { [weak self] in
                    if item == self?.product {
                        self?.productImage.image = image
                        self?.loadingView.stopAnimating()
                        self?.loadingView.isHidden = true
                    }
                }
            }
        }
    }
    
    private func configureItemLabel(item: Item) {
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
            stockLabel.textColor = .systemYellow
        }
        
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 1
    }
}
