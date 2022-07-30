//
//  Requestable.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/29.
//

import UIKit

protocol Requestable {}

extension Requestable {
    // MARK: - functions
    func postProduct(images: [Data], product: RegistrationProduct) {
        guard !images.isEmpty else { return }
        guard let productData = try? JSONEncoder().encode(product) else { return }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        let postData = OpenMarketRequest(body: ["params" : [productData],
                                                "images": images],
                                         boundary: boundary,
                                         method: .post,
                                         baseURL: URLHost.openMarket.url + URLAdditionalPath.product.value,
                                         headers: ["identifier": "eef3d2e5-0335-11ed-9676-e35db3a6c61a",
                                                   "Content-Type": "multipart/form-data; boundary=\(boundary)"])
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: postData) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func patchProduct(productId: String, product: RegistrationProduct) {
        guard let productData = try? JSONEncoder().encode(product) else { return }
        let patchData = OpenMarketRequest(body: ["json" : [productData]],
                                          method: .patch,
                                          baseURL: URLHost.openMarket.url + URLAdditionalPath.product.value + "/\(productId)/",
                                          headers: ["identifier": "eef3d2e5-0335-11ed-9676-e35db3a6c61a",
                                                    "Content-Type": "application/json"])
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: patchData) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func getProduct(_ loadingView: UIView?, _ gridCollectionView: GridCollecntionView, _ listCollectionView: ListCollectionView ) {
        
        let productsRequest = OpenMarketRequest(path: URLAdditionalPath.product.value,
                                                method: .get,
                                                baseURL: URLHost.openMarket.url,
                                                query: [
                                                    Product.page.text:  "\(Product.page.number)",
                                                    Product.itemPerPage.text: "\(Product.itemPerPage.number)"
                                                ])
        let myURLSession = MyURLSession()
        myURLSession.dataTask(with: productsRequest) {
            (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                guard let decodedData = success.decodeImageData() else { return }
                decodedData.pages
                    .filter { ImageCacheManager.shared.object(forKey: NSString(string: $0.thumbnail)) == nil }
                    .forEach { $0.pushThumbnailImageCache() }
                DispatchQueue.main.async {
                    
                    guard let loadingView = loadingView else { return }
                    
                    defer {
                        loadingView.isHidden = true
                    }
                    
                    gridCollectionView.setSnapshot(productsList: decodedData.pages)
                    listCollectionView.setSnapshot(productsList: decodedData.pages)
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    
    func convertImages(view: UIView) -> [Data] {
        var images = [Data]()
        let _ = view.subviews
            .forEach { guard let imageView = $0 as? UIImageView,
                             let image = imageView.image else { return }
                images.append(image.resize(width: 300).pngData() ?? Data())
            }
        
        return images
    }
}

extension UIImage {
    func resize(width: CGFloat) -> UIImage {
        let scale = width / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: width, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        var renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        let imgData = NSData(data: renderImage.pngData()!)
        let imageSize = Double(imgData.count) / 1000
        
        if imageSize > 300 {
            renderImage = resize(width: width - 5)
        }
        return renderImage
    }
}
