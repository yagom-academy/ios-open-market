//
//  CollectionViewController.swift
//  OpenMarket
//
//  Created by sole on 2021/02/04.
//

import UIKit

class CollectionViewController: UIViewController {
    
    var items = ItemsToGet(items: [], page: 1)
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OpenMarketAPI.request(.loadItemList(page: 1)) { (result: Result<ItemsToGet, Error>) in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.items = data
                    self.collectionView.reloadData()
                }
                print("1페이지에 몇갠거야? -------------------------\(data.items.count)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCell else {
            return UICollectionViewCell()
        }
        let item = items.items[indexPath.item]
        
        cell.titleLabel.text = item.title
        if let discountedPrice = item.discountedPrice {
            cell.discountedPriceLabel.text = String(discountedPrice)
        } else {
            cell.discountedPriceLabel.isHidden = true
        }
        cell.priceLabel.text = String(item.price)
        if item.stock == 0 {
            cell.stockLabel.text = "품절"
        } else {
            cell.stockLabel.text = String(item.stock)
        }
        cell.backgroundColor = .orange
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 9
        let itemSpacing: CGFloat = 9
        
        let width = (collectionView.bounds.width - margin * 2 - itemSpacing) / 2
        let height = width * 11 / 7
        
        return CGSize(width: width , height: height)
    }
}
