//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/24.
//

import UIKit

private enum Section {
    case main
}

final class RegisterViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UIImage>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UIImage>
    
    private let networkManager = NetworkManager<Product>()
    
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
        applySnapshot(images: [UIImage(named: "plus")!])
        configurePickerController()
        registerNotification()
    }

    deinit {
        removeNotification()
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
        
        guard let sendData = multipartFormData() else { return }
        
        let endPoint = EndPoint.createProduct(sendData: sendData)
        
        networkManager.request(endPoint: endPoint) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            case .failure(_):
                AlertDirector(viewController: self).createErrorAlert(message: "데이터를 등록하지 못했습니다.")
            }
        }
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotification() {
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
    
    private func multipartFormData() -> Data? {
        guard let snapshot = snapshot else { return nil }
        guard let uploadProduct = mainView?.allData() else { return nil }

        let images = snapshot.itemIdentifiers[0..<snapshot.itemIdentifiers.count - 1]
        let imageDatas = images.compactMap { $0.jpegData(compressionQuality: 1.0) }
        
        var data = Data()
        let boundary = EndPoint.boundary
        let fileName = "safari"

        let newLine = "\r\n"
        let boundaryPrefix = "--\(boundary)\r\n"
        let boundarySuffix = "\r\n--\(boundary)--\r\n"
        
        data.appendString(boundaryPrefix)
        data.appendString("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
        data.append(try! JSONEncoder().encode(uploadProduct))
        data.appendString(newLine)
        
        for imageData in imageDatas {
            data.appendString(boundaryPrefix)
            data.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName).jpg\"\r\n")
            data.appendString("Content-Type: image/jpg\r\n\r\n")
            data.append(imageData)
            data.appendString(newLine)
        }
        
        data.appendString(boundarySuffix)
        return data
    }
}

private extension Data {
    mutating func appendString(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        append(data)
    }
}

// MARK: - ImageViewController Delegate

extension RegisterViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        insertSnapshot(images: [image])
        picker.dismiss(animated: true)
    }
}

// MARK: - CollectionView Delegate

extension RegisterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard snapshot?.numberOfItems == indexPath.item + 1 else { return }
        
        view.endEditing(true)
        
        AlertDirector(viewController: self).createImageSelectActionSheet { [weak self] _ in
            self?.albumButtonTapped()
        } cameraAction: { [weak self] _ in
            self?.cameraButtonTapped()
        }
    }
}

// MARK: - CollectionView DataSource

extension RegisterViewController {
    private func makeDataSource() -> DataSource? {
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

