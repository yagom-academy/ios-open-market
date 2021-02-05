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
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.style = .large
        return view
    }()
    
    // MARK: - data
    private var isPagingLoading = false
    private var hasNextPage = true
    private var page: UInt = 1
    private var goodsList: [Goods]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNotification()
        setUpLoadingIndicator()
        appendMarketGoodsList(with: page)
        setUpCollectionViewLayouts()
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
                if self.goodsList == nil {
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                    }
                }
                self.addGoodsListData(data.list)
                self.isPagingLoading = false
                self.reloadCollectionView(isMoveTop: false)
            }
        }
    }
    
    private func addGoodsListData(_ data: [Goods]) {
        if goodsList == nil {
            goodsList = data
        } else {
            goodsList?.append(contentsOf: data)
        }
    }
    
    // MARK: - setUp CollectionView
    private func setUpCollection() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: String(describing: GoodsGridCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "gridCell")
        collectionView.register(UINib(nibName: String(describing: GoodsListCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "listCell")
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
        return goodsList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let layoutType = SegmentValueTypes(rawValue: self.segment.selectedSegmentIndex),
              let goodsList = self.goodsList else {
            return UICollectionViewCell()
        }
        var marketCell: MarketCell
        switch layoutType {
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as? GoodsListCollectionViewCell else {
                return UICollectionViewCell()
            }
            marketCell = cell
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as? GoodsGridCollectionViewCell else {
                return UICollectionViewCell()
            }
            marketCell = cell
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
