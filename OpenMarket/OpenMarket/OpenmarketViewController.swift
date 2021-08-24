//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenmarketViewController: UIViewController {
    @IBOutlet private var openmarketCollectionView: UICollectionView!
    var item: [Item] = []
    var page: Int = 1
    let networkHandler = NetworkHandler(session: URLSession.shared)
    let cellIdentifier = "openmarketCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openmarketCollectionView.delegate = self
        openmarketCollectionView.dataSource = self
        openmarketCollectionView.prefetchDataSource = self
        self.openmarketCollectionView.collectionViewLayout = configureFlowLayout()
        requestNextPage()
    }
    
    func requestNextPage() {
        networkHandler.request(api: .getItemCollection(page: page)) { result in
            switch result {
            case .success(let data):
                guard let model = try? JsonHandler().decodeJSONData(json: data, model: ItemCollection.self) else { return }
                self.item.append(contentsOf: model.items)
                self.page += 1
                DispatchQueue.main.async {
                    self.openmarketCollectionView.reloadData()
                }
            default:
                break
            }
        }
    }
}

extension OpenmarketViewController: UICollectionViewDelegate {
    func configureFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let halfScreenWidth: CGFloat = UIScreen.main.bounds.width / 2.0
        let oneThirdScreenHeight: CGFloat = UIScreen.main.bounds.height / 3.0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.itemSize.width = halfScreenWidth - 15
        flowLayout.itemSize.height = oneThirdScreenHeight + 10
        return flowLayout
    }
}

extension OpenmarketViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let remainItem = item.count - 1
        for indexPath in indexPaths {
            if remainItem == indexPath.item {
                requestNextPage()
            }
        }
    }
}

extension OpenmarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: OpenmarketItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? OpenmarketItemCell else { fatalError() }
        cell.setUpLabels(item: item, indexPath: indexPath)
        cell.setUpImages(url: item[indexPath.item].thumbnails[0])
        cell.configureCellStyle()
        return cell
    }
}

class OpenmarketItemCell: UICollectionViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func prepareForReuse() {
        itemImage.image = nil
        titleLabel.text = nil
        discountedPriceLabel.text = nil
        priceLabel.attributedText = nil
        priceLabel.textColor = .gray
        stockLabel.text = nil
        stockLabel.textColor = .gray
    }
    
    func setUpLabels(item: [Item], indexPath: IndexPath) {
        titleLabel.textColor = .black
        priceLabel.textColor = .gray
        discountedPriceLabel.textColor = .gray
        stockLabel.textColor = .gray
        
        let item = item[indexPath.item]
        titleLabel.text = item.title
        priceLabel.text = "\(item.currency) \(item.price)"
        stockLabel.text = "\(item.stock)"
        
        if let discountedPrice = item.discountedPrice {
            let attributedString = NSMutableAttributedString(string: "\(item.currency) \(item.price)")
            attributedString.addAttribute(.baselineOffset, value: 0, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attributedString.length))
            discountedPriceLabel.text = "\(item.currency) \(discountedPrice)"
            priceLabel.attributedText = attributedString
            priceLabel.textColor = .red
        } else {
            discountedPriceLabel.text = ""
        }
        
        if item.stock == 0 {
            stockLabel.text = "품절"
            stockLabel.textColor = .orange
        } else {
            stockLabel.text = "잔여수량 : \(item.stock)"
        }
    }
    
    func setUpImages(url: String) {
        ImageLoader(imageUrl: url).loadImage { image in
            DispatchQueue.main.async {
                self.itemImage.image = image
            }
        }
    }
    
    func configureCellStyle() {
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.systemGray5.cgColor
    }
}
