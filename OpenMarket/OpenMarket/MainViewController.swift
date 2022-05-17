//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController, NetworkAble {
    
    let session: URLSessionProtocol = URLSession.shared
    var status = 0
    var pageNo = 3
    var itemsPerPage = 30
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, ProductInformation>!
    var collectionView: UICollectionView!
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["LIST", "GRID"])
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = .white
        segment.selectedSegmentTintColor = .systemBlue
        segment.layer.borderWidth = 2
        segment.layer.borderColor = UIColor.systemBlue.cgColor
        segment.addTarget(self, action: #selector(changeSegmentedControl), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.widthAnchor.constraint(equalToConstant: view.frame.size.width / 2).isActive = true
        let selectedTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)
        ]
        let releasedTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue
        ]
        segment.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segment.setTitleTextAttributes(releasedTextAttributes, for: .normal)
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        configureSegmentedControl()
        configureCollectionView()
        configureDataSource(pageNo: pageNo, itemsPerPage: itemsPerPage)
        
        self.collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        self.collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
    }
    
    private func configureSegmentedControl() {
        self.navigationItem.titleView = segmentedControl
    }
    
    @objc func changeSegmentedControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.status = 0
            collectionView.setCollectionViewLayout(creatListLayout(), animated: true)
            collectionView.reloadData()
        case 1:
            self.status = 1
            collectionView.setCollectionViewLayout(createGridLayout(), animated: true)
            collectionView.reloadData()
        default:
            return
        }
    }
    
    private func creatListLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: creatListLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func configureDataSource(pageNo: Int, itemsPerPage: Int) {
        dataSource = UICollectionViewDiffableDataSource<Section, ProductInformation>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ProductInformation) in
            switch self.status {
        case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell else { return UICollectionViewListCell() }
                cell.accessories = [.disclosureIndicator()]
                cell.configureContent(productInformation: identifier)
                return cell
        case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell else { return UICollectionViewCell() }
                cell.configureContent(productInformation: identifier)
                return cell
            default:
                return UICollectionViewCell()
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductInformation>()
        snapshot.appendSections([.main])
        
        guard let url = OpenMarketApi.pageInformation(pageNo: pageNo, itemsPerPage: itemsPerPage).url else {
            return
        }
        
        requestData(url: url) { data, urlResponse in
            guard let data = data,
                  let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
            snapshot.appendItems(pageInformation.pages)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        } errorHandler: { error in
//            print(error)
        }
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let flowLayout = UICollectionViewFlowLayout()
//        flowLayout.minimumLineSpacing = 20
//        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(
            width: view.frame.size.width / 2 - 20,
            height: view.frame.size.height / 2
        )
        return flowLayout
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}
