//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

@available(iOS 14.0, *)
class ViewController: UIViewController {
    @IBOutlet weak var viewModeSegmentedControl: UISegmentedControl!
    
    enum Section {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "ListCollectionViewCell", bundle: nil)
        configureHierarchy()
        configureDataSource()
        collectionView.register(nibName, forCellWithReuseIdentifier: "ListCollectionViewCell")
    }
}

@available(iOS 14.0, *)
extension ViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

@available(iOS 14.0, *)
extension ViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
        
            DispatchQueue.main.async {
                cell.thumbnailImageView.image = .checkmark
                cell.titleLabel.text = item.title
                cell.priceLabel.text = item.currency! + " \(item.price!)"
                cell.discountedPriceLabel.text = item.currency! + " \(item.discountedPrice)"
                cell.stockLabel.text = "잔여수량 : " + "\(item.stock!)"
            }
            
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        let networkManager = NetworkManager(.shared)
        networkManager.request(ItemList.self, url: OpenMarketURL.viewItemList(1).url) { result in
            switch result {
            case .success(let itemList):
                snapshot.appendItems(itemList.items)
                self.dataSource.apply(snapshot, animatingDifferences: false)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
