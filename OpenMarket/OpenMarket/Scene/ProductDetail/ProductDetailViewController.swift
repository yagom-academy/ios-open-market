//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/09.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    // MARK: - properties
    
    private var productID: String?
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchData()
    }
    
    // MARK: - functions
    
    private func fetchData() {
        guard let productID = productID else { return }
        
        let request = ProductGetRequest(headers: nil,
                                        query: nil,
                                        body: nil,
                                        productID: "/" + productID)
        
        let session = MyURLSession()
        session.dataTask(with: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                guard let decodedData = success.decodeData(type: ProductDetail.self) else { return }
                
                decodedData.images
                    .filter
                {
                    ImageCacheManager.shared.object(forKey: NSString(string: $0.thumbnail)) == nil
                    
                }
                
                .forEach
                {
                    $0.pushThumbnailImageCache()
                }
                
                DispatchQueue.main.async {
                    self.navigationItem.title = decodedData.name
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
}

// MARK: - extensions

extension ProductDetailViewController: Datable {
    func setupProduct(id: String) {
        productID = id
    }
}
