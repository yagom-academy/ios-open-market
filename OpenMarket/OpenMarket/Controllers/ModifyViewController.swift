//
//  ModifyViewController.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/12/03.
//

import UIKit

final class ModifyViewController: ProductViewController {
    private let maxImageNumber = 5
    private var modifyProductView = ModifyProductView()
    
    override var showView: ProductView {
        return modifyProductView
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar(title: "상품수정")
        self.view = showView
        showView.collectionView.delegate = self
        showView.collectionView.dataSource = self
    }
}

extension ModifyViewController {
    func setupOriginProductData() {
        // 데이터 불러와서 View에 데이터 바인드 해주는 메서드 - 추후 구현
    }
}

// MARK: - Extension UICollectionView
extension ModifyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellImages.count < maxImageNumber ? cellImages.count + 1 : maxImageNumber
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
        
        if indexPath.item != cellImages.count {
            let view = cell.createImageView()
            view.image = cellImages[indexPath.item]
            cell.stackView.addArrangedSubview(view)
        }

        return cell
    }
}
