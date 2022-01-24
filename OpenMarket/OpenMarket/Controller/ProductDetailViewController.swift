//
//  ProductDetailViewController.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/24.
//

import UIKit

class ProductDetailViewController: UIViewController, ReuseIdentifying {
  
  var product: Product?
  private var productImages: [UIImage] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = product?.name
  }
  
  @IBAction func etcButtonDidTap(_ sender: Any) {
    actionSheetAlert()
  }
}

extension ProductDetailViewController {
  func actionSheetAlert(){
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    let modification = UIAlertAction(title: "수정", style: .default) { [weak self] (_) in
      self?.presentModification()
    }
    let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] (_) in
      self?.deleteProduct()
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
    
    presentViewController.product = product
    presentViewController.productImages = productImages
    presentViewController.viewMode = .modification
    self.navigationController?.pushViewController(presentViewController, animated: true)
  }
  
  func deleteProduct() {
    // STEP2 구현 예정
  }
}
