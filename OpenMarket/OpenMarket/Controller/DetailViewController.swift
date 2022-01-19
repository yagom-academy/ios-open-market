//
//  DetailViewController.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/19.
//

import UIKit

class DetailViewController: UIViewController {
    private var images = [UIImage]()
    var data: Product?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bagainPriceLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationViewController = segue.destination as? UINavigationController,
              let nextViewController = navigationViewController.topViewController as? RegisterViewController,
              let product = sender as? Product else {
                  return
              }
        nextViewController.setUpState()
        nextViewController.setUpData(product)
    }
    
    func requestDetail(productId: UInt) {
        let networkManager: NetworkManager = NetworkManager()
        guard let request = networkManager.requestDetailSearch(id: productId) else {
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
        DispatchQueue.main.async {
            self.nameLabel.text = product.name
            self.priceLabel.text = product.price.description
            self.bagainPriceLabel.text = product.bargainPrice.description
            self.stockLabel.text = product.stock.description
            self.createdAtLabel.text = product.createdAt
            self.vendorLabel.text = product.createdAt
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
