//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    enum Section {
        case main
    }
    
    let formatter: NumberFormatter = {
        let formmater = NumberFormatter()
        formmater.numberStyle = .decimal
        
        return formmater
    }()
    
    lazy var navSegmentedView: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBlue
        for index in 0..<segmentedControl.numberOfSegments {
            segmentedControl.setWidth(view.frame.width / 5, forSegmentAt: index)
        }
        
        return segmentedControl
    }()
    
    var listCellRegistration: UICollectionView.CellRegistration<ListCell, Product>?
    var gridCellRegistration: UICollectionView.CellRegistration<GridCell, Product>?
    var listDataSource: UICollectionViewDiffableDataSource<Section, Product>?
    var gridDataSource: UICollectionViewDiffableDataSource<Section, Product>?
    
    lazy var collectionView: UICollectionView = {
        let layout = createListLayout()
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        indicator.hidesWhenStopped = true
        indicator.style = UIActivityIndicatorView.Style.large
        return indicator
    }()
    
    let manager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let product = Product(name: "좋아요 감사합니다!", description: "AAAAA", currency: .KRW, price: 12345, bargainPrice: 1, discountedPrice: 1, stock: 123, secret: "966j8xcwknjhh7wj")

        let image = UIImage(named: "qrcode")!

//        manager.deleteData(productNumber: 555) {
//            print("목표물 처리 완료")
//        }
        
//        manager.postProductLists(params: product, images: [image]) {
//            print("?")
//        }
        
        setupNavBar()
        configureListCell()
        configureGridCell()
        setupUI()
        loadProductListToCollectionView()
        
//        manager.patchProduct(number: 521) {
//            print("수정끝")
//        }
    }
    
    func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        
        self.navigationController?.navigationBar.backgroundColor = .systemGray
        
        self.navigationItem.titleView = navSegmentedView
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAddButton))
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.navSegmentedView.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        collectionView.dataSource = listDataSource
        
        self.view.addSubview(self.indicator)
        self.view.addSubview(self.collectionView)
        self.view.bringSubviewToFront(self.indicator)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),

            self.indicator.widthAnchor.constraint(equalToConstant: 100),
            self.indicator.heightAnchor.constraint(equalToConstant: 100),
            self.indicator.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            self.indicator.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
    }
    
    private func loadProductListToCollectionView() {
        self.indicator.startAnimating()
        
        manager.getProductsList(pageNo: 1, itemsPerPage: 40) { list in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections([.main])
            snapshot.appendItems(list.products)
            
            self.listDataSource?.apply(snapshot)
            self.gridDataSource?.apply(snapshot)
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
        }
    }
}

// MARK: - Cell Registration and DataSource
extension MainViewController {
    private func configureListCell() {
        self.listCellRegistration = UICollectionView.CellRegistration<ListCell, Product> { cell, indexPath, itemIdentifier in
            DispatchQueue.global().async {
                guard let url = URL(string: itemIdentifier.thumbnail ?? ""),
                      let data = try? Data(contentsOf: url)  else {
                          return
                      }
                
                let picture = UIImage(data: data)
                
                DispatchQueue.main.async {
                    
                    cell.productNameLabel.text = "\(itemIdentifier.name)"
                    cell.discountedPriceLabel.text = "\(itemIdentifier.currency.rawValue) \(self.formatter.string(for: itemIdentifier.discountedPrice) ?? "")"
                    cell.image.image = picture
                    
                    if itemIdentifier.bargainPrice != itemIdentifier.price {
                        cell.priceLabel.text = "\(itemIdentifier.currency.rawValue) \(self.formatter.string(for: itemIdentifier.price) ?? "")"
                    } else {
                        cell.priceLabel.isHidden = true
                    }
                    
                    if itemIdentifier.stock == 0 {
                        cell.stockLabel.text = "품절"
                        cell.stockLabel.textColor = .systemYellow
                    } else {
                        cell.stockLabel.text = "잔여수량 : \(itemIdentifier.stock)"
                    }
                }
            }
        }
        
        self.listDataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            guard let listCell = self.listCellRegistration else {
                return UICollectionViewCell()
            }
            
            return collectionView.dequeueConfiguredReusableCell(using: listCell, for: indexPath, item: itemIdentifier)
        })
    }
    
    private func configureGridCell() {
        self.gridCellRegistration = UICollectionView.CellRegistration<GridCell, Product> { cell, indexPath, itemIdentifier in
            DispatchQueue.global().async {
                guard let url = URL(string: itemIdentifier.thumbnail ?? ""),
                      let data = try? Data(contentsOf: url)  else {
                          return
                      }
                
                let picture = UIImage(data: data)
                
                DispatchQueue.main.async {
                    cell.productNameLabel.text = "\(itemIdentifier.name)"
                    cell.discountedPriceLabel.text = "\(itemIdentifier.currency.rawValue) \(self.formatter.string(for: itemIdentifier.discountedPrice) ?? "")"
                    cell.image.image = picture
                    
                    if itemIdentifier.bargainPrice != itemIdentifier.price {
                        cell.priceLabel.text = "\(itemIdentifier.currency.rawValue) \(self.formatter.string(for: itemIdentifier.price) ?? "")"
                    } else {
                        cell.priceLabel.isHidden = true
                    }
                    
                    if itemIdentifier.stock == 0 {
                        cell.stockLabel.text = "품절"
                        cell.stockLabel.textColor = .systemYellow
                    } else {
                        cell.stockLabel.text = "잔여수량 : \(itemIdentifier.stock)"
                    }
                }
            }
        }
        
        self.gridDataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            
            guard let gridCellRegis = self.gridCellRegistration else {
                return UICollectionViewCell()
            }
            
            return collectionView.dequeueConfiguredReusableCell(using: gridCellRegis, for: indexPath, item: itemIdentifier)
        })
    }
}

// MARK: - CompositionalLayout
extension MainViewController {
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func createGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

// MARK: - Obj-C Method
extension MainViewController {
    @objc func tappedAddButton() {
        let addProductVC = AddProductViewController()
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: addProductVC)
        
        addProductVC.updateDelegate = self
        addProductVC.title = "상품등록"
        navBarOnModal.modalPresentationStyle = .fullScreen
        navBarOnModal.modalTransitionStyle = .crossDissolve
        
        self.present(navBarOnModal, animated: true)
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch self.navSegmentedView.selectedSegmentIndex {
        case 0:
            let layout = createListLayout()
            guard let listDataSource = listDataSource else {
                return
            }
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.dataSource = listDataSource
            print(collectionView.visibleCells)
        case 1:
            let layout = createGridLayout()
            guard let gridDataSource = gridDataSource else {
                return
            }
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.dataSource = gridDataSource
            print(collectionView.visibleCells)
        default:
            return
        }
    }
}

extension MainViewController: CollectionViewUpdateDelegate {
    func updateCollectionView() {
        let manager = NetworkManager()
        manager.getProductsList(pageNo: 1, itemsPerPage: 40) { productList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections([.main])
            snapshot.appendItems(productList.products)
            
            self.listDataSource?.apply(snapshot)
            self.gridDataSource?.apply(snapshot)
        }
    }
}

protocol CollectionViewUpdateDelegate {
    func updateCollectionView()
}
