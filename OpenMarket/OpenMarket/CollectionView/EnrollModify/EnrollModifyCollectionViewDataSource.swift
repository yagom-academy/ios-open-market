//
//  EnrollModifyCollectionViewDataSouce.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/10.
//

import UIKit

class EnrollModifyCollectionViewDataSource: NSObject {
    private let compositionalLayout = CompositionalLayout()
}

extension EnrollModifyCollectionViewDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: EnrollModifyPhotoCell.Identifier, for: indexPath) as? EnrollModifyPhotoCell else {
                return UICollectionViewCell()
            }
            return photoCell
        } else {
            guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: EnrollModifyListCell.Identifier, for: indexPath) as? EnrollModifyListCell else {
                return UICollectionViewCell()
            }
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
                    portraitHorizontalNumber: 3,
                    landscapeHorizontalNumber: 5,
                    cellVerticalSize: .fractionalHeight(1/5),
                    scrollDirection: .horizontal,
                    cellMargin: phothCellMargin,
                    viewMargin: photoViewMargin)
            default:
                let listCellMargin = self.compositionalLayout.margin(
                    top: 5, leading: 0, bottom: 5, trailing: 5)
                let listViewMargin = self.compositionalLayout.margin(
                    top: 0, leading: 5, bottom: 0, trailing: 0)
                return self.compositionalLayout.enrollLayout(
                    portraitHorizontalNumber: 1,
                    landscapeHorizontalNumber: 1,
                    cellVerticalSize: .fractionalHeight((1 - (1/5))/10),
                    scrollDirection: .vertical,
                    cellMargin: listCellMargin,
                    viewMargin: listViewMargin)
            }
        }
    }
}
