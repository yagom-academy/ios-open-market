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
    private var goodsList: [Goods]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMarketGoodsList(with: UInt(page))
        setUpCollectionViewLayouts()
        setUpCollection()
        setUpSegment()
    }
    
    private func addGoodsListData(_ data: [Goods]) {
        if goodsList == nil {
            goodsList = data
        } else {
            goodsList?.append(contentsOf: data)
        }
    }
    
    private func getMarketGoodsList(with page: UInt) {
        MarketGoodsListModel.fetchMarketGoodsList(page: page) { result in
            switch result {
            case .failure(let error):
                self.showErrorAlert(with: error, okHandler: nil)
            case .success(let data):
                self.addGoodsListData(data.list)
                self.reloadCollectionView(isMoveTop: false)
            }
        }
    }
    
    // MARK: - setUp CollectionView
    private func setUpCollection() {
        collectionView.dataSource = self
        collectionView.register(IndicatorCell.self, forCellWithReuseIdentifier: "loading")
        collectionView.register(UINib(nibName: String(describing: GoodsGridCollectionViewCell.self),
                                      bundle: nil), forCellWithReuseIdentifier: "gridCell")
        collectionView.register(UINib(nibName: "GoodsListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
    }
    
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
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 81)
        layout.minimumLineSpacing = 0
        return layout
    }
    
    private func makeGridCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let interSpacing: CGFloat = 8
        let totalSpacing = numberOfItemsPerRow * interSpacing
        let itemWidth = (screenWidth - totalSpacing) / numberOfItemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        layout.minimumInteritemSpacing = interSpacing
        return layout
    }
    
    // MARK: - setUp Segment
    private func setUpSegment() {
        for (index, element) in SegmentValueTypes.allCases.enumerated() {
            segment.setTitle(element.valueString, forSegmentAt: index)
        }
        segment.addTarget(self, action: #selector(changedSegmentValue(_:)), for: .valueChanged)
        reloadCollectionView(isMoveTop: true)
    }
    
    @objc func changedSegmentValue(_ sender: UISegmentedControl) {
        reloadCollectionView(isMoveTop: true)
    }
    
    private func reloadCollectionView(isMoveTop: Bool) {
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout = self.collectionViewLayouts[self.segment.selectedSegmentIndex]
            self.collectionView.reloadData()
            if isMoveTop {
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
    }
    
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        // TODO: add logic in step3
        print("➕")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let goodsList = self.goodsList else {
            return 1
        }
        return goodsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let layoutType = SegmentValueTypes(rawValue: self.segment.selectedSegmentIndex) else {
            return UICollectionViewCell()
        }
        guard let goodsList = self.goodsList else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loading", for: indexPath) as! IndicatorCell
            cell.indicator.startAnimating()
            return cell
        }
        
        switch layoutType {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as? GoodsListCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.settingWithGoods(goodsList[indexPath.row])
            return cell
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as? GoodsGridCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(goods: goodsList[indexPath.row])
            return cell
        }
    }
}
