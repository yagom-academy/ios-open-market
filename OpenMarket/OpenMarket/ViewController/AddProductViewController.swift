//
//  ProductViewController.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/27.
//

import UIKit

class AddProductViewController: UIViewController {
    private let productView = AddProductView()
    private lazy var dataSource = [UIImage(named: "바보전구"), UIImage(named: "바보전구"), UIImage(named: "바보전구"), UIImage(named: "바보전구"), UIImage(systemName: "plus")]

    override func loadView() {
        super.loadView()
        view = productView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        productView.collectionView.dataSource = self
    }

    func configureUI() {
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(goBack))
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(goBackWithUpdate))
        navigationItem.title = "상품등록"
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = doneBarButton
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc private func goBackWithUpdate() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddProductViewController: UICollectionViewDataSource {
    func collectionView( _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataSource.count
    }

    func collectionView( _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddProductCollectionViewCell.id, for: indexPath) as? AddProductCollectionViewCell ?? AddProductCollectionViewCell()
        cell.productImageButton.setImage(dataSource[indexPath.item], for: .normal)
        return cell
    }
}
