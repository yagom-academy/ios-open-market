//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/30.
//

import UIKit

final class ProductDetailViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Product>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Product>
    
    private var mainView: ProductDetailView?
    private let product: Product
    
    private var dataSource: DataSource?
    private var snapshot: Snapshot?
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        mainView = ProductDetailView(frame: view.bounds)
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        mainView?.backgroundColor = .systemBackground
        mainView?.configure(data: product)
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        mainView?.productImageCollectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        mainView?.productImageCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: UICollectionView.elementKindSectionFooter)
        dataSource = makeDataSource()
        snapshot = makeSnapshot()
    }
    
    private func makeDataSource() -> DataSource? {
        guard let mainView = mainView else { return nil }
        
        let datasource = DataSource(collectionView: mainView.productImageCollectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier, for: indexPath) as? ProductImageCell ?? ProductImageCell()
            
            cell.configure(image: UIImage(systemName: "swift")!)
            
            return cell
        }
        
        datasource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionFooter else { return nil }
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UICollectionView.elementKindSectionFooter, for: indexPath)
            
            view.backgroundColor = .systemRed
            return view
        }
        
        return datasource
    }
    
    private func makeSnapshot() -> Snapshot? {
        var snapshot = dataSource?.snapshot()
        snapshot?.deleteAllItems()
        snapshot?.appendSections([.main])
        return snapshot
    }
    
    private func applySnapshot(products: [Product]) {
        DispatchQueue.main.async { [self] in
            snapshot?.appendItems(products)
            guard let snapshot = snapshot else { return }
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
}
