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

    private let networkHandler = NetworkHandler()
    private var hasNext = true
    private var pageNumber = 1
    
    private var items: [Item] = [] {
        didSet {
            DispatchQueue.main.async {
                self.openMarketCollectionView.reloadData()
            }
        }
    }
    
    private enum CellType: Int {
        case list = 0
        case grid = 1
    }
    
    private var cellType: CellType = .list {
        didSet {
            changeCellType()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openMarketCollectionView.dataSource = self
        openMarketCollectionView.prefetchDataSource = self
        registCell()
        getItemPage()
        setListLayout()
    }
    
    private func registCell() {
        openMarketCollectionView.register(UINib(nibName: "\(ListCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(ListCell.self)")
        openMarketCollectionView.register(UINib(nibName: "\(GridCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(GridCell.self)")
    }
    
    private func getItemPage() {
        let itemPageAPI = ItemPageAPI(pageNumber: pageNumber, itemPerPage: 20)
        networkHandler.request(api: itemPageAPI) { data in
            switch data {
            case .success(let data):
                guard let itemPage = try? DataDecoder.decode(data: data, dataType: ItemPage.self) else { return }
                self.items.append(contentsOf: itemPage.items)
                self.hasNext = itemPage.hasNext
            case .failure(_):
                let alert = UIAlertController(title: "데이터로드 실패", message: "재시도 하시겠습니까?", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "확인", style: .default) {_ in
                    self.getItemPage()
                }
                let noAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
                alert.addAction(noAction)
                alert.addAction(yesAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func getImage(itemCell: ItemCellable ,url: String, indexPath: IndexPath) {
        if let cachedImage = ImageCacheManager.shared.object(forKey: url as NSString) {
            DispatchQueue.main.async {
                if self.openMarketCollectionView.indexPath(for: itemCell) == indexPath {
                    itemCell.configureImage(image: cachedImage)
                }
            }
            return
        }
        
        networkHandler.request(api: ItemImageAPI(host: url)) { data in
            switch data {
            case .success(let data):
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    if self.openMarketCollectionView.indexPath(for: itemCell) == indexPath {
                        itemCell.configureImage(image: image)
                        ImageCacheManager.shared.setObject(image, forKey: url as NSString)
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    if self.openMarketCollectionView.indexPath(for: itemCell) == indexPath {
                        guard let failImage = UIImage(systemName: "xmark.app") else { return }
                        itemCell.configureImage(image: failImage)
                    }
                }
            }
        }
    }
    
    private func changeCellType() {
        if cellType == .list {
            myActivityIndicator.isHidden = false
            myActivityIndicator.startAnimating()
            setListLayout()
            openMarketCollectionView.setListPosition()
        } else {
            myActivityIndicator.isHidden = false
            myActivityIndicator.startAnimating()
            setGridLayout()
            openMarketCollectionView.setGirdPosition()
        }
        openMarketCollectionView.reloadData()
    }
    
    private func setCellComponents(itemCell: ItemCellable, indexPath: IndexPath) {
        let name = self.items[indexPath.row].name
        let price = (self.items[indexPath.row].currency + String(self.items[indexPath.row].price)).strikethrough()
        let isDiscounted = self.items[indexPath.row].discountedPrice == 0 ? false : true
        let bargainPrice = self.items[indexPath.row].currency + String(self.items[indexPath.row].bargainPrice)
        let stock = self.items[indexPath.row].stock == 0 ? "품절" : "잔여수량 : \(self.items[indexPath.row].stock)"
        let stockLabel = self.items[indexPath.row].stock == 0 ?  #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1) : #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        
        let cellComponents = CellComponents(name: name, price: price, isDiscounted: isDiscounted, bargainPrice: bargainPrice, stock: stock, stockLabelColor: stockLabel)
        
        let thumnailURL = self.items[indexPath.row].thumbnail
        self.getImage(itemCell: itemCell, url: thumnailURL, indexPath: indexPath)
        
        DispatchQueue.main.async {
            if self.openMarketCollectionView.indexPath(for: itemCell) == indexPath {
                itemCell.configureCell(components: cellComponents)
            }
            self.myActivityIndicator.stopAnimating()
        }
    }
    
    @IBAction private func changeLayoutSegment(_ sender: UISegmentedControl) {
        guard let segmentType = CellType(rawValue: sender.selectedSegmentIndex) else { return }
        cellType = segmentType
    }
}
// MARK: - CollectionView Cell
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if cellType == .list {
            guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier:  "\(ListCell.self)", for: indexPath) as? ListCell else { return ListCell() }
            setCellComponents(itemCell: listCell, indexPath: indexPath)
            return listCell
        } else {
            guard let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GridCell.self)", for: indexPath) as? GridCell else { return GridCell() }
            setCellComponents(itemCell: gridCell, indexPath: indexPath)
            return gridCell
        }
    }
}

// MARK: - CollectionView Prefetching
extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard hasNext else {
            return
        }
        
        if indexPaths.last?.row == items.count - 1 {
          pageNumber += 1
          getItemPage()
        }
    }
}

// MARK: - CollectionView Layout
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
