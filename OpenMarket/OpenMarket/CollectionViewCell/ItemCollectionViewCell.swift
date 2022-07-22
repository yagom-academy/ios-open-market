//
//  ItemCollectionViewCell.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/20.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewListCell {
    
    // MARK: Common
    let productThumnail: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let productName: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bargainPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productStockQuntity: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: ListView
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .bottom
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let downStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let totalListStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setListStackView() {
        imageStackView.addArrangedSubview(productThumnail)
        totalListStackView.addArrangedSubview(labelStackView)
        
        labelStackView.addArrangedSubview(upperStackView)
        labelStackView.addArrangedSubview(downStackView)
        
        upperStackView.addArrangedSubview(productName)
        upperStackView.addArrangedSubview(productStockQuntity)
        
        downStackView.addArrangedSubview(productPrice)
        downStackView.addArrangedSubview(bargainPrice)
        
        productName.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        productStockQuntity.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        productPrice.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    }
    
    private func setListConstraints() {
        NSLayoutConstraint.activate([
            imageStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            imageStackView.widthAnchor.constraint(lessThanOrEqualToConstant: 80),
            imageStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 80),
            imageStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            
            totalListStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            totalListStackView.bottomAnchor.constraint(equalTo: imageStackView.bottomAnchor),
            totalListStackView.leadingAnchor.constraint(equalTo: imageStackView.trailingAnchor, constant: 5),
            totalListStackView.topAnchor.constraint(equalTo: imageStackView.topAnchor)
        ])
    }
    
    // MARK: GridView
    
    private let totalGridStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setGridStackView() {
        totalGridStackView.addArrangedSubview(productThumnail)
        totalGridStackView.addArrangedSubview(productName)
        totalGridStackView.addArrangedSubview(productPrice)
        totalGridStackView.addArrangedSubview(bargainPrice)
        totalGridStackView.addArrangedSubview(productStockQuntity)
    }
    
    private func setGridConstraints() {
        NSLayoutConstraint.activate([
            totalGridStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            totalGridStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            totalGridStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            totalGridStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
    
    // MARK: Inint
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageStackView)
        contentView.addSubview(totalListStackView)
        contentView.addSubview(totalGridStackView)
        listCellConstrant()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func prepareForReuse() {
        productPrice.attributedText = nil
    }
    
    func listCellConstrant() {
        totalGridStackView.isHidden = true
        imageStackView.isHidden = false
        totalListStackView.isHidden = false
        setListStackView()
        setListConstraints()
        self.accessories = [.disclosureIndicator()]
    }
    
    func gridCellConstrant() {
        totalGridStackView.isHidden = false
        imageStackView.isHidden = true
        totalListStackView.isHidden = true
        setGridStackView()
        setGridConstraints()
    }
    
    func configureCell(product: SaleInformation) {
        guard let url = URL(string: product.thumbnail) else { return }
        
        NetworkManager().fetch(request: URLRequest(url: url)) { result in
            switch result {
            case .success(let data):
                guard let images = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    self.productThumnail.image = images
                }
            case .failure(_):
                MainViewController().showNetworkError(message: NetworkError.outOfRange.message)
            }
        }
        
        self.productName.text = product.name
        
        showPrice(priceLabel: self.productPrice, bargainPriceLabel: self.bargainPrice, product: product)
        showSoldOut(productStockQuntity: self.productStockQuntity, product: product)
    }
    
    private func showPrice(priceLabel: UILabel, bargainPriceLabel: UILabel, product: SaleInformation) {
        priceLabel.text = "\(product.currency) \(product.price)"
        if product.bargainPrice == 0.0 {
            priceLabel.textColor = .systemGray
            bargainPriceLabel.isHidden = true
        } else {
            priceLabel.textColor = .systemRed
            priceLabel.attributedText = priceLabel.text?.strikeThrough()
            bargainPriceLabel.text = "\(product.currency) \(product.price)"
            bargainPriceLabel.textColor = .systemGray
        }
    }
    
    private func showSoldOut(productStockQuntity: UILabel, product: SaleInformation) {
        if product.stock == 0 {
            productStockQuntity.text = "품절"
            productStockQuntity.textColor = .systemOrange
        } else {
            productStockQuntity.text = "잔여수량 : \(product.stock)"
            productStockQuntity.textColor = .systemGray
        }
    }
}
