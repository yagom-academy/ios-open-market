//
//  ListViewController.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/19.
//

import UIKit
import Foundation

final class ListViewController: UIViewController {
    @IBOutlet private weak var productCollectionView: UICollectionView!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = self.view.center
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.isHidden = false
        return activityIndicator
    }()
    
    private let numberFormatter = NumberFormatter()
    private let jsonParser = JSONParser()
    private let URLSemaphore = DispatchSemaphore(value: 0)
    private let itemPage = "items_per_page=50"
    private var productData: ProductListResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityIndicator)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        self.fetchUICollectionViewConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.activityIndicator.startAnimating()
        self.fetchData()
        self.activityIndicator.stopAnimating()
        self.uploadData()
    }
    
    private func fetchUICollectionViewConfiguration() {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        productCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func fetchData() {
        jsonParser.dataTask(by: URLCollection.productListInquery + itemPage, completion: { (response) in
            switch response {
            case .success(let data):
                self.productData = data
                self.URLSemaphore.signal()
            case .failure(let data):
                print(data)
            }
        })
        self.URLSemaphore.wait()
        self.productCollectionView.reloadData()
    }
 
    
    func uploadData() {
        let parameters = ["name": "Test Brad", "price":15000, "stock": 1000, "currency": "KRW", "secret": "your_secret_here", "descriptions": "description here"] as [String : Any]
        let boundary = "Boundary-\(UUID().uuidString)"

        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("fa69efb9-0335-11ed-9676-1db1453669a0", forHTTPHeaderField: "identifier")
        request.addValue("multipart/form-data; boundary\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }

        request.httpBody = httpBody

        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    
                }
            }
            if let error = error {
                print(error)
            }
        }
        session.resume()
    }
    
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let result = productData else { return 0 }
        return result.itemsPerPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath) as! ListCollectionViewCell
        
        cell.accessories = [.disclosureIndicator()]
        cell.fetchData(data: productData, index: indexPath.row)
        return cell
    }
}
