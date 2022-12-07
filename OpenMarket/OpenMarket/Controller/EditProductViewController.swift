//  Created by Aejong, Tottale on 2022/12/07.

import UIKit

class EditProductViewController: AddProductViewController {
        
    init(product: Product, images: [UIImage]) {
        super.init()
        self.productManageView = ProductManageView(product: product, images: images)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        self.navigationItem.title = "상품수정"
    }
    
}
