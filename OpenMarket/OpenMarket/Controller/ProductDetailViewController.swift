import UIKit

class ProductDetailViewController: UIViewController {
    static let storyboardName = "ProductDetail"
    private var product: Product?
    private var productId: Int?
    private var networkTask: NetworkTask?
    private var jsonParser: JSONParser?
    
    convenience init?(
        coder: NSCoder,
        productId: Int,
        networkTask: NetworkTask,
        jsonParser: JSONParser
    ) {
        self.init(coder: coder)
        self.productId = productId
        self.networkTask = networkTask
        self.jsonParser = jsonParser
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = product?.name
        if product?.vendorId == 16 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .edit,
                target: self,
                action: nil
            )
        }
    }
}
