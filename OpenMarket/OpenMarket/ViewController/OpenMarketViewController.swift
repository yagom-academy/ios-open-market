//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    private var layoutType = OpenMarketCellLayoutType.list
    private var networkManager: NetworkManageable = NetworkManager()
    private var isPageRefreshing: Bool = false
    private var nextPageToLoad: Int = 1
    private var openMarketItems: [OpenMarketItem] = []
    
    // MARK: - Views
    
    private lazy var openMarketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.register(OpenMarketListCollectionViewCell.self, forCellWithReuseIdentifier: OpenMarketListCollectionViewCell.identifier)
        collectionView.register(OpenMarketGridCollectionViewCell.self, forCellWithReuseIdentifier: OpenMarketGridCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var segmentedController: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentedControl.sizeToFit()
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        configureCollectionViewConstraint()
        fetchOpenMarketItems()
        segmentedController.addTarget(self, action: #selector(didTapSegmentedControl(_:)), for: .valueChanged)
    }
    
    // MARK: - Setup CollectionView
    
    private func setUpCollectionView() {
        self.view.addSubview(openMarketCollectionView)
        self.navigationItem.titleView = segmentedController
        
    }
    
    private func configureCollectionViewConstraint() {
        self.view.backgroundColor = .white
        
        let margins = view.safeAreaLayoutGuide
        openMarketCollectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        openMarketCollectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        openMarketCollectionView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        openMarketCollectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width)
        let height = (UIScreen.main.bounds.height)
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }
    
    // MARK: - Initial Data fetching
    
    private func fetchOpenMarketItems() {
        networkManager.getItemList(page: 1, loadingFinished: false) { [weak self] result in
            switch result {
            case .success(let itemList):
                self?.openMarketItems.append(contentsOf: itemList.items)
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.openMarketCollectionView.reloadData()
                    self.networkManager.isReadyToPaginate = true
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
extension OpenMarketViewController {
    
    // MARK: - Segmented Control
    
    @objc private func didTapSegmentedControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            layoutType = .list
            sender.tintColor = .gray
            self.openMarketCollectionView.reloadData()
        } else {
            layoutType = .grid
            sender.tintColor = .gray
            self.openMarketCollectionView.reloadData()
        }
    }
}
extension OpenMarketViewController: UICollectionViewDataSource {
    
    // MARK: - Cell Data
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return openMarketItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layoutType {
        case .list:
            guard let cell: OpenMarketListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenMarketListCollectionViewCell.identifier, for: indexPath) as? OpenMarketListCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(openMarketItems, indexPath: indexPath.row)
            return cell
            
        case .grid:
            guard let cell: OpenMarketGridCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenMarketGridCollectionViewCell.identifier, for: indexPath) as? OpenMarketGridCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(openMarketItems, indexPath: indexPath.row)
            return cell
        }
    }
}
extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Cell Size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch layoutType {
        case .list:
            let cellWidth = collectionView.frame.width
            let cellHeight = collectionView.frame.height / 12
            return CGSize(width: cellWidth, height: cellHeight)
        case .grid:
            let cellWidth = collectionView.bounds.width / 2
            let cellHeight = collectionView.bounds.height / 3
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
    }
}
extension OpenMarketViewController: UIScrollViewDelegate {
    
    // MARK: - Fetch additional Data
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if (position > (scrollView.contentSize.height - 100 - scrollView.frame.size.height)) {
            
            guard  networkManager.isReadyToPaginate == true else { return }
            
            nextPageToLoad += 1
            fetchAdditionalData()
        }
    }
    
    private func fetchAdditionalData() {
        networkManager.getItemList(page: nextPageToLoad, loadingFinished: true) { [weak self] result in
            switch result {
            case .success(let additionalItemList):
                
                guard let self = self else { return }
                
                let range = self.openMarketItems.count..<additionalItemList.items.count + self.openMarketItems.count
                self.openMarketItems.append(contentsOf: additionalItemList.items)
                DispatchQueue.main.async {
                    self.openMarketCollectionView.performBatchUpdates({
                        for item in range {
                            let indexPath = IndexPath(row: item, section: 0)
                            self.openMarketCollectionView.insertItems(at: [indexPath])
                        }
                    }, completion: nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
