//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by Mangdi, Woong on 2022/12/09.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var stock: UILabel!
    @IBOutlet weak var bargainPrice: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout()
    private let networkCommunication = NetworkCommunication()
    var detailProductData: DetailProduct?
    var detailProductImages: [Image] = []
    var productID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CustomCollectionViewPageCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionViewPageCell")
        
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(selectModifyOrDeleteProduct))
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProductDetailData(productID: productID)
        settingCollectionView()
    }
    
    @objc private func selectModifyOrDeleteProduct() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let modifyAction = UIAlertAction(title: "수정", style: .default) { [weak self] _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let registerProductViewController = storyboard.instantiateViewController(
                withIdentifier: "registerProductViewController") as? RegisterProductViewController,
                  let id = self?.productID,
                  let images = self?.detailProductImages else { return }
            registerProductViewController.mode = "patch"
            registerProductViewController.productID = id
            registerProductViewController.patchImages = images
            registerProductViewController.modalPresentationStyle = .fullScreen
            self?.present(registerProductViewController, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            print("삭제 선택")
            self?.showDeleteAlert()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(modifyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func showDeleteAlert() {
        let requestDeleteAlert = UIAlertController(title: "암호를 입력해주세요", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            let inputValue = requestDeleteAlert.textFields?[0].text
            guard inputValue == Secret.password else {
                self?.showAlert(message: "암호가 일치하지 않습니다.", isBack: false)
                return
            }
            self?.getProductDeleteUriDataAndRequestDeleteProduct()
        }
        requestDeleteAlert.addTextField { passwordTextField in
            passwordTextField.placeholder = "암호 입력"
        }
        requestDeleteAlert.addAction(cancelAction)
        requestDeleteAlert.addAction(deleteAction)
        present(requestDeleteAlert, animated: true)
    }
    
    private func showAlert(message: String, isBack: Bool) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = isBack ?
        UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        :
        UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func getProductDeleteUriDataAndRequestDeleteProduct() {
        networkCommunication.requestPostUriInqueryData(
            url: ApiUrl.Path.detailProduct + String(productID) + ApiUrl.Path.uriInquery,
            secret: Secret.password
        ) { [weak self] result in
            switch result {
            case .success(let data):
                guard let address = String(data: data, encoding: .utf8) else { return }
                self?.requestDeleteProduct(url: ApiUrl.host + address)
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(message: "<<\(error.rawValue)>>\n자신이 등록한 상품만 삭제할 수 있습니다.",
                                    isBack: false)
                }
            }
        }
    }
    
    private func requestDeleteProduct(url: String) {
        networkCommunication.requestDeleteData(url: url) { [weak self] result in
            switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    self?.showAlert(message: "\(message)\n상품이 삭제되었습니다!", isBack: true)
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func getProductDetailData(productID: Int) {
        let url = ApiUrl.Path.detailProduct + String(productID)
        networkCommunication.requestProductsInformation(
            url: url,
            type: DetailProduct.self
        ) { [weak self] data in
            switch data {
            case .success(let data):
                self?.detailProductData = data
                self?.detailProductImages = data.images
                DispatchQueue.main.async {
                    self?.settingDetailData()
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print("에러가나와용")
                print(error.rawValue)
            }
        }
    }
    
    private func settingDetailData() {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let detailProductData = detailProductData,
              let priceText = numberFormatter.string(for: detailProductData.price),
              let bargainPriceText = numberFormatter.string(for: detailProductData.bargainPrice) else { return }
        navigationItem.title = detailProductData.name
        productName.text = detailProductData.name
        price.text = "\(detailProductData.currency) \(priceText)"
        
        if detailProductData.bargainPrice <= 0 || detailProductData.price <= detailProductData.bargainPrice {
            bargainPrice.text = ""
            price.textColor = UIColor.systemGray
        } else {
            guard let priceText = price.text else { return }
            let attributeText = NSMutableAttributedString(string: priceText)
            attributeText.addAttribute(.strikethroughStyle,
                                       value: NSUnderlineStyle.single.rawValue,
                                       range: NSMakeRange(0, attributeText.length))
            price.attributedText = attributeText
            bargainPrice.text = "\(detailProductData.currency) \(bargainPriceText)"
            price.textColor = UIColor.systemRed
        }
        
        if detailProductData.stock > 0 {
            stock.text = "잔여수량 : \(detailProductData.stock)"
            stock.textColor = UIColor.systemGray
        } else {
            stock.text = "품절"
            stock.textColor = UIColor.systemYellow
        }
        
        productDescription.text = detailProductData.description
    }
    
    private func settingCollectionView() {
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = collectionViewFlowLayout
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
    }
}

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailProductImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell: CustomCollectionViewPageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionViewPageCell", for: indexPath) as? CustomCollectionViewPageCell ?? CustomCollectionViewPageCell()
        let image = detailProductImages[indexPath.item]
        customCell.configureCell(image: image, index: indexPath.item, totalCount: detailProductImages.count)
        return customCell
    }
}

extension ProductDetailViewController: UICollectionViewDelegate {
}
