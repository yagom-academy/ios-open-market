//
//  AddViewController.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/24.
//

import UIKit
import PhotosUI

class AddViewController: RootProductViewController {
    var addProductView = AddProductView()
    
    override var showView: RootProductView {
        get {
            return self.addProductView
        }
        set {
            if let view = newValue as? AddProductView {
                self.addProductView = view
            }
        }
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "상품등록")
        self.view = showView
        showView.collectionView.delegate = self
        showView.collectionView.dataSource = self
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


// MARK: - Extension UICollectionView
extension AddViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellImages.count < 5 ? cellImages.count + 1 : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier,
            for: indexPath) as? ImageCollectionViewCell
        else {
            self.showAlert(alertText: NetworkError.data.description,
                           alertMessage: "오류가 발생했습니다.",
                           completion: nil)
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
