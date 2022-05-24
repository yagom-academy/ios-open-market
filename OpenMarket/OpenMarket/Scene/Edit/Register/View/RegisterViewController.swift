//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/24.
//

import UIKit

final class RegisterViewController: UIViewController {
    private lazy var editView = EditView(frame: view.frame)
    private let viewModel = RegisterViewModel()
    
    override func loadView() {
        super.loadView()
        view.addSubview(editView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBarItems()
        setUpCollectionView()
        setUpViewModel()
        
        viewModel.appendImages()
    }
    
    private func setUpBarItems() {
        editView.setUpBarItem(title: "상품등록")
        editView.navigationBarItem.leftBarButtonItem?.target = self
        editView.navigationBarItem.leftBarButtonItem?.action = #selector(didTapCancelButton)
    }
    
    private func setUpCollectionView() {
//        editView.collectionView.delegate = self
    }
    
    private func setUpViewModel() {
        viewModel.datasource = makeDataSource()
        viewModel.delegate = self
    }
    
    @objc private func didTapCancelButton() {
        self.dismiss(animated: true)
    }
}

extension RegisterViewController {
    private func makeDataSource() -> UICollectionViewDiffableDataSource<RegisterViewModel.Section, ImageInfo> {
        let cellRegistration = UICollectionView.CellRegistration<ProductsHorizontalCell, ImageInfo> { (cell, indexPath, image) in

            cell.updateImage(imageInfo: image)
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration
        <ProductsHorizontalFooterView>(elementKind: "section-footer-element-kind") {
            (supplementaryView, string, indexPath) in
            supplementaryView.backgroundColor = .blue
        }
        
        let dataSource = UICollectionViewDiffableDataSource<RegisterViewModel.Section, ImageInfo>(collectionView: editView.collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ImageInfo) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.editView.collectionView.dequeueConfiguredReusableSupplementary(
                using: footerRegistration, for: index)
        }
        
        
//        let dataSource = UICollectionViewDiffableDataSource<RegisterViewModel.Section, ImageInfo>(
//            collectionView: editView.collectionView,
//            cellProvider: { (collectionView, indexPath, image) -> UICollectionViewCell in
//                guard let cell = collectionView.dequeueReusableCell(
//                    withReuseIdentifier: ProductsHorizontalCell.identifier,
//                    for: indexPath) as? ProductsHorizontalCell else {
//                    return UICollectionViewCell()
//                }
//
//                cell.updateImage(imageInfo: image)
//
//                return cell
//            })
        return dataSource
    }
}

extension RegisterViewController: AlertDelegate {
    func showAlertRequestError(with error: Error) {
        print("")
    }
}
