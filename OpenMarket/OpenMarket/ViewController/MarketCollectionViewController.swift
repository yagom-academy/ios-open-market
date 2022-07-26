//
//  File.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/15.
//

import UIKit

final class MarketCollectionViewController: UICollectionViewController {
    // MARK: Inner types
    enum Section: Hashable {
        case main
    }
    
    // MARK: Typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Item>
    
    // MARK: Properties
    lazy var dataSource = makeListDataSource()
    private var items: [Item] = []
    private let sessionManager = URLSessionManager(session: URLSession.shared)
    
    // MARK: UI
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UIKit.UISegmentedControl(items: ["LIST", "GRID"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.systemBlue], for: .normal)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.borderColor = UIColor.systemBlue.cgColor
        segmentedControl.layer.borderWidth = 1.0
        return segmentedControl
    }()
    
    private let barbutton: UIBarButtonItem = {
        let addButton = UIBarButtonItem()
        addButton.image = UIImage(systemName: "plus")
        return addButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        sessionManager.postData { result in
            switch result {
            case .success(let data):
                print("성공!")
            case .failure(_):
                self.showAlert(title: "서버 통신 실패", message: "데이터를 받아오지 못했습니다.")
            }
        }
        receivePageData()
        addAction()
    }
    
    private func configureUI() {
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = barbutton
        collectionView.collectionViewLayout = createListLayout()
    }
    
    private func addAction() {
        segmentedControl.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
    }
    
    @objc private func indexChanged(segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            collectionView.collectionViewLayout = createListLayout()
            dataSource = makeListDataSource()
            receivePageData()
        } else {
            collectionView.collectionViewLayout = createGridLayout()
            dataSource = makeGridDataSource()
            receivePageData()
        }
    }
    
    // MARK: DataSource
    private func makeListDataSource() -> DataSource {
        let registration = UICollectionView.CellRegistration<MarketListCollectionViewCell, Item>.init { cell, indexPath, item in
            cell.configureCell(with: item)
        }
        
        return DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
        }
    }
    
    private func makeGridDataSource() -> DataSource {
        let registration = UICollectionView.CellRegistration<MarketGridCollectionViewCell, Item>.init { cell, indexPath, item in
            cell.configureCell(with: item)
        }
        
        return DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: item)
        }
    }
    
    // MARK: Data & Snapshot
    private func applySnapshots() {
        var itemSnapshot = SnapShot()
        itemSnapshot.appendSections([.main])
        itemSnapshot.appendItems(items)
        dataSource.apply(itemSnapshot, animatingDifferences: false)
    }
    
    private func receivePageData() {
        let subURL = SubURL().pageURL(number: 1, countOfItems: 20)
        
        LoadingIndicator.showLoading(on: view)
        sessionManager.receiveData(baseURL: subURL) { result in
            switch result {
            case .success(let data):
                self.decodeResult(data)
                
                DispatchQueue.main.async {
                    self.applySnapshots()
                    LoadingIndicator.hideLoading(on: self.view)
                }
            case .failure(_):
                self.showAlert(title: "서버 통신 실패", message: "데이터를 받아오지 못했습니다.")
            }
        }
    }
    
    private func decodeResult(_ data: Data) {
        do {
            let page = try DataDecoder().decode(type: Page.self, data: data)
            
            self.items = page.pages.map {
                Item(product: $0 )
            }
        } catch {
            self.showAlert(title: "데이터 변환 실패", message: "가져온 데이터를 읽을 수 없습니다.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        let failureAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        failureAlert.addAction(UIAlertAction(title: "확인", style: .default))
        present(failureAlert, animated: true)
    }
    
    // MARK: Layout
    private func createListLayout() -> UICollectionViewLayout {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        
        let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.08))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize,
                                                       subitem: item,
                                                       count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 1
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let groupsize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.35))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupsize,
                                                       subitem: item,
                                                       count: 2)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
