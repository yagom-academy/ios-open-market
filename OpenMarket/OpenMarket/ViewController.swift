//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    // MARK: - UI Properties
    enum SegmentValueTypes: Int, CaseIterable {
        case list = 0
        case grid
        
        var valueString: String {
            switch self {
            case .list:
                return "List"
            case .grid:
                return "Grid"
            }
        }
    }
    private lazy var collectionViewLayouts: [UICollectionViewFlowLayout] = []
    
    // MARK: - data
    private var page = 1
    private var goodsList: [Goods] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMarketGoodsList(with: UInt(page))
        setUpCollectionViewLayouts()
        setUpCollection()
        setUpSegment()
    }
    
    private func getMarketGoodsList(with page: UInt) {
        MarketGoodsListModel.fetchMarketGoodsList(page: page) { result in
            switch result {
            case .failure(let error):
                self.showErrorAlert(with: error, okHandler: nil)
            case .success(let data):
                self.goodsList.append(contentsOf: data.list)
                self.reloadCollectionView()
            }
        }
    }
    
    // MARK: - setUp CollectionView
    private func setUpCollectionViewLayouts() {
        for valueType in SegmentValueTypes.allCases {
            switch valueType {
            case .list:
                collectionViewLayouts.append(makeListCollectionViewLayout())
            case .grid:
                collectionViewLayouts.append(makeGridCollectionViewLayout())
            }
        }
    }
    
    private func makeListCollectionViewLayout() -> UICollectionViewFlowLayout {
        // TODO: Lasagna - add CollectionView List Type Layout
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 90)
        return layout
    }
    
    private func makeGridCollectionViewLayout() -> UICollectionViewFlowLayout {
        // TODO: Joons - add CollectionView Grid Type Layout
        // This is test layout code
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width / 2 - 30, height: 90)
        return layout
    }
    
    private func setUpCollection() {
        collectionView.dataSource = self
        // test cell, will delete
        collectionView.register(UINib(nibName: "TestCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        // TODO: Lasagna - CollectionView List Type cell regist
        // TODO: Joons - CollectionView Grid Type cell Regist
    }
    
    // MARK: - setUp Segment
    private func setUpSegment() {
        for (index, element) in SegmentValueTypes.allCases.enumerated() {
            segment.setTitle(element.valueString, forSegmentAt: index)
        }
        segment.addTarget(self, action: #selector(changedSegmentValue(_:)), for: .valueChanged)
        reloadCollectionView()
    }
    
    @objc func changedSegmentValue(_ sender: UISegmentedControl) {
        reloadCollectionView()
    }
    
    private func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout = self.collectionViewLayouts[self.segment.selectedSegmentIndex]
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        // TODO: add logic in step3
        print("➕")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.goodsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TestCollectionViewCell
        return cell
    }
}

/* 이미지 불러올때 예시
 guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TestTableViewCell else {
     return UITableViewCell()
 }
 let token = ImageLoader.shared.load(urlString: self.testArray[indexPath.row % 3]) { result in
     switch result {
     case .failure(let error):
         debugPrint("❌:\(error.localizedDescription)")
     case .success(let image):
         DispatchQueue.main.async {
             if let index: IndexPath = tableView.indexPath(for: cell) {
                 if index.row == indexPath.row {
                     cell.testImage.image = image
                 }
             }
         }
     }
 }
 cell.onReuse = {
     if let token = token {
         ImageLoader.shared.cancelLoad(token)
     }
 }
 */
