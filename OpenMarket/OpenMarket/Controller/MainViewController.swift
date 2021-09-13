//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {

    let gridCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.estimatedItemSize = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        return collectionView
    }()

    let dataSource = CollectionViewDataSource()
    let delegate = CollectionViewDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        gridCollectionView.dataSource = dataSource
        gridCollectionView.delegate = delegate
        gridCollectionView.prefetchDataSource = dataSource
        configureViewController()
        dataSource.requestNextPage(collectionView: gridCollectionView)
    }

    func configureViewController() {
        self.title = "야아마켓"
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(submit(_:)))
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(gridCollectionView)
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false

        gridCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        gridCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        gridCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        gridCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true

        gridCollectionView.backgroundColor = .white
        gridCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellID)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gridCollectionView.collectionViewLayout.invalidateLayout()
    }

    @objc func submit(_ sender: Any) {
        let detailVC = DetailViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
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

// MARK: Extension for using Canvas
import SwiftUI
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainViewController {
        return MainViewController()
    }

    func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
    }

    typealias UIViewControllerType = MainViewController
}
@available(iOS 13.0.0, *)
struct ViewPreview: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}
