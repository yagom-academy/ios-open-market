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
    
    func configure(with item: Goods) {
        if let first = item.thumbnailURLs.first {
            drawImage(with: first)
        }
        titleLabel.text = item.title
        originalPriceLabel.text = item.price.description
        discountedPriceLabel.text = item.discountedPrice?.description ?? ""
        remainedStockLabel.text = item.stock.description
    }
    
    private func drawImage(with path: String) {
        var imageData: UIImage?
        do {
            try NetworkManager.shared.getAnImage(with: path) { [weak self] result in
                switch result {
                case .success(let data):
                    imageData = UIImage(data: data)
                    DispatchQueue.main.async {
                        self?.imageView.image = imageData
                    }
                case .failure:
                    imageData = nil
                }
            }
        } catch {
            print(error)
        }
    }
}
