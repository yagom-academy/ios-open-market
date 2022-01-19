//
//  RegisterDataSource.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/19.
//

import UIKit

class RegisterDataSource: NSObject {
    var images = [UIImage]()
    
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

extension RegisterDataSource: UICollectionViewDataSource {
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
