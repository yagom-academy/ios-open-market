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
    private let productDetailView = ProductDetailScrollView()
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
        configUI()
        fetchProductDetail()
    }
    
    func configUI() {
        configNavigationBar()
        view.backgroundColor = .white
        self.view.addSubview(productDetailView)
        productDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            productDetailView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            productDetailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            productDetailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            productDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
        productDetailView.productNameLabel.text = productDetail.name
        productDetailView.productStockLabel.attributedText = AttributedTextCreator.createStockText(product: productDetail)
        
        guard let price = productDetail.price.formattedToDecimal,
              let bargainPrice = productDetail.bargainPrice.formattedToDecimal else {
            return
        }
        
        if productDetail.discountedPrice == 0 {
            productDetailView.productPriceLabel.isHidden = true
        } else {
            productDetailView.productPriceLabel.isHidden = false
            productDetailView.productPriceLabel.attributedText = NSMutableAttributedString.strikeThroughStyle(string: "\(productDetail.currency.unit) \(price)")
        }
        
        productDetailView.productBargainPriceLabel.attributedText = NSMutableAttributedString.normalStyle(string: "\(productDetail.currency.unit) \(bargainPrice)")
        productDetailView.productDescriptionTextView.text = productDetail.description
    }
}
