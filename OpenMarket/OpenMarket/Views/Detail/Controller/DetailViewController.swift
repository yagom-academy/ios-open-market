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
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var bagainPriceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    @IBOutlet private weak var createdAtLabel: UILabel!
    @IBOutlet private weak var vendorLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNotification()
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
    
    private func setUpNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateDetailView),
            name: .updateDetail,
            object: nil)
    }
    
    @objc private func updateDetailView() {
        guard let data = data else {
            return
        }
        requestDetail(productId: UInt(data.id))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationViewController = segue.destination as? UINavigationController,
              let nextViewController = navigationViewController.topViewController as? EditViewController,
              let product = sender as? Product else {
                  return
              }
        nextViewController.setUpModifyMode(product: product, images: images)
    }
    
    @IBAction func tappedEditButton(_ sendor: UIButton) {
        let modityAction = UIAlertAction(title: AlertConstant.modify, style: .default) { _ in
            self.alertInputPassword { secret in
                self.requestModification(secret: secret) { isSuccess in
                    if isSuccess {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: SegueIdentifier.modifiyView, sender: self.data)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(message: AlertMessage.wrongPassword)
                        }
                    }
                }
            }
            
        }
        let deleteAction = UIAlertAction(title: AlertConstant.delete, style: .destructive)
        let cancelAction = UIAlertAction(title: AlertConstant.cancle, style: .cancel)
        let alert = UIAlertController(title: nil, message: AlertMessage.editProduct, preferredStyle: .actionSheet)
        alert.addAction(modityAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func requestModification(secret: String, completion: @escaping (Bool) -> Void) {
        guard let request = requestModify(secert: secret) else {
            showAlert(message: Message.badRequest) {
                self.dismiss(animated: true)
            }
            return
        }
        let networkManager = NetworkManager()
        networkManager.fetch(request: request, decodingType: Product.self) { result in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    private func requestModify(secert: String) -> URLRequest? {
        guard let data = data else {
            return nil
        }
        let parmas = ProductModification(secert: secert)
        let networkManager = NetworkManager()
        let requestResult = networkManager.requestModify(data: parmas, id: UInt(data.id))
        switch requestResult {
        case .success(let request):
            return request
        case .failure:
            return nil
        }
    }
}
