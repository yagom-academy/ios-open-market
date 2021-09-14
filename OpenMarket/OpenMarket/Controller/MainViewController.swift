//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
@available(iOS 14.0, *)
class MainViewController: UIViewController {

    let collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.estimatedItemSize = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        return collectionView
    }()

    let dataSource = CollectionViewDataSource()
    let aaa = CollectionViewProperty.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.prefetchDataSource = dataSource
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
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true

        collectionView.backgroundColor = .white
        collectionView.register(CollectionViewGridCell.self, forCellWithReuseIdentifier: CollectionViewGridCell.cellID)
        collectionView.register(CollectionViewListCell.self, forCellWithReuseIdentifier: CollectionViewListCell.cellID)
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
        case 1:
            print("grid")
            aaa.isListView = false
        default:
            return
        }
        collectionView.reloadData()
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

// MARK: Extension for UICollectionViewDelegate
@available(iOS 14.0, *)
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewGridCell else {
            return true
        }
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            return false
        } else {
            print("\(indexPath) : \(cell.priceLabel.text) -> \(cell.discountedPriceLabel.text)")
            return true
        }
    }
}

// MARK: Extension for UICollectionViewDelegateFlowLayout
@available(iOS 14.0, *)
extension MainViewController: UICollectionViewDelegateFlowLayout {
    var insetForSection: CGFloat {
        return 10
    }
    var insetForCellSpacing: CGFloat {
        return 10
    }
    var cellForEachRow: Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if aaa.isListView {
            let width = collectionView.frame.width
            let height = width / 7
            return CGSize(width: width, height: height)
        } else {
            let width = (collectionView.frame.width - (insetForSection * 2 + insetForCellSpacing * (cellForEachRow - 1))) / cellForEachRow
            let height = width * 1.4
            return CGSize(width: width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return insetForCellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: insetForSection, left: insetForSection, bottom: insetForSection, right: insetForSection)
    }
}
