//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
// 🤞
final class MarketViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    
    let apiService = MarketAPIService()
    var products: [Product] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        configureCollectionViewList()
        fetchPage()
        setupCollectionViewCells()
    }
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            configureCollectionViewList()
        } else {
            configureCollectionViewGrid()
        }
    }
}

//MARK: - Private Methods

extension MarketViewController {
    private func configureCollectionViewList() {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.collectionViewLayout = layout
    }
    
    private func configureCollectionViewGrid() {
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
    }
    
    private func fetchPage() {
        apiService.fetchPage(pageNumber: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                self.products = data.products
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupCollectionViewCells() {
        let listNib = UINib(nibName: "ListCell", bundle: .main)
        collectionView.register(listNib, forCellWithReuseIdentifier: "listCell")
    }
}

extension MarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCell
        
        cell.configure(with: products[indexPath.row])
        
        return cell
    }
}

