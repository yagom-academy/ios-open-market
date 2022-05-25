//
//  ModifyViewController.swift
//  OpenMarket
//
//  Created by 박세리 on 2022/05/25.
//

import UIKit

final class ModifyViewController: ManagingViewController {
    private let viewModel = ModifyViewModel()
    private let productDetail: ProductDetail
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpBarItems()
        setUpViewModel()
    }
    
    init(productDetail: ProductDetail) {
        self.productDetail = productDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews() {
        managingView.productNameTextField.text = productDetail.name
        managingView.productPriceTextField.text = String(productDetail.price)
        managingView.productDiscountedTextField.text = String(productDetail.discountedPrice)
        managingView.productStockTextField.text = String(productDetail.stock)
        managingView.productDescriptionTextView.text = productDetail.productsDescription
        viewModel.setUpImages(with: productDetail.images)
        
        if productDetail.currency == "KRW" {
            managingView.productCurrencySegmentedControl.selectedSegmentIndex = 0
        } else {
            managingView.productCurrencySegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    private func setUpBarItems() {
        managingView.setUpBarItem(title: "상품수정")
        managingView.navigationBarItem.leftBarButtonItem?.target = self
        managingView.navigationBarItem.leftBarButtonItem?.action = #selector(didTapCancelButton)
        
        managingView.navigationBarItem.rightBarButtonItem?.target = self
        managingView.navigationBarItem.rightBarButtonItem?.action = #selector(didTapDoneButton)
    }
    
    private func setUpViewModel() {
        viewModel.datasource = makeDataSource()
        viewModel.delegate = self
    }
    
    @objc private func didTapDoneButton() {
        if checkInputValidation() {
            // 수정해서 통신하는 로직
            self.dismiss(animated: true)
        }
    }
    
    private func checkInputValidation() -> Bool {
        guard managingView.productNameTextField.text?.count ?? 0 >= 3 else {
            showAlertInputError(with: .productNameIsTooShort)
            return false
        }
        
        guard let productPrice = Int(managingView.productPriceTextField.text ?? "0") else {
            showAlertInputError(with: .productPriceIsEmpty)
            return false
        }

        let discountedPrice = Int(managingView.productDiscountedTextField.text ?? "0") ?? 0
        
        guard productPrice >= discountedPrice else {
            showAlertInputError(with: .discountedPriceHigherThanPrice)
            return false
        }
        
        return true
    }
}

//MARK: extension

extension ModifyViewController {
    private func makeDataSource() -> UICollectionViewDiffableDataSource<ModifyViewModel.Section, ImageInfo> {
        let dataSource = UICollectionViewDiffableDataSource<ModifyViewModel.Section, ImageInfo>(
            collectionView: managingView.collectionView,
            cellProvider: { (collectionView, indexPath, image) -> UICollectionViewCell in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ProductsHorizontalCell.identifier,
                    for: indexPath) as? ProductsHorizontalCell else {
                    return UICollectionViewCell()
                }
                
                cell.updateImage(imageInfo: image)

                return cell
            })
        return dataSource
    }
}
