import UIKit

private enum AlertAction {
    case modify
    case delete
    case cancel
    
    var title: String {
        switch self {
        case .modify:
            return "수정"
        case .delete:
            return "삭제"
        case .cancel:
            return "취소"
        }
    }
}

class ProductDetailViewController: UIViewController {
    private let productDetailScrollView = ProductDetailScrollView()
    private var productDetail: ProductDetail
    
    init(productDetail: ProductDetail) {
        self.productDetail = productDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("스토리보드 안써서 fatalError를 줬습니다.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productDetailScrollView.productImageScrollView.delegate = self
        configUI()
        fetchProductDetail()
    }
    
    func configUI() {
        configNavigationBar()
        view.backgroundColor = .white
        self.view.addSubview(productDetailScrollView)
        productDetailScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productDetailScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            productDetailScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productDetailScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productDetailScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            productDetailScrollView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        ])
    }
    
    func configNavigationBar() {
        self.navigationItem.title = productDetail.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapManageButton))
    }
    
    @objc func didTapManageButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let modifyAction = UIAlertAction(title: AlertAction.modify.title, style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: AlertAction.delete.title, style: .destructive, handler: nil)
        let cancelAction = UIAlertAction(title: AlertAction.cancel.title, style: .cancel, handler: nil)
        
        [modifyAction, deleteAction, cancelAction].forEach { action in
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchProductDetail() {
        productDetailScrollView.productNameLabel.text = productDetail.name
        productDetailScrollView.productStockLabel.attributedText = AttributedTextCreator.createStockText(product: productDetail)
        
        guard let price = productDetail.price.formattedToDecimal,
              let bargainPrice = productDetail.bargainPrice.formattedToDecimal else {
            return
        }
        
        if productDetail.discountedPrice == 0 {
            productDetailScrollView.productPriceLabel.isHidden = true
        } else {
            productDetailScrollView.productPriceLabel.isHidden = false
            productDetailScrollView.productPriceLabel.attributedText = NSMutableAttributedString.strikeThroughStyle(string: "\(productDetail.currency.unit) \(price)")
        }
        
        productDetailScrollView.productBargainPriceLabel.attributedText = NSMutableAttributedString.normalStyle(string: "\(productDetail.currency.unit) \(bargainPrice)")
        productDetailScrollView.productDescriptionTextView.text = productDetail.description
        addProductImageView(from: productDetail.images)
    }
    
    func addProductImageView(from images: [ProductImage]?) {
        guard let images = images else {
            return
        }
        
        let imageWidth: CGFloat = view.frame.width
        
        for index in 0..<images.count {
            let imageView = UIImageView()
            let xPosition = imageWidth * CGFloat(index)
            imageView.image = ImageLoader.loadImage(from: images[index].url)
            imageView.frame = CGRect(x: xPosition, y: 0, width: imageWidth, height: view.frame.height * 0.4)
            imageView.contentMode = .scaleAspectFill
            productDetailScrollView.productImageScrollView.addSubview(imageView)
        }
        
        productDetailScrollView.productImageScrollView.contentSize.width = CGFloat(images.count) * imageWidth
        productDetailScrollView.productImagePageLabel.text = "1/\(Int(productDetailScrollView.productImageScrollView.contentSize.width / imageWidth))"
    }
}

extension ProductDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentMaxWidth = Int(productDetailScrollView.productImageScrollView.contentSize.width)
        let imageWidth = Int(view.frame.width)
        let currentXPosition = Int(productDetailScrollView.productImageScrollView.contentOffset.x)
        let currentPage = (currentXPosition / imageWidth) + 1
        let totalPage = Int(contentMaxWidth / imageWidth)
        productDetailScrollView.productImagePageLabel.text = "\(currentPage)/\(totalPage)"
    }
}
