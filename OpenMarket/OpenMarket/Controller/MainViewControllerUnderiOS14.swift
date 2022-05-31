//
//  MainViewControllerUnderiOS14.swift
//  OpenMarket
//
//  Created by papri, Tiana on 24/05/2022.
//

import UIKit

class MainViewControllerUnderiOS14: BaseViewController {
    private var products: [Product] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        view.backgroundColor = .systemBackground
        DataProvider.shared.fetchProductListData() { products in
            guard let products = products else {
                let alert = Alert().showWarning(title: "경고", message: "데이터를 불러오지 못했습니다", completionHandler: nil)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
                return
            }
            self.products.append(contentsOf: products)
        }
        setUpRefreshControl()
    }
    
    // MARK: override function (non @objc)
    override func applyListLayout() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        listLayout = layout
    }
}

// MARK: Refresh Control
extension MainViewControllerUnderiOS14 {
    func setUpRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        refreshControl.tintColor = UIColor.systemPink

        collectionView?.refreshControl = refreshControl
    }
    
    @objc func refreshCollectionView() {
        DataProvider.shared.reloadData() { products in
            guard let products = products else {
                let alert = Alert().showWarning(title: "경고", message: "데이터를 불러올 수 없다", completionHandler: nil)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
                return
            }
            self.products = products
        }
        DispatchQueue.main.async {
            self.collectionView?.refreshControl?.endRefreshing()
        }
    }
}

// MARK: CollectionView Setting
extension MainViewControllerUnderiOS14 {
    private func setUpCollectionView() {
        collectionView?.register(ProductListCell.self, forCellWithReuseIdentifier: "ProductListCell")
        collectionView?.register(ProductGridCell.self, forCellWithReuseIdentifier: "ProductGridCell")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = .systemBackground
    }
    
    @objc override func switchCollectionViewLayout() {
        super.switchCollectionViewLayout()
        collectionView?.reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension MainViewControllerUnderiOS14: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if baseView.segmentedControl.selectedSegmentIndex == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCell", for: indexPath) as? ProductListCell else {
                return UICollectionViewCell()
            }
            
            guard let product = products[safe: indexPath.row] else {
                return UICollectionViewCell()
            }
            
            cell.update(newItem: product)
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductGridCell", for: indexPath) as? ProductGridCell else {
                return UICollectionViewCell()
            }
            
            guard let product = products[safe: indexPath.row] else {
                return UICollectionViewCell()
            }
            
            cell.update(newItem: product)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegate
extension MainViewControllerUnderiOS14: UICollectionViewDelegate {
    func collectionView( _ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let _ = products[safe: indexPath.row + 1] else {
            DataProvider.shared.fetchProductListData { products in
                guard let products = products else {
                    let alert = Alert().showWarning(title: "경고", message: "데이터를 불러오지 못했습니다", completionHandler: nil)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true)
                    }
                    return
                }
                self.products.append(contentsOf: products)
            }
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = products[safe: indexPath.row] else { return }
        
        DataProvider.shared.fetchProductDetailData(productIdentifier: product.identifier) { decodedData in
            guard let decodedData = decodedData else {
                let alert = Alert().showWarning(title: "경고", message: "데이터를 불러오지 못했습니다", completionHandler: nil)
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
                return
            }
            
            DispatchQueue.main.async {
                let registerProductView = UpdateProductViewController(product: decodedData)
                let navigationController = UINavigationController(rootViewController: registerProductView)
                navigationController.modalTransitionStyle = .coverVertical
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true)
            }
        }
    }
}
