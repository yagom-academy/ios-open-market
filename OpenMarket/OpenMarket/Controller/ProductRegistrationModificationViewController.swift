//
//  ProductRegistrationModificationViewController.swift
//  OpenMarket
//
//  Created by 박병호 on 2022/01/19.
//

import UIKit

enum ViewMode: String {
  case registation = "상품등록"
  case modification = "상품수정"
}

class ProductRegistrationModificationViewController: productRegisterModification, ImagePickerable, ReuseIdentifying {
  private let api = APIManager(urlSession: URLSession(configuration: .default), jsonParser: JSONParser())
  var product: Product?
  var viewMode: ViewMode?
  var productImages: [UIImage] = []
  
  private let identifer = "3be89f18-7200-11ec-abfa-25c2d8a6d606"
  private let secret = "-7VPcqeCv=Xbu3&P"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addKeyboardNotification()
    setView(mode: viewMode)
    setDescriptionTextView()
  }
  
  @objc private func addImage() {
    guard imageStackView.subviews.count < 6 else {
      showAlert(message: .rangeOfImageCount)
      return
    }
    actionSheetAlertForImage()
  }
  
  @objc private func registerProductButtonDidTap() {
    registerImage()
    guard verfiyImagesCount() == true else {
      return
    }
    registerProduct()
  }
  
  @objc private func modifyProductButtonDidTap() {
    guard let productId = product?.id else {
      return
    }
    modifyProduct(id: productId)
  }
  
  private func registerProduct() {
    do {
      api.registerProduct(
        params: try getProductInformaionForRegistration(secret: secret),
        images: productImages,
        identifier: identifer
      ) { [self] response in
        switch response {
        case .success(_):
          DispatchQueue.main.async {
            navigationController?.popViewController(animated: true)
          }
        case .failure(let error):
          DispatchQueue.main.async {
            showAlert(message: error.localizedDescription)
          }
        }
      }
    } catch let error {
      showAlert(message: error.localizedDescription)
    }
  }
  
  private func modifyProduct(id: Int) {
    do {
      api.modifyProduct(
        productId: id,
        params: try getProductInformaionForModification(secret: secret),
        identifier: identifer
      ) { [self] response in
        switch response {
        case .success(_):
          DispatchQueue.main.async {
            navigationController?.popViewController(animated: true)
          }
        case .failure(let error):
          DispatchQueue.main.async {
            showAlert(message: error.localizedDescription)
          }
        }
      }
    } catch let error {
      showAlert(message: error.localizedDescription)
    }
  }
  
  func registerImage() {
    for subView in imageStackView.subviews {
      if let imageView = subView as? UIImageView,
         let image = imageView.image {
      productImages.append(image)
      }
    }
  }
  
  private func verfiyImagesCount() -> Bool {
    guard productImages.count > 0 else {
      showAlert(message: .rangeOfImageCount)
      return false
    }
    return true
  }
}

extension ProductRegistrationModificationViewController {
  private func setView(mode: ViewMode?) {
    switch mode {
    case .registation:
      configureRegistrationMode()
    case .modification:
      configureModificationMode()
    case .none:
      return
    }
  }
  
  private func configureRegistrationMode() {
    navigationItem.title = ViewMode.registation.rawValue
    doneButton.target = self
    doneButton.action = #selector(registerProductButtonDidTap)
    addImageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
  }
  
  private func configureModificationMode() {
    navigationItem.title = ViewMode.modification.rawValue
    doneButton.target = self
    doneButton.action = #selector(modifyProductButtonDidTap)
    fetchProductDetail(productId: product?.id)
    addImageButton.isHidden = true
  }
}

extension ProductRegistrationModificationViewController {
  private func getProductInformaionForRegistration(secret: String) throws -> ProductRequestForRegistration {
    guard let name = nameTextField.text, name.count > 2 else {
      throw InputError.invalidName
    }
    guard let descriptions = descriptionTextView.text else {
      throw InputError.invalidDescription
    }
    guard let stringFixedPrice = fixedPriceTextField.text,
          let numberFixedPrice = PresentStyle.numberFormatter.number(from: stringFixedPrice),
          let fixedPrice = Double(exactly: numberFixedPrice) else {
      throw InputError.invalidFixedPrice
    }
    guard let stringDiscountedPrice = discountedPriceTextField.text,
          let numberDiscountedPrice = PresentStyle.formatString(stringDiscountedPrice) else {
            throw InputError.invalidOthers
    }
    guard let stringStock = stockTextField.text,
          let numberStock = PresentStyle.formatString(stringStock) else {
            throw InputError.invalidOthers
    }
    let curreny: Currency = currencySegmentControl.selectedSegmentIndex == 0 ? .KRW : .USD

    return ProductRequestForRegistration(
      name: name,
      descriptions: descriptions,
      price: fixedPrice,
      currency: curreny,
      discountedPrice: numberDiscountedPrice,
      stock: Int(numberStock),
      secret: secret
    )
  }
  
