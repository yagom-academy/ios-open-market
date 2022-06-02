//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/24.
//

import UIKit

final class RegisterViewController: ProductViewController {
    private let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        applySnapshot(images: [Constant.Image.plus])
        configurePickerController()
        registerNotification()
    }
    
    // MARK: - Configure Method
    
    override func configureCollectionView() {
        super.configureCollectionView()
        mainView?.collectionView.delegate = self
    }
    
    private func configurePickerController() {
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.title = "상품등록"
    }
    
    @objc override func cancelButtonDidTapped() {
        dismiss(animated: true)
    }
    
    @objc override func doneButtonDidTapped() {
        guard let uploadProduct = makeUploadProduct() else { return }
        let createProductAPI = CreateProduct(bodyParameters: uploadProduct)
        
        networkManager.request(api: createProductAPI) { [weak self] (result: Result<Product, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .update, object: nil)
                    self.dismiss(animated: true)
                }
            case .failure(_):
                AlertDirector(viewController: self).createErrorAlert(message: "데이터를 등록하지 못했습니다.")
            }
        }
    }
    
    private func makeUploadProduct() -> UploadProduct? {
        guard let snapshot = snapshot else { return nil }
        var uploadProduct = mainView?.makeEncodableModel()
        
        let images = snapshot.itemIdentifiers[0..<snapshot.numberOfItems - 1]
        let imageDatas = images.compactMap { compress(image: $0) }
        
        uploadProduct?.images = imageDatas.map { imageData in
            return ImageInformation(fileName: "두파리 + \(UUID().uuidString)", data: imageData, type: ".jpg")
        }
        
        return uploadProduct
    }
    
    private func compress(image: UIImage) -> Data? {
        guard var jpegData = image.jpegData(compressionQuality: 1.0) else { return nil }
        
        while jpegData.count >= 300 * 1024 {
            guard let image = UIImage(data: jpegData) else { return nil }
            guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
            
            jpegData = data
        }
        
        return jpegData
    }
    
    // MARK: - CollectionView DataSource
    
    override func makeDataSource() -> DataSource? {
        guard let mainView = mainView else { return nil }
        
        let dataSource = DataSource(collectionView: mainView.collectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier, for: indexPath) as? ProductImageCell else {
                return ProductImageCell()
            }
            
            cell.removeImage = { [weak self] in
                self?.deleteSnapshot(images: [itemIdentifier])
            }
            
            cell.configure(image: itemIdentifier)
            
            return cell
        }
        
        return dataSource
    }
    
    private func deleteSnapshot(images: [UIImage]) {
        snapshot?.deleteItems(images)
        guard let snapshot = snapshot else { return }
        
        dataSource?.apply(snapshot)
    }
    
    private func insertSnapshot(images: [UIImage]) {
        DispatchQueue.main.async { [self] in
            guard let lastItem = snapshot?.itemIdentifiers.last else { return }
            snapshot?.insertItems(images, beforeItem: lastItem)
            guard let snapshot = snapshot else { return }
            
            dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
}

// MARK: - ImageViewController Delegate

extension RegisterViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        guard let targetWidth = mainView?.collectionView.bounds.height else { return }
        
        let resizeImage = image.resize(newWidth: targetWidth)
        
        insertSnapshot(images: [resizeImage])
        picker.dismiss(animated: true)
    }
}

// MARK: - UIImage

private extension UIImage {
    func resize(newWidth: CGFloat) -> UIImage {
        let newHeight = newWidth
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
}

// MARK: - CollectionView Delegate

extension RegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard snapshot?.numberOfItems == indexPath.item + 1 else { return }
        
        view.endEditing(true)
        
        if snapshot?.numberOfItems == 6 {
            AlertDirector(viewController: self).createErrorAlert(message: "이미지를 더 추가할 수 없습니다.")
            return
        }
        
        AlertDirector(viewController: self).createImageSelectActionSheet { [weak self] _ in
            self?.albumButtonTapped()
        } cameraAction: { [weak self] _ in
            self?.cameraButtonTapped()
        }
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
