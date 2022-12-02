//
//  AddViewController.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/24.
//

import UIKit
import PhotosUI

final class AddViewController: UIViewController {
    private let addProductView = AddProductView()
    private let networkManager = NetworkManager()
    
    private var cellImages: [UIImage?] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.view = addProductView
        addProductView.collectionView.delegate = self
        addProductView.collectionView.dataSource = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - UI & UIAction
extension AddViewController {
    private func setupNavigationBar() {
        self.title = "상품등록"
        let cancelButtonItem = UIBarButtonItem(title: "Cancel",
                                               style: .plain,
                                               target: self,
                                               action: #selector(cancelButtonTapped))
        let doneButtonItem = UIBarButtonItem(title: "Done",
                                             style: .plain,
                                             target: self,
                                             action: #selector(doneButtonTapped))
        self.navigationItem.leftBarButtonItem = cancelButtonItem
        self.navigationItem.rightBarButtonItem = doneButtonItem
    }
    
    @objc func cancelButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneButtonTapped() {
        let result = addProductView.setupData()
        switch result {
        case .success(let data):
            guard let postURL = NetworkRequest.postData.requestURL else { return }
            networkManager.postData(to: postURL,
                                    newData: (productData: data, images: cellImages)) { result in
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        case .failure(let error):
            print(error)
        }
    }
}

// MARK: - ImageCollectionViewCellDelegate
extension AddViewController: ImageCollectionViewCellDelegate {
    func imageCollectionViewCell(_ isShowPicker: Bool) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        self.present(picker, animated: true, completion: nil)
    }
}

// MARK: - Extension UICollectionView
extension AddViewController: UICollectionViewDelegate {
    
}

extension AddViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellImages.count < 5 ? cellImages.count + 1 : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            let errorCell = UICollectionViewCell()
            return errorCell
        }
        cell.buttonDelegate = self
        
        if indexPath.item == cellImages.count {
            let view = cell.createButton()
            cell.stackView.addArrangedSubview(view)
        } else {
            let view = cell.createImageView()
            view.image = cellImages[indexPath.item]
            cell.stackView.addArrangedSubview(view)
        }

        return cell
    }
}

// MARK: - PHPickerViewControllerDelegate
extension AddViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        let itemProvides = results.compactMap { result in
            return result.itemProvider
        }
        
        for itemProvider in itemProvides {
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        self.cellImages.append(image as? UIImage)
                        self.addProductView.collectionView.reloadData()
                    }
                }
            }
        }
    }
}
