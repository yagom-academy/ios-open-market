//
//  EnrollModifyCollectionViewDataSouce.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/10.
//

import UIKit

class EnrollModifyCollectionViewDataSource: NSObject {
    
    private let photoAlboumViewController = PhotoAlbumViewController()
    private let compositionalLayout = CompositionalLayout()
    var placeholderList: [String] = []
    var photoAlbumImages: [UIImage] = []
    var photoSelectButton: [UIButton] = []
    var medias: [Media] = []
}

extension EnrollModifyCollectionViewDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if section == .zero {
            return photoAlbumImages.count + photoSelectButton.count
        }
        return placeholderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == .zero && indexPath.section == .zero {
            guard let photoSelectCell =
                    collectionView.dequeueReusableCell(withReuseIdentifier: EnrollModifyPhotoSeclectCell.identifier, for: indexPath) as? EnrollModifyPhotoSeclectCell else {
                return UICollectionViewCell()
            }
            let btn = photoSelectButton[indexPath.item]
            photoSelectCell.configure(photoSelectButton: btn)
            
            return photoSelectCell
        }
        if indexPath.item != .zero && indexPath.section == .zero {
            guard let photoCell =
                    collectionView.dequeueReusableCell(withReuseIdentifier: EnrollModifyPhotoCell.identifier, for: indexPath) as? EnrollModifyPhotoCell else {
                return UICollectionViewCell()
            }
            let photoAlbumImageForItem = photoAlbumImages[indexPath.item - 1]
            photoCell.configure(image: photoAlbumImageForItem)
            
            return photoCell
        } else {
            guard let listCell =
                    collectionView.dequeueReusableCell(withReuseIdentifier: EnrollModifyListCell.identifier, for: indexPath) as? EnrollModifyListCell else {
                return UICollectionViewCell()
            }
            let placeholderForItem = placeholderList[indexPath.item]
            listCell.configure(
                placeholderList: placeholderForItem.description, dataSource: self)
            
            return listCell
        }
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                let phothCellMargin = self.compositionalLayout.margin(
                    top: 5, leading: 0, bottom: 5, trailing: 5)
                let photoViewMargin = self.compositionalLayout.margin(
                    top: 0, leading: 5, bottom: 0, trailing: 0)
                return self.compositionalLayout.enrollLayout(
                    portraitHorizontalNumber: 4,
                    landscapeHorizontalNumber: 4,
                    cellVerticalSize: .fractionalHeight(1/6),
                    scrollDirection: .horizontal,
                    cellMargin: phothCellMargin,
                    viewMargin: photoViewMargin)
            default:
                let listCellMargin = self.compositionalLayout.margin(
                    top: 0, leading: 0, bottom: 0, trailing: 5)
                let listViewMargin = self.compositionalLayout.margin(
                    top: 0, leading: 5, bottom: 0, trailing: 0)
                return self.compositionalLayout.enrollLayout(
                    portraitHorizontalNumber: 1,
                    landscapeHorizontalNumber: 1,
                    cellVerticalSize: .fractionalHeight((1 - (1/6))/CGFloat(self.placeholderList.count)),
                    scrollDirection: .vertical,
                    cellMargin: listCellMargin,
                    viewMargin: listViewMargin)
            }
        }
    }
    
    func PassListCellData(
        collectionView: UICollectionView) -> [String: String?] {
        var textFieldDataPass: [String: String?] = [:]
        for row in 0 ..< collectionView.numberOfItems(inSection: 1) {
            let indexPath = NSIndexPath(row: row, section: 1)
            guard let cell =
                    collectionView.cellForItem(at: indexPath as IndexPath) as? EnrollModifyListCell else {return ["": ""]}
            textFieldDataPass[placeholderList[indexPath.item]] =
                cell.listTextField.text
        }
        return textFieldDataPass
    }
    
    func passPhotoImage(images: [UIImage]) {
        for image in images {
            guard let media =
                    Media(image: image, mimeType: .png) else { return }
            medias.append(media)
        }
    }
}
