//
//  ProductRegistrationViewController.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/24.
//

import UIKit

final class ProductRegistrationViewController: UIViewController {
    let networkManager = NetworkManager()
    let productRegistrationView = ProductRegistrationView()
    let boundary = "Boundary-\(UUID().uuidString)"
    let product = PostProduct(name: "아유 하기싫어",
                              description: "아유 하기싫어",
                              price: 1.0,
                              currency: .KRW,
                              discountedPrice: 1,
                              stock: 9999,
                              secret: "9vqf2ysxk8tnhzm9")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureNavigationBar()
        productRegistrationView.imagesCollectionView.dataSource = self
        productRegistrationView.imagesCollectionView.delegate = self
        productRegistrationView.imagesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        //        guard let request = configureRequest() else { return }
        //        guard let image = UIImage(named: "sample1") else { return }
        //        guard let data = configureRequestBody(product, [image]) else { return }
        //        networkManager.postData(request: request, data: data)
    }
    
    func configureView() {
        view = productRegistrationView
        view.backgroundColor = .white
    }
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: nil)
        navigationItem.title = "상품 등록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
    }
}

extension ProductRegistrationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemPink
        return cell
    }
}

extension ProductRegistrationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = view.bounds.width * 0.3
        let height: CGFloat = width
        
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,
                            left: 10,
                            bottom: 10,
                            right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


extension ProductRegistrationViewController {
    func configureRequest() -> URLRequest? {
        guard let url = URL(string: "https://openmarket.yagom-academy.kr/api/products") else {
            return nil
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("3595be32-6941-11ed-a917-b17164efe870",
                         forHTTPHeaderField: "identifier")
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func configureRequestBody(_ product: PostProduct, _ images: [UIImage]) -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let productData = try? encoder.encode(product) else {
            return nil
        }
        
        var data = Data()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
        data.append(productData)
        data.appendString("\r\n")
        
        images.forEach { image in
            guard let convertedImage = image.pngData() else {
                return
            }
            
            data.append(convertImageData(convertedImage,
                                         fileName: "inho.png",
                                         mimeType: "image/png"))
        }
        
        data.appendString("\r\n--\(boundary)--\r\n")
        
        return data
    }
    
    func convertImageData(_ image: Data, fileName: String, mimeType: String) -> Data {
        var data = Data()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(image)
        data.appendString("\r\n")
        
        return data
    }
}

extension Data {
    mutating func appendString(_ input: String) {
        if let input = input.data(using: .utf8) {
            self.append(input)
        }
    }
}
