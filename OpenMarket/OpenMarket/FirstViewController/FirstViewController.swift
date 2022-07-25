//
//  FirstViewController.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/19.
//

import UIKit

final class FirstViewController: UIViewController {
    @IBOutlet weak var productCollectionView: UICollectionView!
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
    private let itemPage = "items_per_page=20"
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
        URLSemaphore.wait()
        self.productCollectionView.reloadData()
    }
}

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let result = productData else { return 0 }
        return result.itemsPerPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FirstCollectionViewCell
        
        cell.accessories = [.disclosureIndicator()]
        cell.fetchData(data: productData, index: indexPath.row)
        
        return cell
    }
}
