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
        indicator.style = UIActivityIndicatorView.Style.large
        return indicator
    }()
    
    let manager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        configureListCell()
        configureGridCell()
        setupUI()
        loadProductListToCollectionView()
    }
    
    private func setupNavBar() {
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
        collectionView.delegate = self
        
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
            print(list.products)
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

// MARK: - CollectionView - Cell Registration and DataSource
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
                    
                    cell.product = itemIdentifier
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
                    cell.product = itemIdentifier
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

// MARK: - CollectionView - CompositionalLayout
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

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let productVC = ProductViewController()
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: productVC)
        
        productVC.cellUpdateDelegate = self
        productVC.title = "상품수정"
        
        guard let product = (collectionView.cellForItem(at: indexPath) as? ListCell)?.product else {
            return
        }
        
        let manager = NetworkManager()
        manager.getProductDetail(productNumber: product.id ?? 0) { productDetail in
            productDetail.images?.forEach({ image in
                DispatchQueue.global().async {
                    if let url = URL(string: image.thumbnailUrl),
                       let data = try? Data(contentsOf: url) {
                        
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.sync {
                                let imageView = UIImageView(image: image)
                                imageView.translatesAutoresizingMaskIntoConstraints = false
                                
                                productVC.imageStackView.addArrangedSubview(imageView)

                                imageView.heightAnchor.constraint(equalTo: productVC.scrollView.heightAnchor).isActive = true
                                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
                            }
                        }
                    }
                    
                }
                DispatchQueue.main.sync {
                    productVC.productNameTextField.text = productDetail.name
                    productVC.productPriceTextField.text = String(productDetail.price)
                    productVC.bargainPriceTextField.text = String(productDetail.bargainPrice)
                    productVC.stockTextField.text = String(productDetail.stock)
                    productVC.descriptionTextView.text = productDetail.description
                }
            })
        }
        
        navBarOnModal.modalPresentationStyle = .fullScreen
        navBarOnModal.modalTransitionStyle = .crossDissolve
        
        self.present(navBarOnModal, animated: true)
    }
}


// MARK: - Obj-C Method
extension MainViewController {
    @objc func tappedAddButton() {
        let addProductVC = ProductViewController()
        let navBarOnModal: UINavigationController = UINavigationController(rootViewController: addProductVC)
        
        addProductVC.cellUpdateDelegate = self
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
        case 1:
            let layout = createGridLayout()
            guard let gridDataSource = gridDataSource else {
                return
            }
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.dataSource = gridDataSource
        default:
            return
        }
    }
}
