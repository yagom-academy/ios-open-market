//
//  ImageLoader.swift
//  OpenMarket
//
//  Created by Dasoll Park on 2021/08/19.
//

import UIKit

class ImageLoader {
    
    static let shared = ImageLoader()
    
    private init() {}
    
    func loadImage(from urlString: String,
                   indexPath: IndexPath,
                   collectionView: UICollectionView,
                   at cell: GridItemCollectionViewCell) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  (200...299).contains(statusCode) else { return }
            guard let data = data else { return }
            
            let imageData = UIImage(data: data)
            DispatchQueue.main.async {
                if indexPath == collectionView.indexPath(for: cell) {
                    cell.thumbnailImageView?.image = imageData
                }
            }
        }.resume()
    }
}
