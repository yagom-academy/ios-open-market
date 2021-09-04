//
//  ImageManager.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/05.
//

import UIKit

struct ImageManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func loadedImage(url: String, compleHandler: @escaping (Result<UIImage, NetworkError>) -> Void) {
        
    }
}
