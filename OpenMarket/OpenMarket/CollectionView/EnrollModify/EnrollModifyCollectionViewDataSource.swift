//
//  EnrollModifyCollectionViewDataSouce.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/10.
//

import UIKit
import Photos

class EnrollModifyCollectionViewDataSource: NSObject {
    private let compositionalLayout = CompositionalLayout()
    private let PlaceholderList: [String] =
        ["상품명", "화폐단위", "가격", "할인가격", "재고수량", "상세설명", "비밀번호"]
}

extension EnrollModifyCollectionViewDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == .zero {
            return 6
        }
        return PlaceholderList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == .zero && indexPath.section == .zero {
            guard let photoSelectCell = collectionView.dequeueReusableCell(withReuseIdentifier: EnrollModifyPhotoSeclectCell.identifier, for: indexPath) as? EnrollModifyPhotoSeclectCell else {
                return UICollectionViewCell()
            }
            return photoSelectCell
        }
        if indexPath.item != .zero && indexPath.section == .zero {
            guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: EnrollModifyPhotoCell.identifier, for: indexPath) as? EnrollModifyPhotoCell else {
                return UICollectionViewCell()
            }
            
            return photoCell
        } else {
            guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: EnrollModifyListCell.identifier, for: indexPath) as? EnrollModifyListCell else {
                return UICollectionViewCell()
            }
            let placeholderForItem = PlaceholderList[indexPath.item]
            listCell.configure(placeholderList: placeholderForItem)
            
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
                    cellVerticalSize: .fractionalHeight((1 - (1/6))/CGFloat(self.PlaceholderList.count)),
                    scrollDirection: .vertical,
                    cellMargin: listCellMargin,
                    viewMargin: listViewMargin)
            }
        }
    }
}
