//
//  CollectionViewGridLayoutCell.swift
//  OpenMarket
//
//  Created by 이원빈 on 2022/07/15.
//

import UIKit

class GridCell: UICollectionViewCell {
    
    let numberFormatter = NumberFormatter()
    
    private let verticalStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        stackview.alignment = .center
        stackview.distribution = .equalSpacing
        stackview.spacing = 0
        return stackview
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Mac mini"
        label.sizeToFit()
        return label
    }()
    
    private let productBargainPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.text = "JPY 300"
        label.sizeToFit()
        return label
    }()
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "JPY 800"
        label.sizeToFit()
        return label
    }()
    
    private let productStockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "잔여수량: 20"
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        numberFormatter.numberStyle = .decimal
        setupAddSubviews()
        setupConstraints()
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAddSubviews() {
        self.contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(productImageView)
        verticalStackView.addArrangedSubview(productNameLabel)
        verticalStackView.addArrangedSubview(productPriceLabel)
        verticalStackView.addArrangedSubview(productBargainPriceLabel)
        verticalStackView.addArrangedSubview(productStockLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
//            productImageView.heightAnchor.constraint(equalToConstant: 150),
//            productImageView.widthAnchor.constraint(equalToConstant: 150)
            productImageView.leadingAnchor.constraint(equalTo: self.verticalStackView.leadingAnchor, constant: 10),
            productImageView.trailingAnchor.constraint(equalTo: self.verticalStackView.trailingAnchor, constant: -10),
            productImageView.heightAnchor.constraint(equalTo: self.productImageView.widthAnchor)
        ])
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            verticalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupLayer() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 12
    }
    
    func setupCellData(with inputData: Product) {
        guard let url = URL(string: inputData.thumbnail) else {
            return
        }
        self.productImageView.loadImage(url: url)
        self.productNameLabel.text = inputData.name
        
        setupProductBargainPriceLabel(with: inputData)
        
        if inputData.stock > 0 {
            self.productStockLabel.text = "잔여수량 : \(inputData.stock)"
            self.productStockLabel.textColor = .lightGray
        } else {
            self.productStockLabel.text = "품절"
            self.productStockLabel.textColor = .orange
        }
        
    }
    private func setupProductBargainPriceLabel(with inputData: Product) {
        if inputData.price == inputData.bargainPrice { //할인 안하면 > 그대로 + 할인가격 히든
            self.productBargainPriceLabel.isHidden = true
            let price = numberFormatter.string(from: NSNumber.init(value: inputData.price))
            self.productPriceLabel.text = "\(inputData.currency.rawValue.uppercased()) " + (price ?? "")
        } else { //할인 한 경우 > 원가격 빨간색 + 밑줄 , 바겐프라이스 출력
            var price = numberFormatter.string(from: NSNumber.init(value: inputData.price))
            price = "\(inputData.currency.rawValue.uppercased()) " + (price ?? "")
            self.productPriceLabel.strikethrough(from: price)
            self.productPriceLabel.textColor = .red
            let bargainPrice = numberFormatter.string(from: NSNumber.init(value: inputData.bargainPrice))
            self.productBargainPriceLabel.text = "\(inputData.currency.rawValue.uppercased()) " + (bargainPrice ?? "")
        }
    }
    
    override func prepareForReuse() {
        self.productPriceLabel.textColor = .lightGray
        self.productPriceLabel.attributedText = nil
        self.productBargainPriceLabel.isHidden = false
    }
}


