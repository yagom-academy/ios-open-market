//
//  ImagePickerCollectionView.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/30.
//

import UIKit

final class ImagePickerCollectionView: UICollectionView {
    private var imagePickerCellRegistration: UICollectionView.CellRegistration<ImagePickerCell, ViewContainer>?
    private var imagePickerDataSource: UICollectionViewDiffableDataSource<Section, ViewContainer>?
    
    init(frame: CGRect, collectionViewLayout layout: CollectionViewLayout) {
        super.init(frame: frame,
                   collectionViewLayout: LayoutMaker.make(of: layout))
        registerCell()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Snapshot
    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<Section, ViewContainer>) {
        imagePickerDataSource?.apply(snapshot, animatingDifferences: false)
    }
    //MARK: - Cell
    private func registerCell() {
        imagePickerCellRegistration = UICollectionView.CellRegistration<ImagePickerCell, ViewContainer> { (cell, indexPath, viewContainer) in
            cell.addContentView(viewContainer.view)
        }
    }
    //MARK: - DataSource
    private func configureDataSource() {
        guard let imageCellRegistration = imagePickerCellRegistration else {
            return
        }
        
        imagePickerDataSource = UICollectionViewDiffableDataSource<Section, ViewContainer>(collectionView: self) { (collectionView: UICollectionView, indexPath: IndexPath, viewContainer: ViewContainer) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: imageCellRegistration, for: indexPath, item: viewContainer)
        }
    }
}
