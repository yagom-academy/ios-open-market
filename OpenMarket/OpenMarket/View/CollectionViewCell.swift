//
//  CollectionViewCell.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/18.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    let containerStackView = UIStackView()
    let priceStackView = UIStackView()
    
    var imageView = UIImageView()
    var productNameLabel = UILabel()
    var bargainPriceLabel = UILabel()
    var priceLabel = UILabel()
    var stockLabel = UILabel()
    
    let fontSize = CGFloat(20)
    let imageHeight = CGFloat(150)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpCell()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCell()
    }
    
    func setUpCell() {
        self.addSubview(containerStackView)
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2)
//            containerStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ] )
        containerStackView.axis = .vertical
        containerStackView.alignment = .fill
        containerStackView.distribution = .fill
        containerStackView.spacing = 10
        containerStackView.clipsToBounds = true
        
        containerStackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: imageHeight + 4)
//            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ] )
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        containerStackView.addArrangedSubview(productNameLabel)
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: imageHeight + 7),
            productNameLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: imageHeight + fontSize + 7)
//            productNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ] )
        
        containerStackView.addArrangedSubview(priceStackView)
        priceStackView.axis = .vertical
        priceStackView.alignment = .center
        priceStackView.spacing = 1
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            priceStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(fontSize + 7)),
            priceStackView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(fontSize * 3 + 9))
//            priceStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ] )
        
        priceStackView.addArrangedSubview(bargainPriceLabel)
        priceStackView.addArrangedSubview(priceLabel)
        
        containerStackView.addArrangedSubview(stockLabel)
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate( [
            stockLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            stockLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(fontSize + 4))
//            stockLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ] )
    }
    
    func updateCell(data: ProductPreview) {
        productNameLabel.text = data.name
        productNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        productNameLabel.textAlignment = .center
        
        bargainPriceLabel.attributedText = ("\(data.currency) \(data.bargainPrice.addDemical())").strikeThroughStyle()
        bargainPriceLabel.textColor = .systemRed
        bargainPriceLabel.textAlignment = .center

        priceLabel.text = "\(data.price.addDemical())"
        priceLabel.textAlignment = .center

        switch data.stock {
        case 0:
            stockLabel.text = "품절"
            stockLabel.textColor = .systemOrange
            stockLabel.textAlignment = .center
        default:
            stockLabel.text = "잔여 수량: \(data.stock)"
            stockLabel.textAlignment = .center

        }
        
        guard let url = URL(string: data.thumbnail) else {
            return
        }
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
}
