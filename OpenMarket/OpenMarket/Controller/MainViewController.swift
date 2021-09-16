//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
@available(iOS 14.0, *)
class MainViewController: UIViewController {
    let dataSource = CollectionViewDataSource()
    var collectionView: UICollectionView!
    let aaa = CollectionViewProperty.shared
    var layout: UICollectionViewLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureViewController()
        dataSource.requestNextPage(collectionView: collectionView)
    }

    func configureViewController() {
        self.title = "야아마켓"
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(submit(_:)))

        let layoutSegmentControl: UISegmentedControl = UISegmentedControl(items: ["List", "Grid"])
        layoutSegmentControl.selectedSegmentIndex = 0
        layoutSegmentControl.addTarget(self, action: #selector(segconChanged(_:)), for: .valueChanged)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: layoutSegmentControl)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(collectionView)

        collectionView.backgroundColor = .white
        collectionView.register(CollectionViewGridCell.self, forCellWithReuseIdentifier: CollectionViewGridCell.cellID)
        collectionView.register(CollectionViewListCell.self, forCellWithReuseIdentifier: CollectionViewListCell.cellID)

        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.prefetchDataSource = dataSource
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    @objc func submit(_ sender: Any) {
        let detailVC = DetailViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    @objc func segconChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("list")
            aaa.isListView = true
            collectionView.collectionViewLayout = createListLayout()
            collectionView.reloadData()
        case 1:
            print("grid")
            aaa.isListView = false
            collectionView.collectionViewLayout = createGridLayout()
            collectionView.reloadData()
        default:
            return
        }
    }
}

// MARK: Extension for configure CGFloat operand
extension CGFloat {
    static func / (lhs: CGFloat, rhs: Int) -> CGFloat {
        return lhs / CGFloat(rhs)
    }

    static func * (lhs: CGFloat, rhs: Int) -> CGFloat {
        return lhs * CGFloat(rhs)
    }
}

@available(iOS 14.0, *)
extension MainViewController {
    private func createListLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}


// MARK: Extension for UICollectionViewDelegateFlowLayout
@available(iOS 14.0, *)
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint(indexPath.row)
    }
}
