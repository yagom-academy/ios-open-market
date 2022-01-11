//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
// 🤞
final class MarketViewController: UIViewController {
    
    //MARK: - Nested Type
    
    private enum PresentationMode {
        case list
        case grid
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    
    let apiService = MarketAPIService()
    var products: [Product] = [] {
        didSet {
            reloadData()
        }
    }
    private var presentationMode: PresentationMode = .list
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        configureCollectionViewList()
        fetchPage()
        setupCollectionViewCells()
    }
    
    //MARK: - IBActions
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        reloadCurrentCells()
        if sender.selectedSegmentIndex == 0 {
            configureCollectionViewList()
            presentationMode = .list
        } else {
            configureCollectionViewGrid()
            presentationMode = .grid
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
        let gridNib = UINib(nibName: "GridCell", bundle: .main)
        collectionView.register(listNib, forCellWithReuseIdentifier: "listCell")
        collectionView.register(gridNib, forCellWithReuseIdentifier: "gridCell")
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func reloadCurrentCells() {
        DispatchQueue.main.async {
            let currentIndexPaths = self.collectionView.indexPathsForVisibleItems
            self.collectionView.reloadItems(at: currentIndexPaths)
        }
    }
}

extension MarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch presentationMode {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as? ListCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: products[indexPath.row])
            return cell
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as? GridCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: products[indexPath.row])
            return cell
        }
    }
}

extension MarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 10
        let height = collectionView.frame.height / 3 - 10
        let size = CGSize(width: width, height: height)
        
        return size
    }
}
