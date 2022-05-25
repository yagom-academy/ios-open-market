//
//  RegisterViewController.swift
//  OpenMarket
//
//  Created by dudu, safari on 2022/05/24.
//

import UIKit

final class RegisterViewController: ProductViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        applySnapshot(images: [UIImage(named: "plus")!])
        configurePickerController()
        registerNotification()
    }
    
    override func configureCollectionView() {
        super.configureCollectionView()
        mainView?.collectionView.delegate = self
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        navigationItem.title = "상품등록"
    }
    
    @objc override func cancelButtonDidTapped() {
        dismiss(animated: true)
    }
    
    @objc override func doneButtonDidTapped() {
        
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
    
    private func multipartFormData() -> Data? {
        guard let snapshot = snapshot else { return nil }
        guard let uploadProduct = mainView?.allData() else { return nil }

        let images = snapshot.itemIdentifiers[0..<snapshot.numberOfItems - 1]
        let imageDatas = images.compactMap { $0.jpegData(compressionQuality: 0.5) }
        
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
}

private extension Data {
    mutating func appendString(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        append(data)
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
}
