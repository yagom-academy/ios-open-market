//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    
    var status = 0
    
    enum Section {
        case main
        case grid
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
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
        configureDataSource()
        
        self.collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
    }
    
    private func configureSegmentedControl() {
        self.navigationItem.titleView = segmentedControl
    }
    
    @objc func changeSegmentedControl(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            return print("LIST 뷰입니다.")
        case 1:
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
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.image = UIImage(systemName: "swift")
            content.text = "\(indexPath.section), \(indexPath.row)"
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) in
            if self.status == 1 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell else { return UICollectionViewListCell() }
//                cell.configureContent(productInformation: )
                return cell
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main, .grid])
        snapshot.appendItems(Array(1...10), toSection: .main)
        snapshot.appendItems(Array(11...20), toSection: .grid)
        dataSource.apply(snapshot, animatingDifferences: true)
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
