//  Created by Aejong, Tottale on 2022/11/22.

import UIKit

final class AddProductViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }

}
