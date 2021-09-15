//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ItemListViewController: UIViewController {
    private var items: [Item] = []
    private var page: Int = 1
    private let networkManager = NetworkManager(session: URLSession.shared)
    private let parsingManager = ParsingManager()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpLayouts()
        collectionView.collectionViewLayout = configureLayout()
        loadItemList()
    }

}

extension ItemListViewController {
    private func loadItemList() {
        networkManager.send(request: .getList, of: page) { result in
            switch result {
            case .success(let data):
                let parsedData = self.parsingManager.parse(data, to: ItemList.self)
                switch parsedData {
                case .success(let item):
                    self.items.append(contentsOf: item.items)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    self.page += 1
                case .failure(let error):
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setUpCollectionView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.register(ItemGridCell.self, forCellWithReuseIdentifier: ItemGridCell.identifier)
    }

    private func setUpLayouts() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    private func configureLayout() -> UICollectionViewFlowLayout {
        let deviceWidth = UIScreen.main.bounds.width
        let deviceHeight = UIScreen.main.bounds.height
        let minimumLineSpacing: CGFloat = 10
        let minimumInteritemSpacing: CGFloat = 10
        let inset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize.width = deviceWidth / 2.2
        flowLayout.itemSize.height = deviceHeight / 3.3
        flowLayout.minimumLineSpacing = minimumLineSpacing
        flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
        flowLayout.sectionInset = inset

        return flowLayout
    }
}

extension ItemListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemGridCell.identifier, for: indexPath) as? ItemGridCell else {
            return UICollectionViewCell()
        }
        
        let item = items[indexPath.item]
        cell.setup(with: item)

        return cell
    }
}
