//
//  ProductImage.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

import UIKit

struct ProductImage: Codable {
    let id: Int
    let url: String
    let thumbnail: String
    let succeed: Bool
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case thumbnail = "thumbnail_url"
        case succeed
        case issuedAt = "issued_at"
    }
}

extension ProductImage {
    func pushThumbnailImageCache() {
        let request = ImageGetRequest(baseURL: self.thumbnail)
        
        let session = MyURLSession()
        session.execute(with: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                guard let image = UIImage(data: success) else { return }
                
                ImageCacheManager.shared.setObject(image,
                                                   forKey: NSString(string: self.thumbnail))
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
