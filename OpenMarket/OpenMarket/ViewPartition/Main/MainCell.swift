//
//  MainCell.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/26.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var remainedStockLabel: UILabel!
    
    private let stockPrefix = "잔여수량 : "
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layerStyling()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layerStyling()
    }
    
    func configure(with item: Goods) {
        drawImage(with: item.thumbnailURLs.first)
        titleLabel.text = item.title
        originalPriceLabel.text = PrefixFormatter.toDecimal(from: item.price)
        discountedPriceLabel.text =  (item.discountedPrice?.description ?? "")
        remainedStockLabel.text = stockPrefix + item.stock.description
    }
    
    
    private func drawImage(with path: String?) {
        guard let path = path else {
            return
        }
        
        do {
            try NetworkManager.shared.getAnImage(with: path) { [weak self] result in
                switch result {
                case .success(let data):
                    let imageData = UIImage(data: data)
                    DispatchQueue.main.async {
                        self?.imageView.image = imageData
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func layerStyling() {
        self.layer.cornerRadius = 12
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
    }
}
