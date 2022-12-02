//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

enum Section: Hashable {
    case main
}

final class MainViewController: UIViewController {
    private let segmentedControl: UISegmentedControl = {
        let item = ["LIST", "GRID"]
        let segmentedControl = UISegmentedControl(items: item)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private let networkManager = NetworkManager()
    private var gridCollectionView: GridUICollectionView!
    private var listCollectionView: ListUICollectionView!
    
    private var itemList: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureCollectionView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        configureFetchItemList()
    }
}

extension MainViewController {
    // MARK: - View Layout & Constraints
    private func createListLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureCollectionView() {
        self.listCollectionView = ListUICollectionView(frame: self.view.bounds, collectionViewLayout: createListLayout())
        self.gridCollectionView = GridUICollectionView(frame: self.view.bounds, collectionViewLayout: createGridLayout())
        self.view.addSubview(self.listCollectionView)
        self.view.addSubview(self.gridCollectionView)
        
        showCollectionType(segmentIndex: self.segmentedControl.selectedSegmentIndex)

        self.listCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.gridCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.listCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.listCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.listCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.listCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),

            self.gridCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.gridCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.gridCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.gridCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
extension MainViewController {
    // MARK: - Private Method
    @objc private func addItem() {
        let itemAddVC = ItemAddViewController()
        let itemAddNavVC = UINavigationController(rootViewController: itemAddVC)
        itemAddNavVC.modalPresentationStyle = .fullScreen
        itemAddNavVC.modalTransitionStyle = .crossDissolve
        present(itemAddNavVC, animated: true)
    }
    
    @objc private func changeItemView(_ sender: UISegmentedControl) {
        showCollectionType(segmentIndex: sender.selectedSegmentIndex)
    }
    
    private func showCollectionType(segmentIndex: Int) {
        if segmentIndex == 0 {
            self.gridCollectionView.isHidden = true
            self.listCollectionView.isHidden = false
        } else {
            self.listCollectionView.isHidden = true
            self.gridCollectionView.isHidden = false
        }
    }

    private func configureNavigation() {
        self.navigationItem.titleView = segmentedControl
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        self.segmentedControl.addTarget(self, action: #selector(changeItemView(_:)), for: .valueChanged)
    }
    
    private func configureFetchItemList() {
        LoadingController.showLoading()
        networkManager.fetchItemList(pageNo: 1, pageCount: 100) { result in
            switch result {
            case .success(let success):
                LoadingController.hideLoading()
                self.itemList = success.pages
                DispatchQueue.main.async {
                    self.gridCollectionView.configureGridDataSource(self.itemList)
                    self.listCollectionView.configureListDataSource(self.itemList)
                }
            case .failure(_):
                LoadingController.hideLoading()
                self.configureFetchItemList()
            }
        }
    }
}
