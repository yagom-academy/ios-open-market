//
//  ProductRegistrationViewController.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/12/03.
//

import UIKit

final class ProductRegistrationViewController: ProductManagementViewController {
    private let productRegistrationTitle: String = "상품등록"
    var cancelBarButtonItem: UIBarButtonItem?
    var doneBarButtonItem: UIBarButtonItem?
    private let imagePickerButton: UIButton = {
        let button: UIButton = UIButton()

        button.setTitle("+", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray4

        return button
    }()
    private var registeredImages: [UIView]? {
        didSet {
            applyRegisteredImages()
        }
    }
    private var doneWorkItem: DispatchWorkItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        setUpNavigationBarButton()
        setUpViewsIfNeeded()
        setUpDelegateIfNeeded()
        imagePickerButton.addTarget(self, action: #selector(showImagePickerActionSheet), for: .touchUpInside)
        title = productRegistrationTitle
        registeredImages = []
    }
    
    private func setUpNavigationBarButton() {
        doneBarButtonItem = UIBarButtonItem(title: "done",
                                            style: .plain,
                                            target: self,
                                            action: #selector(tappedDoneButton))
        cancelBarButtonItem = UIBarButtonItem(title: "Cancel",
                                              style: .plain,
                                              target: self,
                                              action: #selector(tappedCancelButton))
        
        navigationItem.setRightBarButton(doneBarButtonItem, animated: false)
        navigationItem.setLeftBarButton(cancelBarButtonItem, animated: false)
    }
    
    private func presentAlbum() {
        let imagePickerController: UIImagePickerController = UIImagePickerController()

        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self

        present(imagePickerController, animated: true)
    }
    
    private func applyRegisteredImages() {
        guard let registeredImages = registeredImages else {
            return
        }
        
        var snapshot: NSDiffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, UIView>()
        snapshot.appendSections([.main])
        snapshot.appendItems(registeredImages)
        if snapshot.numberOfItems < 5 {
            snapshot.appendItems([imagePickerButton])
        }
        imageCollectionView.applySnapshot(snapshot)
    }
    
    private func resizedRegisteredImages() -> [UIImage]? {
        guard let registeredImages = registeredImages else {
            return nil
        }
        let resizedImages: [UIImage] = registeredImages.compactMap {
            return ($0 as? UIImageView)?.image
        }.compactMap {
            $0.size.width > 300 ? $0.resized(newWidth: 300) : $0
        }
        return resizedImages
    }
    
    private func showResultAlert(isSuccess: Bool) {
        let title: String = isSuccess ? "상품 등록 성공" : "상품 등록 실패"
        let resultAlertController: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        let alertAction: UIAlertAction
        if isSuccess {
            alertAction = UIAlertAction(title: "확인", style: .cancel) { [weak self] (_) in
                self?.navigationController?.popViewController(animated: false)
            }
        } else {
            alertAction = UIAlertAction(title: "확인", style: .cancel)
        }
        resultAlertController.addAction(alertAction)
        
        present(resultAlertController, animated: true)
    }
    
    @objc private func showImagePickerActionSheet() {
        let imagePickerActionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let albumAlertAction: UIAlertAction = UIAlertAction(title: "앨범", style: .default) { [weak self] (_) in
            self?.presentAlbum()
        }
        let cancelAlertAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel)
        imagePickerActionSheetController.addAction(albumAlertAction)
        imagePickerActionSheetController.addAction(cancelAlertAction)
        
        present(imagePickerActionSheetController, animated: true)
    }
    
    @objc
    private func tappedCancelButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

    @objc
    private func tappedDoneButton(_ sender: UIBarButtonItem) {
        guard doneWorkItem == nil,
              let product: Product = makeProductByInputedData(),
              let images: [UIImage] = resizedRegisteredImages(), images.isEmpty == false else {
            return
        }
        let workItem: DispatchWorkItem = DispatchWorkItem {
            let registrationManager = NetworkManager(openMarketAPI: .registration(product: product, images: images))
            registrationManager.network { [weak self] data, error in
                if let error = error {
                    print(error.localizedDescription)
                    self?.doneWorkItem = nil
                    self?.showResultAlert(isSuccess: false)
                } else if let _ = data {
                    DispatchQueue.main.async {
                        self?.doneWorkItem = nil
                        self?.showResultAlert(isSuccess: true)
                    }
                }
            }
        }
        
        doneWorkItem = workItem
        DispatchQueue.global().async(execute: workItem)
    }
}

extension ProductRegistrationViewController: ProductManagementNavigationBarButtonProtocol { }

extension ProductRegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            registeredImages?.append(UIImageView(image: image))
        }
        dismiss(animated: true)
    }
}
