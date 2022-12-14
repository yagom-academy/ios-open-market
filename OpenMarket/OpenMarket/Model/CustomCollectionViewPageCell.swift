//
//  CustomCollectionViewPageCell.swift
//  OpenMarket
//
//  Created by Mangdi, Woong on 2022/12/09.
//

import UIKit

final class CustomCollectionViewPageCell: UICollectionViewCell {
    @IBOutlet private weak var productImage: UIImageView!
    @IBOutlet private weak var imageOrderLabel: UILabel!

    private var networkCommunication = NetworkCommunication()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(image: Image, index: Int, totalCount: Int) {
        imageOrderLabel.text = "\(index+1)/\(totalCount)"
        let imageCacheKey = NSString(string: image.thumbnailURL)
        if let imageCacheValue = ImageCacheManager.shared.object(forKey: imageCacheKey) {
            productImage.image = imageCacheValue
            
        } else if let url = URL(string: image.thumbnailURL) {
            networkCommunication.requestImageData(url: url) { [weak self] data in
                switch data {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.productImage.image = UIImage(data: data)
                        guard let image = UIImage(data: data) else { return }
                        ImageCacheManager.shared.setObject(image, forKey: imageCacheKey)
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
    }
}
