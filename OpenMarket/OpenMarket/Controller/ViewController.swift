//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    let collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.estimatedItemSize = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        return collectionView
    }()

    let networkManager = NetworkManager()
    var items: [Item] = []
    var page: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self

        configureViewController()
        requestNextPage()
    }

    func configureViewController() {
        self.title = "야아마켓"
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(submit(_:)))
        let safeArea = view.safeAreaLayoutGuide
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true

        collectionView.backgroundColor = .white
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellID)
    }

    @objc func submit(_ sender: Any) {
        let detailVC = DetailViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    func requestNextPage() {
        networkManager.commuteWithAPI(API.GetItems(page: page)) { result in
            if case .success(let data) = result {
                guard let data = try? JSONDecoder().decode(Items.self, from: data) else {
                    return
                }
                self.items.append(contentsOf: data.items)
                self.page += 1

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else {
            return true
        }
        if cell.isSelected {
            collectionView.deselectItem(at: indexPath, animated: true)
            return false
        } else {
            print("\(items[indexPath.row].price) \(items[indexPath.row].discountedPrice)")
            return true
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellID, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(item: items[indexPath.item])
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
}

// MARK: Extension for UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
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
        let width = (view.frame.width - (insetForSection * 2 + insetForCellSpacing * (cellForEachRow - 1))) / cellForEachRow
        let height = width * 1.4
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return insetForCellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: insetForSection, left: insetForSection, bottom: insetForSection, right: insetForSection)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: Extension for Prefetch DataSource
extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let lastItem = items.count - 1
        for indexPath in indexPaths {
            debugPrint(indexPath)
            if lastItem == indexPath.item {
                debugPrint("requestNextPage")
                requestNextPage()
            }
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

// MARK: Extension for using Canvas
import SwiftUI
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }

    typealias UIViewControllerType = ViewController
}
@available(iOS 13.0.0, *)
struct ViewPreview: PreviewProvider {
    static var previews: some View {
        ViewControllerRepresentable()
    }
}
