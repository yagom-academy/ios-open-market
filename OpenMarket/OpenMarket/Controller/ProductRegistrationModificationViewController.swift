//
//  ProductRegistrationModificationViewController.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/19.
//

import UIKit

enum ViewMode {
  case registation
  case modification
}

class ProductRegistrationModificationViewController: productRegister, ImagePickerable, ReuseIdentifying {
  private let api = APIManager(urlSession: URLSession(configuration: .default), jsonParser: JSONParser())
  var product: Product?
  var viewMode: ViewMode? = .modification
  private var productImages: [UIImage] = []
  
  let identifer = "3be89f18-7200-11ec-abfa-25c2d8a6d606"
  let secret = "-7VPcqeCv=Xbu3&P"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addKeyboardNotification()
    setView(mode: viewMode)
  }
  
  func setView(mode: ViewMode?) {
    switch mode {
    case .registation:
      navigationItem.title = "상품등록"
      doneButton.target = self
      doneButton.action = #selector(registerProduct)
      addImageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
    case .modification:
      navigationItem.title = "상품수정"
      doneButton.target = self
      doneButton.action = #selector(modifyProduct)
      fetchProductDetail(productId: product?.id)
      addImageButton.isHidden = true
    case .none:
      return
    }
  }
  
  @objc func addImage() {
    if productImages.count < 5 {
      actionSheetAlertForImage()
    } else {
      showAlert(message: "이미지는 5개까지 등록 가능합니다.")
    }
  }
  
  @objc private func registerProduct() {
    api.registerProduct(
      params: getInformaionForRegistration(secret: secret),
      images: productImages,
      identifier: identifer
    ) { [self] response in
      switch response {
      case .success(_):
        DispatchQueue.main.async {
          navigationController?.popViewController(animated: true)
        }
      case .failure(_):
        DispatchQueue.main.async {
          showAlert(message: "상품등록에 실패 했습니다.\n다시 시도해 주세요")
        }
      }
    }
  }
  
  @objc private func modifyProduct() {
    guard let productId = product?.id else {
      return
    }
    api.modifyProduct(
      productId: productId,
      params: getInformationForModification(secret: secret),
      identifier: identifer
    ) { [self] response in
      switch response {
      case .success(_):
        DispatchQueue.main.async {
          navigationController?.popViewController(animated: true)
        }
      case .failure(_):
        DispatchQueue.main.async {
          showAlert(message: "상품등록에 실패 했습니다.\n다시 시도해 주세요")
        }
      }
    }
  }
  
  func getInformaionForRegistration(secret: String) -> ProductRegistrationRequest {
    let name = nameTextField.text ?? ""
    let fixedPrice = Double(fixedPriceTextField.text ?? "") ?? 0
    let discountedPrice = Double(discountedPriceTextField.text ?? "") ?? 0
    let stock = Int(stockTextField.text ?? "") ?? 0
    let descriptions = descriptionTextView.text ?? ""
    let curreny: Currency = currencySegmentControl.selectedSegmentIndex == 0 ? .KRW : .USD
    
    return ProductRegistrationRequest(name: name, descriptions: descriptions, price: fixedPrice, currency: curreny, discountedPrice: discountedPrice, stock: stock, secret: secret)
  }
  
  func getInformationForModification(secret: String) -> ProductModificationRequest {
    let name = nameTextField.text ?? ""
    let fixedPrice = Double(fixedPriceTextField.text ?? "") ?? 0
    let discountedPrice = Double(discountedPriceTextField.text ?? "") ?? 0
    let stock = Int(stockTextField.text ?? "") ?? 0
    let descriptions = descriptionTextView.text ?? ""
    let curreny: Currency = currencySegmentControl.selectedSegmentIndex == 0 ? .KRW : .USD
    
    return ProductModificationRequest(name: name, descriptions: descriptions, price: fixedPrice, currency: curreny, discountedPrice: discountedPrice, stock: stock, secret: secret)
  }
}


extension ProductRegistrationModificationViewController {
  private func appendImageView(image: UIImage?) {
    let imageView = UIImageView(image: image)
    stackView.addArrangedSubview(imageView)
    imageView.heightAnchor.constraint(
      equalTo: imageView.widthAnchor,
      multiplier: 1
    ).isActive = true
  }
  
  func setProductDetail(product: Product) {
    nameTextField.text = product.name
    fixedPriceTextField.text = "\(product.price)"
    discountedPriceTextField.text = "\(product.bargainPrice)"
    stockTextField.text = "\(product.stock)"
    descriptionTextView.text = product.descriptions
    switch product.currency {
    case .KRW:
      currencySegmentControl.selectedSegmentIndex = 0
    case .USD:
      currencySegmentControl.selectedSegmentIndex = 1
    }
  }
}

extension ProductRegistrationModificationViewController {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    guard let image = info[.editedImage] as? UIImage else {
      dismiss(animated: true, completion: nil)
      showAlert(message: "이미지를 불러오지 못했습니다.")
      return
    }
    let resizingImage = image.resize(maxBytes: 307200)
    productImages.append(resizingImage)
    appendImageView(image: resizingImage)
    dismiss(animated: true, completion: nil)
  }
}

extension ProductRegistrationModificationViewController {
  private func fetchProductDetail(productId: Int?) {
    guard let productId = productId else {
      return
    }
    api.detailProduct(productId: productId) { [self] response in
      switch response {
      case .success(let data):
        guard let images = data.images else {
          return
        }
        for image in images {
          let imageURL = image.thumbnailURL
          fetchImages(url: imageURL)
        }
        DispatchQueue.main.async {
          setProductDetail(product: data)
        }
      case .failure(let error):
        print(error)
        DispatchQueue.main.async {
          showAlert(message: error.errorDescription)
        }
      }
    }
  }
  
  func fetchImages(url: String) {
    api.requestProductImage(url: url) { [self] response in
      switch response {
      case .success(let data):
        let image = UIImage(data: data)
        DispatchQueue.main.async {
          appendImageView(image: image)
        }
      case .failure(let error):
        print(error.errorDescription)
      }
    }
  }
}
