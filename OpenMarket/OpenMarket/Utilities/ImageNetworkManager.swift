//  Created by Aejong, Tottale on 2022/11/30.

import UIKit

struct ImageNetworkManager {
    private let networkProvider = NetworkAPIProvider()
    
    func fetchImage(url: String, completion: @escaping (UIImage) -> Void) -> URLSessionDataTask {
        let url = URL(string: url)!
        let dataTask: URLSessionDataTask = networkProvider.fetchWithDataTask(url: url) { result in
            guard let loadingImage: UIImage = UIImage(systemName: "xmark.seal.fill") else { return }
            switch result {
            case .success(let data):
                guard let image: UIImage = UIImage(data: data) else {
                    completion(loadingImage)
                    return
                }
                completion(image)
            case .failure:
                completion(loadingImage)
                return
            }
        }
        
        return dataTask
    }
    
}
