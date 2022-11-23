//
//  OpenMarket - ProductListViewController.swift
//  Created by Aejong, Tottale on 2022/11/22.
// 

import UIKit

enum Section: Hashable {
    case main
}

class ProductListViewController: UIViewController {
    
    var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    var productData: ProductList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureSegmentedControl()
        configureNavigationBar()
        configureAddButton()
        
        let networkProvider = NetworkAPIProvider()
        networkProvider.fetchProductList(query: nil) { result in
            switch result {
            case .success(let data):
                self.productData = data
                DispatchQueue.main.async {
                    self.configureHierarchy()
                    self.configureDataSource()
                }
            default :
                return
            }
        }
    }
    
    @objc private func addButtonPressed() {
        let addProductViewController = AddProductViewController()
        self.present(addProductViewController, animated: true, completion: nil)
    }
}

extension ProductListViewController {
    private func configureNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func configureSegmentedControl() {
        let segmentTextContent = [NSLocalizedString("LIST", comment: ""), NSLocalizedString("GRID", comment: "")]
        let segmentedControl = UISegmentedControl(items: segmentTextContent)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.selectedSegmentTintColor = .systemBlue
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemBlue], for: .normal)
        
        self.navigationItem.titleView = segmentedControl
    }
    
    private func configureAddButton() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = addItem
    }
}

extension ProductListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension ProductListViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ProductListCell, Product> { (cell, indexPath, product) in
            cell.update(with: product)
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(productData?.pages ?? [])
        dataSource.apply(snapshot)
    }
}





