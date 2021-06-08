//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    private var layoutType = LayoutType.list
    private let networkManager: NetworkManageable = NetworkManager()
    private var isPageRefreshing: Bool = false
    private var nextPageToLoad: Int = 1
    private var openMarketItemList: OpenMarketItemList?
    
    lazy private var openMarketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setUpCollectionViewLayout())
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
        setUpCollectionViewConstraint()
        networkManager.getItemList(page: nextPageToLoad, isCurrentlyLoading: false) { [weak self] result in
            switch result {
            case .success(let itemList):
                self?.openMarketItemList = itemList
                DispatchQueue.main.async {
                    self?.openMarketCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentedController.addTarget(self, action: #selector(didTapSegmentedControl(_:)), for: .valueChanged)
        }
    
    private func setUpCollectionView() {
        self.view.addSubview(openMarketCollectionView)
        self.navigationItem.titleView = segmentedController

    }
    
    private func setUpCollectionViewConstraint() {
        self.view.backgroundColor = .white

        let margins = view.safeAreaLayoutGuide
        openMarketCollectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        openMarketCollectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        openMarketCollectionView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        openMarketCollectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    private func setUpCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width)
        let height = (UIScreen.main.bounds.height)

        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: width, height: height)
        return layout
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
extension OpenMarketViewController: UICollectionViewDelegate {

}
extension OpenMarketViewController: UICollectionViewDataSource {
    
    // MARK: - Cell Data
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let validItemList = openMarketItemList else { return 0}
        return validItemList.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch layoutType {
        case .list:
            guard let cell: OpenMarketListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenMarketListCollectionViewCell.identifier, for: indexPath) as? OpenMarketListCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(openMarketItemList, indexPath: indexPath.row)
            nextPageToLoad += 1
            return cell
            
        case .grid:
            guard let cell: OpenMarketGridCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: OpenMarketGridCollectionViewCell.identifier, for: indexPath) as? OpenMarketGridCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(openMarketItemList, indexPath: indexPath.row)
            nextPageToLoad += 1
            return cell
        }
    }
}
extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - Cell Size
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch layoutType {
        case .list:
            let cellWidth = collectionView.bounds.width
            let cellHeight = collectionView.bounds.height / 12
            return CGSize(width: cellWidth, height: cellHeight)
        case .grid:
            let cellWidth = collectionView.bounds.width / 2
            let cellHeight = collectionView.bounds.height / 3
            return CGSize(width: cellWidth, height: cellHeight)
        }
        
    }
}
