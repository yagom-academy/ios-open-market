import UIKit

class ProductRegistrationViewController: UIViewController {
    
    typealias Product = ProductDetailQueryManager.Response
    
    enum LayoutAttribute {
        static let largeSpacing: CGFloat = 10
        static let smallSpacing: CGFloat = 5
    }
    
    enum ProductImageAttribute {
        static let minimumImageCount = 1
        static let maximumImageCount = 5
        static let maximumImageBytesSize = 300 * 1024
        static let recommendedImageWidth: CGFloat = 500
        static let recommendedImageHeight: CGFloat = 500
    }
    
    //MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        view = ProductEditingView(viewController: self)
        configure()
    }
    
    //MARK: - Private Method
    private func configure() {
        guard let view = view as? ProductEditingView else {
            return
        }
        
        configureNavigationBar(at: view)
    }
}

//MARK: - NavigationBar
extension ProductRegistrationViewController {
    
    private func configureNavigationBar(at view: ProductEditingView) {
        view.navigationBar.setLeftButton(title: "Cancel", action: #selector(dismissModal))
        view.navigationBar.setMainLabel(title: "상품등록")
        view.navigationBar.setRightButton(title: "Done", action: #selector(registerProduct))
    }
    
    @objc private func dismissModal() {
        dismiss(animated: true)
    }
    
    @objc private func registerProduct() {
        guard let view = view as? ProductEditingView else {
            return
        }
        
        guard let name = view.nameTextField.text,
              let description = view.descriptionTextView.text,
              let priceText = view.priceTextField.text,
              let price = Double(priceText),
              let currency = view.currencySegmentedControl.titleForSegment(at: view.currencySegmentedControl.selectedSegmentIndex),
              let discountedPriceText = view.bargainPriceTextField.text,
              let discountedPrice = Double(discountedPriceText),
              let stockText = view.stockTextField.text else {
                  return
              }
        
        let identifier = Vendor.identifier
        let stock: Int = Int(stockText) ?? 0
        let secret = Vendor.secret
        let images: [Data] = extractedImageDataFromStackView(at: view)
        
        guard (1...5).contains(images.count) else {
            return
        }
        
        NetworkingAPI.ProductRegistration.request(session: URLSession.shared,
                                                  identifier: identifier,
                                                  name: name,
                                                  descriptions: description,
                                                  price: price,
                                                  currency: currency,
                                                  discountedPrice: discountedPrice,
                                                  stock: stock,
                                                  secret: secret,
                                                  images: images) { result in
            
            switch result {
            case .success:
                print("upload success")
            case .failure(let error):
                print(error)
            }
        }

        dismiss(animated: true)
    }
    
    private func extractedImageDataFromStackView(at view: ProductEditingView) -> [Data] {
        var images: [Data] = []
        
        view.imageStackView.arrangedSubviews.forEach {
            guard let imageView = $0 as? UIImageView,
                  let imageData = imageView.image?.jpegData(underBytes: ProductImageAttribute.maximumImageBytesSize) else {
                      print(OpenMarketError.conversionFail("UIImage", "JPEG Data").description)
                      return
                  }
            images.append(imageData)
        }
        
        return images
    }
}
