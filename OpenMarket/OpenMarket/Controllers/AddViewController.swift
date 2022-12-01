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
        print("tapped")
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
