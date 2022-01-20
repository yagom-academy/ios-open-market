//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/19.
//

import UIKit

class DetailViewController: UIViewController {
    var data: Product?
    private var images = [UIImage]()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bagainPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNotification()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationViewController = segue.destination as? UINavigationController,
              let nextViewController = navigationViewController.topViewController as? RegisterViewController,
              let product = sender as? Product else {
                  return
              }
        nextViewController.setUpModifyMode(product: product, images: images)
    }
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateDetailView), name: .updateDetail, object: nil)
    }
    
    @objc func updateDetailView() {
        guard let data = data else {
            return
        }
        requestDetail(productId: UInt(data.id))
    }
    
    func requestDetail(productId: UInt) {
        let networkManager: NetworkManager = NetworkManager()
        guard let request = networkManager.requestDetailSearch(id: UInt(productId)) else {
            showAlert(message: Message.badRequest)
            return
        }
        networkManager.fetch(request: request, decodingType: Product.self) { result in
            switch result {
            case .success(let product):
                self.setUpViews(product: product)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    func setUpViews(product: Product) {
        data = product
        setUpImages()
        DispatchQueue.main.async {
            self.nameLabel.text = product.name
            self.priceLabel.text = product.price.description
            self.bagainPriceLabel.text = product.bargainPrice.description
            self.stockLabel.text = product.stock.description
            self.createdAtLabel.text = product.createdAt
            self.vendorLabel.text = product.createdAt
            self.descriptionLabel.text = product.description
        }
    }
    
    private func setUpImages() {
        guard let newImages = data?.images else {
            return
        }
        newImages.forEach { newImage in
            if let cachedImage = ImageManager.shared.loadCachedData(for: newImage.url) {
                self.images.append(cachedImage)
            } else {
                ImageManager.shared.downloadImage(with: newImage.url) { image in
                    ImageManager.shared.setCacheData(of: image, for: newImage.url)
                    self.images.append(image)
                }
            }
        }
    }
    
    @IBAction func tappedEditButton(_ sendor: UIButton) {
        let modityAction = UIAlertAction(title: "수정", style: .default) { _ in
            self.performSegue(withIdentifier: "ModifyView", sender: self.data)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let alert = UIAlertController(title: nil, message: "상품을 편집하시겠습니까?", preferredStyle: .actionSheet)
        alert.addAction(modityAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
        
    }
}
