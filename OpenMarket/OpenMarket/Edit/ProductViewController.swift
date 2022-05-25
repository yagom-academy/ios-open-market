//
//  ProductViewController.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/25.
//

import UIKit


protocol ProductViewControllerDelegate: AnyObject {
    func refreshData()
}

class ProductViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, UIImage>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
    
    let networkManager = NetworkManager<Product>()
    let imagePickerController = UIImagePickerController()
    
    var mainView: EditView?
    var dataSource: DataSource?
    var snapshot: Snapshot?
    weak var delegate: ProductViewControllerDelegate?
    
    override func loadView() {
        super.loadView()
        mainView = EditView(frame: view.bounds)
        view = mainView
    }
    
    deinit {
        removeNotification()
    }
    
    func configureView() {
        configureCollectionView()
        configureNavigationBar()
    }
    
    func configureCollectionView() {
        mainView?.collectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        dataSource = makeDataSource()
        snapshot = makeSnapsnot()
    }
    
    func configurePickerController() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
    
    func configureNavigationBar() {
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonDidTapped))
        let rightBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonDidTapped))
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func cancelButtonDidTapped() {
        // empty
    }
    
    @objc func doneButtonDidTapped() {
        // empty
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        mainView?.productDescriptionTextView.contentInset.bottom = keyboardHeight
    }
    
    @objc private func keyboardWillHidden(_ sender: Notification) {
        mainView?.productDescriptionTextView.contentInset.bottom = 0
    }
    
    func albumButtonTapped() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    func cameraButtonTapped() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
    
    func makeDataSource() -> DataSource? {
        return nil
    }
}

// MARK: - ImageViewController Delegate

extension ProductViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        insertSnapshot(images: [image])
        picker.dismiss(animated: true)
    }
}

// MARK: - CollectionView DataSource

extension ProductViewController {
    func makeSnapsnot() -> Snapshot? {
        var snapshot = dataSource?.snapshot()
        snapshot?.deleteAllItems()
        snapshot?.appendSections([.main])
        return snapshot
    }
    
    func applySnapshot(images: [UIImage]) {
        DispatchQueue.main.async { [self] in
            snapshot?.appendItems(images)
            guard let snapshot = snapshot else { return }
            
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func deleteSnapshot(images: [UIImage]) {
        snapshot?.deleteItems(images)
        guard let snapshot = snapshot else { return }
        
        dataSource?.apply(snapshot)
    }
    
    func insertSnapshot(images: [UIImage]) {
        DispatchQueue.main.async { [self] in
            guard let lastItem = snapshot?.itemIdentifiers.last else { return }
            snapshot?.insertItems(images, beforeItem: lastItem)
            guard let snapshot = snapshot else { return }
            
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
}
