//
//  ItemEditViewController.swift
//  OpenMarket
//
//  Created by 노유빈 on 2022/12/02.
//

import UIKit

final class ItemEditViewController: ItemViewController {
    // MARK: - Property
    var itemId: Int?
    var item: Item?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItem()
    }
}

// MARK: - Method
extension ItemEditViewController {
    override func configureNavigation() {
        super.configureNavigation()
        self.navigationItem.title = "상품수정"
    }
    
    private func fetchItem() {
        guard let itemId = itemId else { return }
        
        LoadingController.showLoading()
        networkManager.fetchItem(productId: itemId) { result in
            LoadingController.hideLoading()

            switch result {
            case .success(let item):
                self.item = item
                
                DispatchQueue.main.async {
                    self.configureUIValue()
                    self.configureImageValue()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.retryAlert()
                }
            }
        }
    }

    private func retryAlert() {
        let alert = UIAlertController(title: "통신 실패", message: "데이터를 받아오지 못했습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "다시 시도", style: .default, handler: { _ in
            self.fetchItem()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: { _ in
            self.dismiss(animated: false)
        }))
        self.present(alert, animated: false)
    }

    private func configureImageValue() {
        guard let images = item?.images else { return }

        images.forEach {
            guard let url = URL(string: $0.url) else { return }
            networkManager.fetchImage(url: url) { image in
                self.itemImages.append(image)
                DispatchQueue.main.async {
                    let imageView = UIImageView()
                    imageView.image = image
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
                    imageView.heightAnchor.constraint(equalToConstant: 130).isActive = true

                    self.imageStackView.addArrangedSubview(imageView)
                }
            }
        }
    }

    private func configureUIValue() {
        guard let item else { return }

        itemNameTextField.text = item.name
        priceTextField.text = String(item.price)
        discountedPriceTextField.text = String(item.discountedPrice)
        descriptionTextView.text = item.pageDescription
        stockTextField.text = String(item.stock)
        currencySegmentedControl.selectedSegmentIndex = (item.currency == .krw ? 0 : 1)
    }

    override func doneButtonTapped() {
        guard let parameter = createParameter() else { return }
                
        self.isPost = true
        LoadingController.showLoading()
        networkManager.editItem(productId: itemId!, parameter: parameter) { result in
            LoadingController.hideLoading()

            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "성공", message: "등록에 성공했습니다", actionTitle: "확인", dismiss: true)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.showAlert(title: "실패", message: "등록에 실패했습니다", actionTitle: "확인", dismiss: false)
                }
            }

            self.isPost = false
        }
    }
}
