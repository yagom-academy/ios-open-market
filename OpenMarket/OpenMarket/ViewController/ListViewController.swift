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
    private var productData: ProductListResponse?
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityIndicator)
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        self.fetchUICollectionViewConfiguration()
        self.initRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.activityIndicator.startAnimating()
        self.fetchData()
        self.activityIndicator.stopAnimating()
    }
    
    @objc func refreshTable(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchData()
            refresh.endRefreshing()
        }
    }
    
    private func initRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        productCollectionView.refreshControl = refreshControl
    }
    
    private func fetchUICollectionViewConfiguration() {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        productCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func fetchData() {
        jsonParser.dataTask(by: (URLCollection.hostURL + URLCollection.productList(pageNumber: 1, itemsPerPage: 100).string), completion: { (response) in
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
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let result = productData else {
            return 0
        }
        return result.itemsPerPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.reuseIdentifier, for: indexPath) as! ListCollectionViewCell
        
        cell.accessories = [.disclosureIndicator()]
        cell.fetchData(data: productData, index: indexPath.row)
        
        return cell
    }
}
