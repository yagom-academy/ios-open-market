//
//  SessionImageView.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/08/01.
//

import UIKit

class SessionImageView: UIImageView {
    func configureImage(url: String) {
        let sessionManager = URLSessionManager(session: URLSession.shared)
        let cachedKey = NSString(string: url)
        
        sessionManager.receiveData(baseURL: url) { result in
            switch result {
            case .success(let data):
                guard let imageData = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    ImageCacheManager.shared.setObject(imageData, forKey: cachedKey)
                    self.image = imageData
                }
            case .failure(_):
                print("서버 통신 실패")
            }
        }
    }
}
