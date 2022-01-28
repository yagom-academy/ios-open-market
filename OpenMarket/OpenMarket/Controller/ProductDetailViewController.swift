//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/24.
//

import UIKit

protocol Delegate {
  func setNavigationTitle(name: String?)
  func setUpLabelView(prodcutInfo: Product?)
}

class ProductDetailViewController: UIViewController, ReuseIdentifying, Delegate {
  
  @IBOutlet weak var imageScrollView: UIScrollView!
  @IBOutlet weak var imagePageControl: UIPageControl!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var stockLabel: UILabel!
  @IBOutlet weak var fixedPriceLabel: UILabel!
  @IBOutlet weak var bargainPriceLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  var vc: ProductRegistrationModificationViewController?
  private let api = APIManager(urlSession: URLSession(configuration: .default), jsonParser: JSONParser())
  var product: Product?
  //var productId: Int?
  private var productImages: [UIImage] = []
  
  private let identifier = "3be89f18-7200-11ec-abfa-25c2d8a6d606"
  private let secret = "-7VPcqeCv=Xbu3&P"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationTitle(name: product?.name)
    setUpLabelView(prodcutInfo: product)
    fetchData(productId: product?.id)
  }
  
  func setNavigationTitle(name: String?) {
    navigationItem.title = name
  }
  
  @IBAction func etcButtonDidTap(_ sender: Any) {
    actionSheetAlert()
  }
  
  func setUpLabelView(prodcutInfo: Product?) {
    guard let product = prodcutInfo else {
      return
    }
    nameLabel.text = product.name
    fixedPriceLabel.attributedText = product.formattedFixedPrice.strikeThrough(strikeTarget: product.formattedFixedPrice)
    bargainPriceLabel.text = product.formattedBargainPrice
    if product.formattedFixedPrice == product.formattedBargainPrice {
      fixedPriceLabel.isHidden = true
    } else {
      fixedPriceLabel.isHidden = false
    }
    if product.formattedStock == "품절" {
      stockLabel.textColor = .orange
    } else {
      stockLabel.textColor = .darkGray
    }
    stockLabel.text = product.formattedStock
    descriptionLabel.text = product.description
  }
}

extension ProductDetailViewController {
  func fetchData(productId: Int?) {
    guard let productId = productId else {
      return
    }
    api.detailProduct(productId: productId) { [self] response in
      switch response {
      case .success(let data):
        product = data
        DispatchQueue.main.async {
          setUpImageView(imageCount: product?.images?.count)
          insertImageAtScrollView()
        }
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func setUpImageView(imageCount: Int?) {
    guard let imageCount = imageCount else {
      return
    }
    setUpImagePageControl(imageCount: imageCount)
    setUpScrollView(imageCount: imageCount)
  }
  
  func setUpImagePageControl(imageCount: Int) {
    imagePageControl.currentPage = 0
    imagePageControl.numberOfPages = imageCount
  }
  
  func setUpScrollView(imageCount: Int) {
    imageScrollView.contentSize = CGSize(
      width: (UIScreen.main.bounds.width - 16) * CGFloat(imageCount),
      height: UIScreen.main.bounds.width - 16
    )
  }
  
  func insertImageAtScrollView() {
    guard let images = product?.images else {
      return
    }
    for (index, image) in images.enumerated() {
      api.requestProductImage(url: image.url) { [self] response in
        switch response {
        case .success(let data):
          guard let image = UIImage(data: data) else {
            return
          }
          productImages.append(image)
          DispatchQueue.main.async {
            let imageView = UIImageView(image: image)
            imageView.frame = imageScrollView.frame
            imageView.frame.origin.x = imageScrollView.bounds.width * CGFloat(index)
            imageScrollView.addSubview(imageView)
            showImageGesture(at: imageView)
          }
        case .failure(let error):
          print(error)
        }
      }
    }
  }
}

extension ProductDetailViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    imagePageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
  }
}

extension ProductDetailViewController {
  func actionSheetAlert(){
    guard let id = product?.id else {
      return
    }
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    let modification = UIAlertAction(title: "수정", style: .default) { [weak self] (_) in
      self?.presentModification()
    }
    let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
      self.inputPasswordAlertAction(message: "비밀번호를 입력하세요", id: id, identifier: self.identifier, secret: self.secret)
    }
    
    alertController.addAction(cancel)
    alertController.addAction(modification)
    alertController.addAction(delete)
    present(alertController, animated: true, completion: nil)
  }
  
  func presentModification() {
    let presentStoryBoard = UIStoryboard(
      name: ProductRegistrationModificationViewController.stroyBoardName,
      bundle: nil)
    guard let presentViewController = presentStoryBoard.instantiateViewController(
      withIdentifier: ProductRegistrationModificationViewController.reuseIdentifier
    ) as? ProductRegistrationModificationViewController else {
      return
    }
    presentViewController.delegate = self
    presentViewController.product = product
    presentViewController.productImages = productImages
    presentViewController.viewMode = .modification
    self.navigationController?.pushViewController(presentViewController, animated: true)
  }
  
  func inputPasswordAlertAction(
    message: String,
    id: Int,
    identifier: String,
    secret: String
  ) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "취소", style: .cancel)
    let okAction = UIAlertAction(title: "확인", style: .default) { _ in
      if secret == alert.textFields?[0].text {
        self.deleteProduct(id: id, identifier: identifier, secret: secret)
      } else {
        self.showAlert(message: .invalidPassword)
      }
    }
    
    alert.addAction(okAction)
    alert.addAction(cancel)
    alert.addTextField() { textField in
      textField.isSecureTextEntry = true
    }
    self.present(alert, animated: true)
  }
  
  func deleteProduct(id: Int, identifier: String, secret: String) {
    api.getDeleteSecret(productId: id, secret: secret, identifier: identifier) { response in
      switch response {
      case .success(let productSecret):
        self.api.deleteProduct(productId: id, productSecret: productSecret, identifier: identifier) { response in
          switch response {
          case .success(let data):
            DispatchQueue.main.async {
              self.showAlert(message: .productDeleteSucceed(productName: data.name))
            }
          case .failure(_):
            DispatchQueue.main.async {
              self.showAlert(message: .productDeleteFailed)
            }
          }
        }
      case .failure(_):
        DispatchQueue.main.async {
          self.showAlert(message: .productDeleteFailed)
        }
      }
    }
  }
}

extension ProductDetailViewController {
  private func showImageGesture(at imageView: UIImageView) {
    let tapGesture = CustomGesture(target: self, action: #selector(showImageDetail))
    tapGesture.imageView = imageView
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(tapGesture)
  }
  
  @objc private func showImageDetail() {
    let presentStoryBoard = UIStoryboard(
      name: ProductImageDetailViewController.stroyBoardName,
      bundle: nil
    )
    guard let presentViewController = presentStoryBoard.instantiateViewController(
      withIdentifier: ProductImageDetailViewController.reuseIdentifier
    ) as? ProductImageDetailViewController else {
      return
    }
    presentViewController.modalPresentationStyle = .overFullScreen
    presentViewController.images = productImages
    self.present(presentViewController, animated: true)
  }
}
