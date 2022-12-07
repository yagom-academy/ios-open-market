//  Created by Aejong, Tottale on 2022/12/07.

import UIKit

class EditProductViewController: AddProductViewController {
    
    let product = Product(id: 1, vendorID: 1, vendorName: "1", name: "1", description: "1", thumbnail: "1", currency: "1", price: 1, bargainPrice: 1, discountedPrice: 1, stock: 1, images: nil, vendors: nil, createdAt: "1", issuedAt: "1")
    
    let images = [UIImage(named: "steven")!]
    
    override func viewDidLoad() {
        self.addView = ProductAddView(product: product, images: images)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        self.navigationItem.title = "상품수정"
    }
    
}
