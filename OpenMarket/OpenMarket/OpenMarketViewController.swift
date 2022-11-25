//
//  OpenMarket - OpenMarketViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    
    private enum ProductListSection: Int {
        case main
    }
    
    private let segmentedControl: UISegmentedControl = {
            let control = UISegmentedControl(items: ["LIST", "GRID"])
            control.translatesAutoresizingMaskIntoConstraints = false
            return control
        }()
    
    private var gridCollectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<ProductListSection, Product>?
    private var products: [Product] = [] {
        didSet {
            if segmentedControl.selectedSegmentIndex == 0 {
                print("configure list!")
            }
            configureDataSource()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        configureGridCollectionView()
        configureDataSource()
    }
    
    func fetchData() {
        let networkManager = NetworkManager()
        networkManager.request(endpoint: OpenMarketAPI.productList(pageNumber: 1, itemsPerPage: 1000), dataType: ProductList.self) { result in
            switch result {
            case .success(let productList):
                // 현재 호출되는 곳은 글로벌 큐
                // 글로벌 큐에서 바로 products를 넣는다면?
                // 굳이 main.async로 넣어야 하는 이유? --> didSet에서 UI를 설정해주고 있기 때문에
                DispatchQueue.main.async {
                    self.products = productList.products
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension OpenMarketViewController: UICollectionViewDelegate { }

extension OpenMarketViewController {
    func configureGridCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let gridCollectionView = gridCollectionView else { return }
        view.addSubview(gridCollectionView)
        
        gridCollectionView.delegate = self
        
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gridCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            gridCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func configureDataSource() {
        guard let gridCollectionView = gridCollectionView else { return }

        gridCollectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        
        dataSource = UICollectionViewDiffableDataSource<ProductListSection, Product>(collectionView: gridCollectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell
            cell?.contentView.translatesAutoresizingMaskIntoConstraints = false
            cell?.contentView.backgroundColor = .white
            cell?.contentView.layer.borderColor = UIColor.gray.cgColor
            cell?.contentView.layer.borderWidth = 1.0
            cell?.contentView.layer.cornerRadius = 10.0
            cell?.contentView.layer.masksToBounds = true
            cell?.updateContents(product)
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<ProductListSection, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(products)
        
        guard let dataSource = dataSource else { return }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 2 - 15
        let height: CGFloat = collectionView.frame.height / 3 - 20
        return CGSize(width: width, height: height)
    }
}
