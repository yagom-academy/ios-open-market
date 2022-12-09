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
    // MARK: - Private Property
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureCollectionView()
        
        gridCollectionView.delegate = self
        listCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureFetchItemList()
    }
}

// MARK: - View Layout & Constraints
extension MainViewController {
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

// MARK: - Private Method
extension MainViewController {
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
            LoadingController.hideLoading()

            switch result {
            case .success(let success):
                self.itemList = success.pages
                DispatchQueue.main.async {
                    self.gridCollectionView.configureGridDataSource(self.itemList)
                    self.listCollectionView.configureListDataSource(self.itemList)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.retryAlert()
                }
            }
        }
    }
    
    private func retryAlert() {
        let alert = UIAlertController(title: "통신 실패", message: "데이터를 받아오지 못했습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "다시 시도", style: .default, handler: { _ in
            self.configureFetchItemList()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: { _ in
            exit(0)
        }))
        self.present(alert, animated: false)
    }
}

// MARK: - CollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemInfoVC = ItemInfomationViewController()
        itemInfoVC.itemId = (itemList[indexPath.item] as Item).id
        itemInfoVC.view.backgroundColor = .systemBackground
        self.navigationController?.pushViewController(itemInfoVC, animated: true)
    }
}
