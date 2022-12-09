//
//  CustomCollectionViewPageCell.swift
//  OpenMarket
//
//  Created by 서현웅 on 2022/12/09.
//

import UIKit

class CustomCollectionViewPageCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var imageOrderLabel: UILabel!

    var networkCommunication = NetworkCommunication()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(image: Image, index: Int, totalCount: Int) {
        if let url = URL(string: image.thumbnailURL) {
            imageOrderLabel.text = "(index+1)/(totalCount)"
            networkCommunication.requestImageData(url: url) { [weak self] data in
                switch data {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.productImage.image = UIImage(data: data)
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
    }
    
    
    
}
