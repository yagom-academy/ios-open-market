//
//  GneratedCollectionViewCell.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/16.
//

import UIKit

class GeneratedCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect){
        super.init(frame: frame)
    }

    let imageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "yagom")

        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    let productLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "야곰아카데미"
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()

    let discountedPriceLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "KRW 1,000"
        textLabel.textColor = .lightGray
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()

    let originalPriceLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "USD 2,000"
        textLabel.textColor = .lightGray
        textLabel.textAlignment = .center
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()

    let stockLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "품절"
        textLabel.textColor = .orange
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        return textLabel
    }()

    func configure(item: Item) {
            productLabel.text = item.title
            originalPriceLabel.text = "\(item.currency) \(item.price)"
            
            if item.discountedPrice != nil {
                discountedPriceLabel.text = "\(item.currency) \(item.discountedPrice!)"
                originalPriceLabel.textColor = UIColor.systemRed
                originalPriceLabel.attributedText = originalPriceLabel.text?.strikeThrough()
            } else {
                discountedPriceLabel.text = nil
                discountedPriceLabel.isHidden = true
            }

            if item.stock == 0 {
                stockLabel.text = "품절"
                stockLabel.textColor = .orange
            } else if item.stock > 99 {
                stockLabel.text = "잔여수량: 99↑"
                stockLabel.textColor = .systemGray2
            } else {
                stockLabel.text = "잔여수량: \(item.stock)"
                stockLabel.textColor = .systemGray2
            }

        DispatchQueue.global().async {
            guard let image = try? Data(contentsOf: URL(string: item.thumbnailURLs[0])!) else { return }

            DispatchQueue.main.async { [self] in
                imageView.image = UIImage(data: image)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.productLabel.text = "야곰 아카데미"
        self.imageView.image = UIImage(named: "yagom")
        self.discountedPriceLabel.text = ""
        self.stockLabel.text = "품절"
        discountedPriceLabel.isHidden = false
        originalPriceLabel.attributedText = nil
        originalPriceLabel.textColor = UIColor.systemGray2
    }
}
