//
//  EditViewController.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/24.
//

import UIKit

final class EditViewController: ProductViewController {
    private let product: Product
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        requestData()
        registerNotification()
    }
    
    // MARK: - Configure
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.title = "상품수정"
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
    
    @objc override func cancelButtonDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc override func doneButtonDidTapped() {
        guard let data = mainView?.makeEncodableModel() else { return }
        guard let id = product.id else { return }
        
        let endPoint = EndPoint.editProduct(id: id, sendData: data)
        
        networkManager.request(endPoint: endPoint) { [weak self] (result: Result<Product, NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.delegate?.refreshData()
                    self.navigationController?.popViewController(animated: true)
                }
            case .failure(_):
                AlertDirector(viewController: self).createErrorAlert(message: "데이터를 보내지 못했습니다.")
            }
        }
    }
    
    // MARK: - NetWork Method

    private func requestData() {
        guard let id = product.id else { return }
        
        let endPoint = EndPoint.requestProduct(id: id)
        
        networkManager.request(endPoint: endPoint) { [weak self] (result: Result<Product, NetworkError>) in
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
    
    // MARK: - CollectionView DataSource
    
    override func makeDataSource() -> DataSource? {
        guard let mainView = mainView else { return nil }
        
        let dataSource = DataSource(collectionView: mainView.collectionView) { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCell.identifier, for: indexPath) as? ProductImageCell else {
                return ProductImageCell()
            }

            cell.configure(image: itemIdentifier)
            cell.hideRemoveButton()
            
            return cell
        }
        
        return dataSource
    }
}
