//
//  ItemEditViewController.swift
//  OpenMarket
//
//  Created by 노유빈 on 2022/12/02.
//

import UIKit

class ItemEditViewController: ItemViewController {
    // MARK: - Property
    var itemId: Int?
    var item: Item?

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItem()
    }
}

extension ItemEditViewController {
    // MARK: - Method
    override func configureNavigation() {
        super.configureNavigation()
        self.navigationItem.title = "상품수정"
    }
    
    private func fetchItem() {
        guard let itemId = itemId else { return }

        LoadingController.showLoading()
        networkManager.fetchItem(productId: itemId) { result in
            switch result {
            case .success(let item):
                LoadingController.hideLoading()
                self.item = item

                DispatchQueue.main.async {
                    self.configureData()
                }
            case .failure(let error):
                LoadingController.hideLoading()
                print(error)
            }
        }
    }

    private func configureData() {
        guard let item = item else { return }

        itemNameTextField.text = item.name
        priceTextField.text = String(item.price)
        discountedPriceTextField.text = String(item.discountedPrice)
        descriptionTextView.text = item.pageDescription
        stockTextField.text = String(item.stock)
        currencySegmentedControl.selectedSegmentIndex = (item.currency == .krw ? 0 : 1)

        item.images?.forEach {
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
    override func doneButtonTapped() {
        let priceText = priceTextField.text ?? "0"
        let discountedPriceText = discountedPriceTextField.text ?? "0"
        let stockText = stockTextField.text ?? "0"

        guard !isPost else {
            showAlert(title: "경고", message: "처리 중 입니다.", actionTitle: "확인", dismiss: false)
            return
        }
        guard itemImages.count > 0 else {
            showAlert(title: "경고", message: "이미지를 등록해주세요.", actionTitle: "확인", dismiss: false)
            return
        }

        guard let itemNameText =  itemNameTextField.text,
              itemNameText.count > 2 else {
            showAlert(title: "경고", message: "제목을 3글자 이상 입력해주세요.", actionTitle: "확인", dismiss: false)
            return
        }


        guard let price = Double(priceText),
              let discountPrice = Double(discountedPriceText),
              let stock = Int(stockText) else {
            showAlert(title: "경고", message: "유효한 숫자를 입력해주세요", actionTitle: "확인", dismiss: false)
            return
        }

        guard let descriptionText = descriptionTextView.text,
              descriptionText.count <= 1000 else {
            showAlert(title: "경고", message: "내용은 1000자 이하만 등록가능합니다.", actionTitle: "확인", dismiss: false)
            return
        }

        let params: [String: Any] = ["name": itemNameText,
                                     "price": price,
                                     "currency": currencySegmentedControl.selectedSegmentIndex == 0
                                                    ? Currency.krw.rawValue: Currency.usd.rawValue,
                                     "discounted_price": discountPrice,
                                     "stock": stock,
                                     "description": descriptionText,
                                     "secret": NetworkManager.secret]
        self.isPost = true
        LoadingController.showLoading()
        networkManager.editItem(productId: itemId!, params: params) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    LoadingController.hideLoading()
                    self.showAlert(title: "성공", message: "등록에 성공했습니다", actionTitle: "확인", dismiss: true)
                }
            case .failure(_):
                DispatchQueue.main.async {
                    LoadingController.hideLoading()
                    self.showAlert(title: "실패", message: "등록에 실패했습니다", actionTitle: "확인", dismiss: false)
                }
            }
            self.isPost = false
        }
    }
}
