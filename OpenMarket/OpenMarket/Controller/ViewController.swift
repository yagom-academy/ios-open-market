//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var openMarketCollectionView: UICollectionView!
    @IBOutlet private weak var collectionViewSegment: UISegmentedControl!
    @IBOutlet private weak var myActivityIndicator: UIActivityIndicatorView!
    
    private let listCellName = String(describing: ListCell.self)
    private let gridCellName = String(describing: GridCell.self)
    private let networkHandler = NetworkHandler()
    
    private var items: [Item] = [] {
        didSet {
            DispatchQueue.main.async {
                self.openMarketCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItemPage()
        registCell()
        setListLayout()
        openMarketCollectionView.dataSource = self
    }
    
    private func registCell() {
        openMarketCollectionView.register(UINib(nibName: listCellName, bundle: nil), forCellWithReuseIdentifier: listCellName)
        openMarketCollectionView.register(UINib(nibName: gridCellName, bundle: nil), forCellWithReuseIdentifier: gridCellName)
    }
    private func getItemPage() {
        let itemPageAPI = ItemPageAPI(pageNumber: 1, itemPerPage: 20)
        networkHandler.request(api: itemPageAPI) { data in
            switch data {
            case .success(let data):
                guard let itemPage = try? DataDecoder.decode(data: data, dataType: ItemPage.self) else { return }
                self.items = itemPage.items
            case .failure(_):
                break
            }
        }
    }
    
    private func getImage(itemCell: ItemCellable ,url: String, indexPath: IndexPath) {
        guard let cell = itemCell as? UICollectionViewCell else { return }
        var itemCell = itemCell
        
        networkHandler.request(api: ItemImageAPI(host: url)) { data in
            switch data {
            case .success(let data):
                guard let imageData = data else { return }
                DispatchQueue.main.async {
                    if self.openMarketCollectionView.indexPath(for: cell) == indexPath {
                        itemCell.itemImage = UIImage(data: imageData)
                    }
                }
            case .failure(_):
                break
            }
        }
    }
    
    private func setCellComponents(itemCell: ItemCellable, indexPath: IndexPath) {
        guard let cell = itemCell as? UICollectionViewCell else { return }
    
        var itemCell = itemCell
        let thumnailURL = self.items[indexPath.row].thumbnail
        
        self.getImage(itemCell: itemCell, url: thumnailURL, indexPath: indexPath)
        
        DispatchQueue.main.async {
            if self.openMarketCollectionView.indexPath(for: cell) == indexPath {
                itemCell.itemName = self.items[indexPath.row].name
                itemCell.discountedPrice = self.items[indexPath.row].discountedPrice
                itemCell.price = self.items[indexPath.row].currency + self.items[indexPath.row].price.description
                itemCell.bargainPrice = self.items[indexPath.row].currency + self.items[indexPath.row].bargainPrice.description
                itemCell.stock = self.items[indexPath.row].stock
            }
            self.myActivityIndicator.stopAnimating()
        }
    }
    
    @IBAction private func changeLayoutSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            myActivityIndicator.isHidden = false
            myActivityIndicator.startAnimating()
            setListLayout()
        } else {
            myActivityIndicator.isHidden = false
            myActivityIndicator.startAnimating()
            setGridLayout()
        }
        openMarketCollectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionViewSegment.selectedSegmentIndex == 0 {
            guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier:  listCellName, for: indexPath) as? ListCell else { return ListCell() }
            setCellComponents(itemCell: listCell, indexPath: indexPath)
            return listCell
        } else {
            guard let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCellName, for: indexPath) as? GridCell else { return GridCell() }
            setCellComponents(itemCell: gridCell, indexPath: indexPath)
            gridCell.layer.cornerRadius = 8
            gridCell.layer.borderWidth = 1
            return gridCell
        }
    }
}

extension ViewController {
    private func setListLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(openMarketCollectionView.frame.height * 0.1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        openMarketCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
    
    private func setGridLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.7))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 7, bottom: 5, trailing: 7)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: itemSize.heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        openMarketCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
    }
}
