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
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 5)
        ] )
        containerStackView.axis = .vertical
        containerStackView.alignment = .center
        containerStackView.spacing = 5
        
        containerStackView.addArrangedSubview(imageView)
        
        
        containerStackView.addArrangedSubview(productNameLabel)
        containerStackView.addArrangedSubview(priceStackView)
        containerStackView.addArrangedSubview(stockLabel)

        priceStackView.axis = .vertical
        priceStackView.alignment = .center
        priceStackView.spacing = 2
        
        priceStackView.addArrangedSubview(bargainPriceLabel)
        priceStackView.addArrangedSubview(priceLabel)
    }
    
    func updateCell(data: ProductPreview) {
        productNameLabel.text = data.name
        bargainPriceLabel.text = String(data.bargainPrice)
        priceLabel.text = String(data.price)
        switch data.stock {
        case 0:
            stockLabel.text = "품절"
        default:
            stockLabel.text = String(data.stock)
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
                
                self.imageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate( [
                    self.imageView.widthAnchor.constraint(equalTo: self.containerStackView.widthAnchor),
                    self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor)
                ] )
            }
        }
    }
}
