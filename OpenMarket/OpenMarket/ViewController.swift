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
    private let listCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 81)
        layout.minimumLineSpacing = 0
        return layout
    }()
    private let gridCollectionViewLayout: UICollectionViewFlowLayout = {
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
    }()
    private lazy var collectionViewLayouts: [UICollectionViewFlowLayout] = [listCollectionViewLayout, gridCollectionViewLayout]
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        return view
    }()
    
    // MARK: - data
    private var isPagingLoading = false
    private var hasNextPage = true
    private var page: UInt = 1
    private var goodsList: [Goods] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNotification()
        setUpLoadingIndicator()
        appendMarketGoodsList(with: page)
        setUpCollection()
        setUpSegment()
    }
    
    // MARK: - setUp Notification
    private func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(manageFailureImageLoad(_:)), name: .failureImageLoad, object: nil)
    }
    
    @objc func manageFailureImageLoad(_ notification: Notification) {
        guard let error = notification.object as? Error else {
            return
        }
        self.showErrorAlert(with: error, okHandler: nil)
    }
    
    private func setUpLoadingIndicator() {
        self.view.addSubview(loadingIndicator)
        loadingIndicator.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        loadingIndicator.startAnimating()
    }
    
    // MARK: - add data
    private func appendMarketGoodsList(with page: UInt) {
        MarketGoodsListNetworkModel.fetchMarketGoodsList(page: page) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(with: error, okHandler: nil)
                }
            case .success(let data):
                if data.list.isEmpty {
                    self.hasNextPage = false
                }
                if self.goodsList.isEmpty {
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                    }
                }
                self.reloadCollectionView(with: data.list)
            }
        }
    }
    
    private func reloadCollectionView(with appendGoods: [Goods]) {
        let startAppendIndex = self.goodsList.count
        var insertIndexPaths: [IndexPath] = []
        for (index, _) in appendGoods.enumerated() {
            insertIndexPaths.append(IndexPath(row: startAppendIndex + index, section: 0))
        }
        self.goodsList.append(contentsOf: appendGoods)
        self.isPagingLoading = false
        DispatchQueue.main.async {
            self.collectionView.insertItems(at: insertIndexPaths)
        }
    }
    
    // MARK: - setUp CollectionView
    private func setUpCollection() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: String(describing: GoodsGridCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "gridCell")
        collectionView.register(UINib(nibName: String(describing: GoodsListCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "listCell")
    }
    
    // MARK: - setUp Segment
    private func setUpSegment() {
        for (index, element) in SegmentValueTypes.allCases.enumerated() {
            segment.setTitle(element.valueString, forSegmentAt: index)
        }
        segment.addTarget(self, action: #selector(changedSegmentValue(_:)), for: .valueChanged)
        reloadAllCollectionView()
    }
    
    @objc func changedSegmentValue(_ sender: UISegmentedControl) {
        reloadAllCollectionView()
    }
    
    private func reloadAllCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout = self.collectionViewLayouts[self.segment.selectedSegmentIndex]
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
    
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        // TODO: add logic in step3
        print("➕")
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let layoutType = SegmentValueTypes(rawValue: self.segment.selectedSegmentIndex) else {
            return UICollectionViewCell()
        }
        guard let marketCell: MarketCell = collectionView.dequeueReusableCell(withReuseIdentifier: layoutType == .list ? "listCell" : "gridCell", for: indexPath) as? MarketCell else {
            return UICollectionViewCell()
        }
        marketCell.configure(goodsList[indexPath.row], isLast: indexPath.row == goodsList.count - 1)
        return marketCell
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) {
            if isPagingLoading == false && hasNextPage {
                self.isPagingLoading = true
                self.page = self.page + 1
                self.appendMarketGoodsList(with: self.page)
            }
        }
    }
}
