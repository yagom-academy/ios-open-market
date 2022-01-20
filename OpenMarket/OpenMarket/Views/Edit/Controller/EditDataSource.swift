//
//  RegisterDataSource.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/19.
//

import UIKit

class EditDataSource: NSObject {
    private(set) var images = [UIImage]()
    private(set) var state: EditMode
    
    init(state: EditMode) {
        self.state = state
    }
    
    func setUpModify(_ images: [UIImage]) {
        self.state = .modify
        self.images = images
    }
    
    func imagesRemove(at index: Int) {
        images.remove(at: index)
    }
    
    func imagesAppend(_ image: UIImage) {
        images.append(image)
    }
    
    func createImageFiles() -> [ImageFile]? {
        var imageFiles = [ImageFile]()
        
        images.forEach { image in
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                return
            }
            let imageFile = ImageFile(name: UUID().uuidString, data: imageData, type: .jpeg)
            imageFiles.append(imageFile)
        }
        guard imageFiles.isEmpty == false else {
            return nil
        }
        return imageFiles
    }
}

extension EditDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCell.identifier,
            for: indexPath
        ) as? ImageCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = images[indexPath.item]
        if state == .modify {
            cell.deleteButton.isHidden = true
        } else {
            cell.deleteButton.isHidden = false
        }
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ImageAddHeaderView.identifier,
            for: indexPath
        ) as? ImageAddHeaderView else {
            return UICollectionReusableView()
        }
        return headerView
    }
}
