//
//  AddViewController.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/24.
//

import UIKit

final class AddViewController: UIViewController {
    let addProductView = AddProductView()
    var cellCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.view = addProductView
        addProductView.collectionView.delegate = self
        addProductView.collectionView.dataSource = self
    }
}

// MARK: - UI & UIAction
extension AddViewController {
    private func setupNavigationBar() {
        self.title = "상품등록"
    }
}

extension AddViewController: UICollectionViewDelegate {
    // 피커뷰 실행
    // 셀갯수 한개 추가
    // 피커뷰 끝나면 컬렉션뷰 리로드
}

extension AddViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount + 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as? ImageCollectionViewCell else {
            let errorCell = UICollectionViewCell()
            return errorCell
        }
        // cell의 이미지에 가져온데이터를 넣나?
        return cell
    }
}