  private func getProductInformaionForModification(secret: String) throws -> ProductRequestForModification {
    guard let name = nameTextField.text, name.count > 2 else {
      throw InputError.invalidName
    }
    guard let descriptions = descriptionTextView.text else {
      throw InputError.invalidDescription
    }
    guard let stringFixedPrice = fixedPriceTextField.text,
          let numberFixedPrice = PresentStyle.numberFormatter.number(from: stringFixedPrice),
          let fixedPrice = Double(exactly: numberFixedPrice) else {
      throw InputError.invalidFixedPrice
    }
    guard let stringDiscountedPrice = discountedPriceTextField.text,
          let numberDiscountedPrice = PresentStyle.formatString(stringDiscountedPrice) else {
            throw InputError.invalidOthers
    }
    guard let stringStock = stockTextField.text,
          let numberStock = PresentStyle.formatString(stringStock) else {
            throw InputError.invalidOthers
    }
    let curreny: Currency = currencySegmentControl.selectedSegmentIndex == 0 ? .KRW : .USD
    
    return ProductRequestForModification(
      name: name,
      descriptions: descriptions,
      thumbnailId: nil,
      price: fixedPrice,
      currency: curreny,
      discountedPrice: numberDiscountedPrice,
      stock: Int(numberStock),
      secret: secret
    )
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
        DispatchQueue.main.async {
          fetchImages(images: images)
          setProductDetail(product: data)
        }
      case .failure(let error):
        DispatchQueue.main.async {
          showAlert(message: error.localizedDescription)
        }
      }
    }
  }
  
  private func fetchImages(images: [Image]) {
    for image in images {
      let imageURL = image.thumbnailURL
      appendImageView(url: imageURL)
    }
  }
  
  private func setProductDetail(product: Product) {
    nameTextField.text = product.name
    stockTextField.text = "\(PresentStyle.formatNumber(product.stock))"
    descriptionTextView.text = product.description
    switch product.currency {
    case .KRW:
      currencySegmentControl.selectedSegmentIndex = 0
      fixedPriceTextField.text = "\(PresentStyle.formatNumber(Int(product.price)))"
      discountedPriceTextField.text = "\(PresentStyle.formatNumber(Int(product.discountedPrice)))"
    case .USD:
      currencySegmentControl.selectedSegmentIndex = 1
      fixedPriceTextField.text = "\(product.price)"
      discountedPriceTextField.text = "\(product.discountedPrice)"
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
      showAlert(message: AlertMessage.imageLoadingFailed.description)
      return
    }
    let resizingImage = image.resize(maxBytes: 307200)
    let imageView = appendImageView(image: resizingImage)
    addRemoveGesture(at: imageView)
    dismiss(animated: true, completion: nil)
  }
  
  @discardableResult
  private func appendImageView(url: String) -> UIImageView {
    let imageView = UIImageView()
    imageView.setImage(url: url)
    imageStackView.addArrangedSubview(imageView)
    imageView.heightAnchor.constraint(
      equalTo: imageView.widthAnchor,
      multiplier: 1
    ).isActive = true
    
    return imageView
  }
  
  @discardableResult
  private func appendImageView(image: UIImage?) -> UIImageView {
    let imageView = UIImageView(image: image)
    imageStackView.addArrangedSubview(imageView)
    imageView.heightAnchor.constraint(
      equalTo: imageView.widthAnchor,
      multiplier: 1
    ).isActive = true
    
    return imageView
  }
  
  private func addRemoveGesture(at imageView: UIImageView) {
    let tapGesture = CustomGesture(target: self, action: #selector(removeImageView))
    tapGesture.imageView = imageView
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(tapGesture)
  }
  
  @objc func removeImageView(_ sender: CustomGesture) {
    for subView in imageStackView.subviews {
      if sender.imageView == subView {
        subView.removeFromSuperview()
      }
    }
  }
}

class CustomGesture: UITapGestureRecognizer {
  var imageView: UIImageView?
}
