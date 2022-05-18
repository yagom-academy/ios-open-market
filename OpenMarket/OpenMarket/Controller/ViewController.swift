//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var openMarketCollectionView: UICollectionView!
    @IBOutlet private weak var collectionViewSegment: UISegmentedControl!
    private let listCellName = String(describing: ListCell.self)
    private let gridCellName = String(describing: GridCell.self)
    let itemPageAPI = ItemPageAPI(pageNumber: 1, itemPerPage: 100)
    
    private let networkHandler = NetworkHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registCell()
        setListLayout()
        openMarketCollectionView.dataSource = self
    }
    
    private func registCell() {
        openMarketCollectionView.register(UINib(nibName: listCellName, bundle: nil), forCellWithReuseIdentifier: listCellName)
        openMarketCollectionView.register(UINib(nibName: gridCellName, bundle: nil), forCellWithReuseIdentifier: gridCellName)
    }
    
    @IBAction private func changeLayoutSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            setListLayout()
        } else {
            setGridLayout()
        }
        openMarketCollectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionViewSegment.selectedSegmentIndex == 0 {
            guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier:  listCellName, for: indexPath) as? ListCell else { return ListCell() }
            networkHandler.request(api: itemPageAPI) { data in
                switch data {
                case .success(let data):
                        guard let itemPage = try? DataDecoder.decode(data: data, dataType: ItemPage.self) else { return }
                        DispatchQueue.main.async {
                            listCell.itemNameLabel.text = itemPage.items[indexPath.row].name
                            if itemPage.items[indexPath.row].price == itemPage.items[indexPath.row].bargainPrice {
                                listCell.priceLabel.isHidden = true
                            } else {
                                listCell.priceLabel.isHidden = false
                            }
                            listCell.priceLabel.text = itemPage.items[indexPath.row].currency + itemPage.items[indexPath.row].price.description
                            listCell.bargainPriceLabel.text = itemPage.items[indexPath.row].currency + itemPage.items[indexPath.row].bargainPrice.description
                            listCell.stockLabel.text = "잔여수량 : " + itemPage.items[indexPath.row].stock.description
                        }
                case .failure(_):
                    break
                }
            }
            return listCell
        } else {
            guard let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: gridCellName, for: indexPath) as? GridCell else { return GridCell() }
            networkHandler.request(api: itemPageAPI) { data in
                switch data {
                case .success(let data):
                        guard let itemPage = try? DataDecoder.decode(data: data, dataType: ItemPage.self) else { return }
                        DispatchQueue.main.async {
                            gridCell.itemNameLabel.text = itemPage.items[indexPath.row].name
                            if itemPage.items[indexPath.row].price == itemPage.items[indexPath.row].bargainPrice {
                                gridCell.priceLabel.isHidden = true
                            } else {
                                gridCell.priceLabel.isHidden = false
                            }
                            gridCell.priceLabel.text = itemPage.items[indexPath.row].currency + itemPage.items[indexPath.row].price.description
                            gridCell.bargainPriceLabel.text = itemPage.items[indexPath.row].currency + itemPage.items[indexPath.row].bargainPrice.description
                            gridCell.stockLabel.text = "잔여수량 : " + itemPage.items[indexPath.row].stock.description
                        }
                case .failure(_):
                    break
                }
            }
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
