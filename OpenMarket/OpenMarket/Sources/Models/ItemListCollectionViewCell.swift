//
//  ItemListCollectionViewCell.swift
//  OpenMarket
//
//  Created by minsson, yeton on 2022/07/26.
//

import UIKit

class ItemListCollectionViewCell: UICollectionViewCell {
    private var item: ItemListPage.Item?
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    let accessaryImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "greaterthan")
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .systemGray
        return label
    }()
    
   let stockLabel: UILabel = {
        let label = UILabel()
       
        label.textAlignment = .right
        label.textColor = .systemGray
        return label
    }()
    
    private let firstHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let secondHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let thirdVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let entireStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func arrangeSubView() {
        firstHorizontalStackView.addArrangedSubview(stockLabel)
        firstHorizontalStackView.addArrangedSubview(accessaryImageView)
        
        secondHorizontalStackView.addArrangedSubview(nameLabel)
        secondHorizontalStackView.addArrangedSubview(firstHorizontalStackView)
        
        thirdVerticalStackView.addArrangedSubview(secondHorizontalStackView)
        thirdVerticalStackView.addArrangedSubview(priceLabel)
        
        entireStackView.addArrangedSubview(productImageView)
        entireStackView.addArrangedSubview(thirdVerticalStackView)
        
        contentView.addSubview(entireStackView)
        
        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            entireStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            entireStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            entireStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor, multiplier: 0.8),
            
            accessaryImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.1)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        arrangeSubView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func receiveData(_ item: ItemListPage.Item) {
        configureCell(with: item)
    }

    func configureCell(with item: ItemListPage.Item) {
        productImageView.image = UIImage(systemName: "photo")
        
        nameLabel.text = item.name
        priceLabel.text = "\(item.price)"
        stockLabel.text = "잔여수량 : \(item.stock)"

        guard let imageURL = URL(string: item.thumbnail) else {
            return
        }

        NetworkManager.fetchImage(from: imageURL) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.productImageView.image = image
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

