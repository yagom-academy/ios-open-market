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
    
    private let networkManager = NetworkManager<Product>()
    
    private var mainView: EditView?
    private var dataSource: DataSource?
    private var snapshot: Snapshot?
    
    private let imagePickerController = UIImagePickerController()
    
    private let product: Product
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        mainView = EditView(frame: view.bounds)
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        requestData()
        configurePickerController()
        registerNotification()
    }

    deinit {
        removeNotification()
    }
    
    private func requestData() {
        guard let id = product.id else { return }
        
        let endPoint = EndPoint.requestProduct(id: id)
        
        networkManager.request(endPoint: endPoint) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                self.mainView?.configure(product: data)
                let imagesUrl = data.images?.compactMap { $0.url }
                imagesUrl?.forEach({ url in
                    self.requestImage(urlString: url)
                })
            case .failure(_):
                AlertDirector(viewController: self).createErrorAlert(message: "데이터를 불러오지 못했습니다.")
            }
        }
    }
    
    private func requestImage(urlString: String) {
        ImageManager.shared.downloadImage(urlString: urlString) { [weak self] result in
            switch result {
            case .success(let image):
                self?.applySnapshot(images: [image])
            case .failure(_):
                break
            }
        }
    }
    
    private func configureView() {
        configureCollectionView()
        configureNavigationBar()
    }
    
    private func configureCollectionView() {
        mainView?.collectionView.register(ProductImageCell.self, forCellWithReuseIdentifier: ProductImageCell.identifier)
        dataSource = makeDataSource()
        snapshot = makeSnapsnot()
    }
    
    private func configureNavigationBar() {
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonDidTapped))
        let rightBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonDidTapped))
        
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.title = "상품수정"
    }
    
    @objc private func cancelButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func doneButtonDidTapped() {
        
        guard let data = mainView?.allData() else { return }
        
        let endPoint = EndPoint.editProduct(id: product.id!, sendData: data)
        
        networkManager.request(endPoint: endPoint) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(_):
                AlertDirector(viewController: self).createErrorAlert(message: "데이터를 보내지 못했습니다.")
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
}

// MARK: - ImageViewController Delegate

extension EditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        insertSnapshot(images: [image])
        picker.dismiss(animated: true)
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
            
            cell.removeImage = { [weak self] in
                self?.deleteSnapshot(images: [itemIdentifier])
            }
            
            cell.configure(image: itemIdentifier)
            cell.hideRemoveButton()
            
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
