//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController, NetworkAble {
    
    let session: URLSessionProtocol = URLSession.shared
    var status = 0
    var pageNo = 1
    var itemsPerPage = 10
    
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
            collectionView.reloadData()
            return print("LIST 뷰입니다.")
        case 1:
            collectionView.reloadData()
            return print("GIRD 뷰입니다.")
        default:
            return
        }
    }
    
    private func creatLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: creatLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func configureDataSource(pageNo: Int, itemsPerPage: Int) {
        /*
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: "swift")
            content.text = "\(indexPath.section), \(indexPath.row)"
            cell.contentConfiguration = content
        }
         */
        
        dataSource = UICollectionViewDiffableDataSource<Section, ProductInformation>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ProductInformation) in
            switch self.status {
        case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell else { return UICollectionViewListCell() }
                cell.configureContent(productInformation: identifier)
                return cell
        case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell else { return UICollectionViewCell() }
                cell.configureContent(productInformation: identifier)
                return cell
            default:
                return nil
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductInformation>()
        snapshot.appendSections([.main])
        
        guard let url = OpenMarketApi.pageInformation(pageNo: pageNo, itemsPerPage: itemsPerPage).url else {
            return
        }
        
        requestData(
            url: url
        ) { data, urlResponse in
            guard let data = data,
                  let pageInformation = try? JSONDecoder().decode(PageInformation.self, from: data) else { return }
            snapshot.appendItems(pageInformation.pages)
            self.dataSource.apply(snapshot, animatingDifferences: true)
        } errorHandler: { error in
            print(error)
        }
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(
            width: view.safeAreaLayoutGuide.layoutFrame.width / 3 ,
            height: view.safeAreaLayoutGuide.layoutFrame.height / 3
        )
        return flowLayout
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}
