//
//  ItemDetailCell.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/06/01.
//

import UIKit

final class ItemDetailImageCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    private var dataTask: URLSessionDataTask?
    
    func configureImage(url: String) {
        dataTask = itemImageView.getImge(urlString: url)
    }
}
