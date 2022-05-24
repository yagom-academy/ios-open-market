//
//  EditViewController.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/24.
//

import UIKit

private enum Section {
    case main
}

final class EditViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UIImage>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
    
    private var mainView: EditView?
    private var dataSource: DataSource?
    private var snapshot: Snapshot?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        applySnapshot(images: [UIImage(systemName: "swift")!,
                               UIImage(systemName: "pencil")!,
                               UIImage(systemName: "person.2")!,
                               UIImage(systemName: "plus")!
                              ])
    }
    
    override func loadView() {
        super.loadView()
        mainView = EditView(frame: view.bounds)
        mainView?.backgroundColor = .systemBackground
        view = mainView
    }
    
    private func configureCollectionView() {
        mainView?.collectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        dataSource = makeDataSource()
        snapshot = makeSnapsnot()
    }
}

// MARK: - CollectionView DataSource

extension EditViewController {
    private func makeDataSource() -> DataSource? {
        guard let mainView = mainView else { return nil }
        
        let dataSource = DataSource(collectionView: mainView.collectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier, for: indexPath) as? ProductImageCell else {
                return ProductImageCell()
            }
            
            cell.configure(image: itemIdentifier)
            
            return cell
        }
        
        return dataSource
    }
    
    private func makeSnapsnot() -> Snapshot? {
        var snapshot = dataSource?.snapshot()
        snapshot?.deleteAllItems()
        snapshot?.appendSections([.main])
        return snapshot
    }
    
    private func applySnapshot(images: [UIImage]) {
        DispatchQueue.main.async { [self] in
            snapshot?.appendItems(images)
            guard let snapshot = snapshot else { return }
            
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
}
