//
//  ProductRegisterViewController.swift
//  OpenMarket
//
//  Created by Lingo, Quokka on 2022/05/24.
//

import UIKit

fileprivate enum SegmentIndex: Int, CaseIterable {
  case krw = 0
  case usd
  
  var title: String {
    switch self {
    case .krw:
      return "KRW"
    case .usd:
      return "USD"
    }
  }
  
  static var indexs: [String] {
    return Self.allCases.map { $0.title }
  }
}

final class ProductRegisterViewController: UIViewController {
  private enum Const {
    enum Title {
      static let navigationBar = "상품등록"
    }
      
    enum Message {
      static let alertSelect = "선택"
      static let alertCancel = "취소"
      static let alertAlbum = "앨범"
    }
    
    enum Placeholder {
      static let productName = "상품명"
      static let productPrice = "상품가격"
      static let productDiscountPrice = "할인금액"
      static let productStock = "재고수량"
      static let productDescription = "상품 정보를 입력해주세요"
    }
    
    enum Limit {
      static let maximumUploadCount = 6
      static let maximumTextCount = 10
    }
    
    enum UI {
      static let spacing = 20.0
    }
  }
  
  private var keyboardSize: CGRect?
  private var images = [UIImage]()
  
  private let containerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = Const.UI.spacing
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private let imageScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  private let imageStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 10.0
    return stackView
  }()
  
  private lazy var addImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "add")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.isUserInteractionEnabled = true
    let gesture = UITapGestureRecognizer(target: self, action: #selector(addImageViewDidTap))
    imageView.addGestureRecognizer(gesture)
    return imageView
  }()
  
  private let productInputStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 5.0
    return stackView
  }()
  
  private let nameTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.font = .preferredFont(forTextStyle: .subheadline)
    textField.placeholder = Const.Placeholder.productName
    return textField
  }()
  
  private let productPriceStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.spacing = 5.0
    return stackView
  }()
  
  private let priceTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    textField.font = .preferredFont(forTextStyle: .subheadline)
    textField.placeholder = Const.Placeholder.productPrice
    return textField
  }()
  
  private let currencySegment: UISegmentedControl = {
    let segment = UISegmentedControl(items: SegmentIndex.indexs)
    segment.selectedSegmentIndex = SegmentIndex.krw.rawValue
    return segment
  }()
  
  private let discountedPriceTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    textField.font = .preferredFont(forTextStyle: .subheadline)
    textField.placeholder = Const.Placeholder.productDiscountPrice
    return textField
  }()
  
  private let stockTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    textField.font = .preferredFont(forTextStyle: .subheadline)
    textField.placeholder = Const.Placeholder.productStock
    return textField
  }()
  
  private lazy var descriptionsTextView: UITextView = {
    let textView = UITextView()
    textView.text = Const.Placeholder.productDescription
    textView.textColor = .placeholderText
    textView.font = .preferredFont(forTextStyle: .subheadline)
    let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownAction))
    gesture.direction = .down
    textView.addGestureRecognizer(gesture)
    textView.delegate = self
    
    textView.layer.borderColor = UIColor.systemGray5.cgColor
    textView.layer.borderWidth = 1.0
    textView.layer.cornerRadius = 5.0
    return textView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureUI()
    self.configureNavigationItem()
    self.configureNotification()
  }
  
  private func configureNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(textViewDidTap),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(textViewDidTap),
      name: UIResponder.keyboardWillHideNotification,
      object: nil)
  }
  
  @objc private func swipeDownAction(_ sender: UISwipeGestureRecognizer) {
    self.view.endEditing(true)
  }
  
  @objc private func textViewDidTap(notification: Notification) {
    guard let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
          let keyboardSize = userInfo as? CGRect else { return }
    self.keyboardSize = keyboardSize
  }
  
  @objc private func addImageViewDidTap(_ sender: UIImageView) {
    self.presentActionSheet()
  }
  
  private func presentActionSheet() {
    let alert = UIAlertController(
      title: Const.Message.alertSelect,
      message: nil,
      preferredStyle: .actionSheet)
    let cancel = UIAlertAction(
      title: Const.Message.alertCancel,
      style: .cancel)
    let album = UIAlertAction(
      title: Const.Message.alertAlbum,
      style: .default) { [weak self] _ in
      self?.presentAlbum()
    }
    alert.addAction(cancel)
    alert.addAction(album)
    self.present(alert, animated: true)
  }
  
  private func presentAlbum() {
    let pickerController = UIImagePickerController()
    pickerController.sourceType = .photoLibrary
    pickerController.delegate = self
    pickerController.allowsEditing = true
    self.present(pickerController, animated: true)
  }
}

