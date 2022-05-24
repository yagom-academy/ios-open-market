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
    
    private let imagePickerController = UIImagePickerController()
    
    override func loadView() {
        super.loadView()
        mainView = EditView(frame: view.bounds)
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        applySnapshot(images: [UIImage(systemName: "swift")!,
                               UIImage(systemName: "pencil")!,
                               UIImage(systemName: "person.2")!,
                               UIImage(systemName: "plus")!
                              ])
    }
    
    private func configureView() {
        configureCollectionView()
        configureNavigationBar()
    }
    
    private func configureCollectionView() {
        mainView?.collectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        mainView?.collectionView.delegate = self
        dataSource = makeDataSource()
        snapshot = makeSnapsnot()
    }
    
    private func configureNavigationBar() {
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonDidTapped))
        let rightBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonDidTapped))
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.title = "상품등록"
    }
    
    @objc private func cancelButtonDidTapped() {
        dismiss(animated: true)
    }
    
    @objc private func doneButtonDidTapped() {
        // empty
    }
    
    private func configurePickerController() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
    
    private func albumButtonTapped() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    private func cameraButtonTapped() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
}

extension EditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
}

extension EditViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard snapshot?.numberOfItems == indexPath.item + 1 else { return }
        
        AlertDirector(viewController: self).createImageSelectActionSheet { [weak self] _ in
            self?.albumButtonTapped()
        } cameraAction: { [weak self] _ in
            self?.cameraButtonTapped()
        }

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
