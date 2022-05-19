//
//  GridCell.swift
//  OpenMarket
//
//  Created by 김동욱 on 2022/05/18.
//

import UIKit

class GridCell: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    private lazy var cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "flame")
        image.contentMode = .scaleAspectFit
        image.layer.shadowOffset = CGSize(width: 5, height: 5)
        image.layer.shadowOpacity = 0.7
        image.layer.shadowRadius = 5
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()

    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name Label"
        label.contentMode = .scaleAspectFit
        return label
    }()
    
    private lazy var pricestackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Price Label"
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var bargenLabel: UILabel = {
        let label = UILabel()
        label.text = "Bargen Label"
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var stockLabel: UILabel = {
        let label = UILabel()
        label.text = "Stock Label"
        label.textColor = .lightGray
        return label
    }()
    
    func update(data: Product) {
        nameLabel.text = data.name

        if data.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .systemYellow
        } else {
            guard let stock = data.stock else {
                return
            }
            stockLabel.text = "재고수량: \(stock)"
        }

        guard let currency = data.currency else {
            return
        }

        let price = Formatter.convertNumber(by: data.price?.description)
        let bargenPrice = Formatter.convertNumber(by: data.bargainPrice?.description)

        if data.discountedPrice == 0 {
            priceLabel.text = "\(currency)\(price)"
            bargenLabel.text = ""
        } else {
            priceLabel.textColor = .systemRed
            priceLabel.attributedText = "\(currency)\(price) ".strikeThrough()

            bargenLabel.text = "\(currency)\(bargenPrice)"
        }
    }
    
    func update(image: UIImage) {
        DispatchQueue.main.async {
            self.thumbnailImageView.image = image
        }
    }
}