// MARK: - UI

private extension ProductRegisterViewController {
  func configureUI() {
    self.view.backgroundColor = .systemBackground
    self.view.addSubview(containerStackView)
    self.containerStackView.addArrangedSubview(imageScrollView)
    self.containerStackView.addArrangedSubview(productInputStackView)
    self.containerStackView.addArrangedSubview(descriptionsTextView)
    
    self.imageScrollView.addSubview(imageStackView)
    self.imageStackView.addArrangedSubview(addImageView)
    
    self.productPriceStackView.addArrangedSubview(priceTextField)
    self.productPriceStackView.addArrangedSubview(currencySegment)
    
    self.productInputStackView.addArrangedSubview(nameTextField)
    self.productInputStackView.addArrangedSubview(productPriceStackView)
    self.productInputStackView.addArrangedSubview(discountedPriceTextField)
    self.productInputStackView.addArrangedSubview(stockTextField)
    
    NSLayoutConstraint.activate([
      containerStackView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor),
      containerStackView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      containerStackView.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: Const.UI.spacing),
      containerStackView.trailingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.trailingAnchor,
        constant: -Const.UI.spacing),
      
      imageScrollView.heightAnchor.constraint(
        equalToConstant: view.frame.height * 0.16),
      imageStackView.topAnchor.constraint(
        equalTo: imageScrollView.contentLayoutGuide.topAnchor),
      imageStackView.bottomAnchor.constraint(
        equalTo: imageScrollView.contentLayoutGuide.bottomAnchor),
      imageStackView.leadingAnchor.constraint(
        equalTo: imageScrollView.contentLayoutGuide.leadingAnchor),
      imageStackView.trailingAnchor.constraint(
        equalTo: imageScrollView.contentLayoutGuide.trailingAnchor),
      imageStackView.heightAnchor.constraint(
        equalTo: imageScrollView.heightAnchor),
      
      addImageView.widthAnchor.constraint(
        equalTo: addImageView.heightAnchor),
      priceTextField.widthAnchor.constraint(
        equalTo: currencySegment.widthAnchor,
        multiplier: 2.0)
    ])
  }
  
  func configureNavigationItem() {
    self.title = Const.Title.navigationBar
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(closeButtonDidTap))
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(closeButtonDidTap))
  }
  
  @objc func closeButtonDidTap() {
    guard let product = createProductForm() else { return }
    
    let service = APINetworkService(urlSession: URLSession.shared)
    service.registerProduct(product)
    self.dismiss(animated: true)
  }
  
  func createProductForm() -> ProductRequest? {
    guard let productName = nameTextField.text,
          let productPrice = priceTextField.text,
          let discountedPrice = discountedPriceTextField.text,
          let productStock = stockTextField.text,
          let description = descriptionsTextView.text
    else { return nil }
    
    return ProductRequest(
      name: productName,
      price: productPrice,
      currency: currencySegment.selectedSegmentIndex == .zero ? .krw : .usd,
      discountedPrice: discountedPrice,
      stock: productStock,
      description: description,
      images: images
    )
  }
}

// MARK: - Delegate

extension ProductRegisterViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    if textView.text.count > Const.Limit.maximumTextCount {
      textView.deleteBackward()
    }
  }
  
  func textViewDidBeginEditing(_ textView: UITextView) {
    UIView.animate(withDuration: 0.2) {
      guard let keyboardheight = self.keyboardSize?.height else { return }
      self.view.transform = CGAffineTransform(translationX: .zero, y: -keyboardheight * 0.8)
    }
    
    if textView.text == Const.Placeholder.productDescription {
      textView.textColor = .label
      textView.text = nil
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    UIView.animate(withDuration: 0.2) {
      self.view.transform = .identity
    }
    
    if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      textView.textColor = .placeholderText
      textView.text = Const.Placeholder.productDescription
    }
  }
}

extension ProductRegisterViewController: UINavigationControllerDelegate {}
extension ProductRegisterViewController: UIImagePickerControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    if let image = info[.editedImage] as? UIImage {
      let resizedImage = image.resize(with: imageStackView.frame.height)
      self.images.append(resizedImage)
      let imageView = createImageView(with: resizedImage)
      self.imageStackView.insertArrangedSubview(
        imageView,
        at: imageStackView.arrangedSubviews.count - 1
      )
      if imageStackView.arrangedSubviews.count == Const.Limit.maximumUploadCount {
        self.addImageView.isHidden = true
      }
    }
    self.dismiss(animated: true)
  }
  
  private func createImageView(with image: UIImage) -> UIImageView {
    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleToFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
    return imageView
  }
}
